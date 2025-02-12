import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crumbles/data/repositories/authencation/user_model.dart';
import 'package:crumbles/features/authentication/screens/chat/chatPage.dart';
import 'package:crumbles/features/authentication/screens/chat/chatService.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crumbles/common/appbar/appbar.dart';
import 'package:intl/intl.dart';

class ConversationsTab extends StatelessWidget {
  const ConversationsTab({super.key});

  Future<void> _createChatRoom(BuildContext context, String receiverUserID) async {
    final ChatService _chatService = ChatService();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String currentUserID = _auth.currentUser!.uid;

    String chatRoomID =
        await _chatService.createOrGetChatRoom(currentUserID, receiverUserID);

    // Navigate to the chat page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverUserID: receiverUserID,
          chatRoomID: chatRoomID,
        ),
      ),
    );
  }

  void _showUserSelectionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select User to Chat'),
          backgroundColor: Colors.white,
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading users'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No users found'));
              }

              var users = snapshot.data!.docs.map((doc) => UserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();

              return SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    var networkImage = user.profilePicture;
                    final image = networkImage.isNotEmpty ? NetworkImage(networkImage) : AssetImage(TImages.user);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: image as ImageProvider,
                      ),
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        _createChatRoom(context, user.id);
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate().toLocal(); // Convert to local time
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final ChatService _chatService = ChatService();

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .where('participants', arrayContains: _auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading conversations'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No conversations found'));
                }

                var chatRooms = snapshot.data!.docs;
                chatRooms.sort((a, b) {
                  Timestamp aTimestamp = (a.data() as Map<String, dynamic>).containsKey('lastMessageTimestamp')
                      ? a['lastMessageTimestamp']
                      : Timestamp.now();
                  Timestamp bTimestamp = (b.data() as Map<String, dynamic>).containsKey('lastMessageTimestamp')
                      ? b['lastMessageTimestamp']
                      : Timestamp.now();
                  return bTimestamp.compareTo(aTimestamp);
                });

                return ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    var chatRoom = chatRooms[index];
                    var participants = chatRoom['participants'] as List;
                    participants.remove(_auth.currentUser!.uid);
                    var receiverUserID = participants.first;
                    bool hasUnreadMessages = (chatRoom.data() as Map<String, dynamic>).containsKey('unreadMessages')
                        ? (chatRoom['unreadMessages'][_auth.currentUser!.uid] ?? 0) > 0
                        : false;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(receiverUserID)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            leading: CircleAvatar(
                              child: CircularProgressIndicator(),
                            ),
                            title: Text('Loading...'),
                          );
                        }

                        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text('User not found'),
                          );
                        }

                        var user = UserModel.fromSnapshot(
                            userSnapshot.data as DocumentSnapshot<Map<String, dynamic>>);
                        var networkImage = user.profilePicture;
                        final image = networkImage.isNotEmpty
                            ? NetworkImage(networkImage)
                            : AssetImage(TImages.user);

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chat_rooms')
                              .doc(chatRoom.id)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, messageSnapshot) {
                            if (messageSnapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading messages'));
                            }

                            if (messageSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ListTile(
                                leading: CircleAvatar(
                                  child: CircularProgressIndicator(),
                                ),
                                title: Text('Loading...'),
                              );
                            }

                            if (!messageSnapshot.hasData ||
                                messageSnapshot.data!.docs.isEmpty) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: image as ImageProvider,
                                ),
                                title: Text(user.fullName),
                                subtitle: Text('No messages found'),
                                onTap: () {
                                  _createChatRoom(context, user.id);
                                },
                              );
                            }

                            var latestMessage = messageSnapshot.data!.docs.first;
                            var latestMessageData = latestMessage.data() as Map<String, dynamic>;
                            String latestMessageText = latestMessageData['message'] ?? '';
                            Timestamp latestMessageTimestamp = latestMessageData['timestamp'] ?? Timestamp.now();
                            String formattedTime = _formatTimestamp(latestMessageTimestamp);

                            return Dismissible(
                              key: Key(chatRoom.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                await _chatService.markChatAsDeletedForUser(chatRoom.id, _auth.currentUser!.uid);
                              },
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Deletion"),
                                      content: Text("Are you sure you want to delete this chat?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: image as ImageProvider,
                                    ),
                                    if (hasUnreadMessages)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                title: Text(
                                  user.fullName,
                                  style: TextStyle(
                                    fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                  latestMessageText,
                                  style: TextStyle(
                                    fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                trailing: Text(formattedTime),
                                onTap: () async {
                                  await _chatService.markMessagesAsRead(chatRoom.id, _auth.currentUser!.uid);
                                  _createChatRoom(context, user.id);
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Adjust the width and height as needed
                backgroundColor: Color(0xFF5A77FF), // New button color
              ),
              onPressed: () {
                _showUserSelectionPopup(context);
              },
              child: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }
}
