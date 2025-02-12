import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createOrGetChatRoom(String userId, String receiverId) async {
    List<String> userIds = [userId, receiverId];
    userIds.sort();
    String chatRoomId = userIds.join('_');

    DocumentReference chatRoomRef =
        _firestore.collection('chat_rooms').doc(chatRoomId);
    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      await chatRoomRef.set({
        'participants': userIds,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'unreadMessages': {
          userId: 0,
          receiverId: 0,
        },
        'deletedFor': [], // Initialize the deletedFor field
      });
    } else {
      Map<String, dynamic> data = chatRoomSnapshot.data() as Map<String, dynamic>;
      if (!data.containsKey('unreadMessages')) {
        await chatRoomRef.update({
          'unreadMessages': {
            userId: 0,
            receiverId: 0,
          },
        });
      }
      if (!data.containsKey('lastMessageTimestamp')) {
        await chatRoomRef.update({
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
        });
      }
      if (!data.containsKey('deletedFor')) {
        await chatRoomRef.update({
          'deletedFor': [], // Initialize the deletedFor field
        });
      }
    }

    return chatRoomId;
  }

  Future<void> sendMessage(String chatRoomId, String message) async {
    String currentUserId = _auth.currentUser!.uid;

    DocumentReference chatRoomRef =
        _firestore.collection('chat_rooms').doc(chatRoomId);
    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    if (chatRoomSnapshot.exists) {
      Map<String, dynamic> data = chatRoomSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> unreadMessages = data.containsKey('unreadMessages')
          ? data['unreadMessages']
          : {};

      unreadMessages.forEach((key, value) {
        if (key != currentUserId) {
          unreadMessages[key] = value + 1;
        }
      });

      await chatRoomRef.collection('messages').add({
        'senderId': currentUserId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await chatRoomRef.update({
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'unreadMessages': unreadMessages,
      });
    }
  }

  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    DocumentReference chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId);
    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    if (chatRoomSnapshot.exists) {
      Map<String, dynamic> data = chatRoomSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> unreadMessages = data.containsKey('unreadMessages')
          ? data['unreadMessages']
          : {};

      unreadMessages[userId] = 0;

      await chatRoomRef.update({
        'unreadMessages': unreadMessages,
      });
    }
  }


  Future<void> markChatAsDeletedForUser(String chatRoomId, String userId) async {
    DocumentReference chatRoomRef =
        _firestore.collection('chat_rooms').doc(chatRoomId);

    await chatRoomRef.update({
      'deletedFor': FieldValue.arrayUnion([userId]),
    });
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

