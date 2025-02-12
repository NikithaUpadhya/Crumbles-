import 'package:crumbles/features/authentication/screens/HistoryScreen/editDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'historydetails.dart';


class HistoryPage extends StatelessWidget {
  static const routeName = '/history';

  const HistoryPage({super.key});

  void _markAsViewed(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({'isNew': false});
  }

  void _deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Donations History'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data!.docs;

          if (posts.isEmpty) {
            return Center(
              child: Text(
                'Please donate to view donation history',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              final postId = posts[index].id;

              return Dismissible(
                key: Key(postId),
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Edit post
                    Get.to(() => EditDetailScreen(postId: postId));
                    return false; // Do not dismiss the item
                  } else if (direction == DismissDirection.endToStart) {
                    // Delete post
                    final bool res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm'),
                          content: Text('Are you sure you wish to delete this post?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('DELETE'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('CANCEL'),
                            ),
                          ],
                        );
                      },
                    );
                    if (res) {
                      _deletePost(postId);
                      return true;
                    }
                    return false;
                  }
                  return false;
                },
                child: GestureDetector(
                  onTap: () {
                    _markAsViewed(postId);
                    Get.to(() => DetailScreen(postId: postId));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white, // Set card color to white
                    child: Container(
                      height: 120, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          colors: [Colors.lightBlueAccent.withOpacity(0.3), Colors.white.withOpacity(0.3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                post['imageUrl'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        post['description'] ?? '',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (post['isNew'] == true)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'New',
                                          style: TextStyle(color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${post['address']}, ${post['zipCode']}',
                                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  (post['timestamp'] as Timestamp).toDate().toString(),
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '(${post['username'] ?? 'No username'})',
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Edit',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 8),
              Icon(Icons.delete, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
