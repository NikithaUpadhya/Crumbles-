import 'package:crumbles/features/authentication/screens/chat/chatService.dart';
import 'package:crumbles/features/authentication/screens/chat/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserID;
  final String chatRoomID;
  final bool isGroupChat;

  const ChatPage({
    Key? key,
    required this.receiverUserID,
    required this.chatRoomID,
    this.isGroupChat = false,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String receiverUserName = '';
  String currentUserName = '';
  String receiverProfilePicture = '';

  @override
  void initState() {
    super.initState();
    _fetchReceiverUserName();
    _fetchCurrentUserName();
    _markMessagesAsRead();
  }

  Future<void> _fetchReceiverUserName() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.receiverUserID)
        .get();
    var userData = userDoc.data();
    if (userData != null) {
      setState(() {
        receiverUserName = '${userData['FirstName']} ${userData['LastName']}';
        receiverProfilePicture = userData['ProfilePicture'] ?? '';
      });
    }
  }

  Future<void> _fetchCurrentUserName() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    var userData = userDoc.data();
    if (userData != null) {
      setState(() {
        currentUserName = '${userData['FirstName']} ${userData['LastName']}';
      });
    }
  }

  Future<void> _markMessagesAsRead() async {
    await _chatService.markMessagesAsRead(widget.chatRoomID, _firebaseAuth.currentUser!.uid);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.chatRoomID,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 30,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    String senderName = isCurrentUser ? currentUserName : receiverUserName;
    Color bubbleColor = isCurrentUser ? Colors.black : Color(0xFF5A77FF);

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser) // Show sender name only for received messages
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(senderName),
              ),
            ChatBubble(message: data['message'], color: bubbleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.chatRoomID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/onboarding_image/chat.json', // Replace with your Lottie animation path
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 0),
                Text(
                  'Start Chatting',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        var documents = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(documents[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (receiverProfilePicture.isNotEmpty)
              CircleAvatar(
                backgroundImage: NetworkImage(receiverProfilePicture),
              ),
            SizedBox(width: 8),
            Text(receiverUserName.isNotEmpty ? receiverUserName : 'Loading...'),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
