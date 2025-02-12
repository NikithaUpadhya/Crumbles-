import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';

class DetailScreen extends StatelessWidget {
  final String postId;

  DetailScreen({required this.postId});

  static const routeName = '/detail';

  final UserController userController = Get.find();

  void _openInMaps(String address) async {
    String query = Uri.encodeComponent(address);
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').doc(postId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found'));
          }

          final post = snapshot.data!.data() as Map<String, dynamic>;
          final profilePicture = userController.user.value.profilePicture.isNotEmpty
              ? userController.user.value.profilePicture
              : null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        post['imageUrl'],
                        fit: BoxFit.cover,
                        height: 300,
                        width: 500,
                      ),
                    ),
                  SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      post['description'] ?? '',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        if (profilePicture != null)
                          CircleAvatar(
                            backgroundImage: NetworkImage(profilePicture),
                          )
                        else
                          CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        SizedBox(width: 8),
                        Text(
                          post['username'] ?? 'No username',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Cooking Time',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post['cookingTime'] ?? ''),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Quantity',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${post['foodQuantity']} people'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Address',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post['address'] ?? ''),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Zip Code',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post['zipCode'] ?? ''),
                  ),
                  TextButton(
                    onPressed: () => _openInMaps(post['address']),
                    child: Text('Open location in map'),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Timestamp',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text((post['timestamp'] as Timestamp).toDate().toString()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
