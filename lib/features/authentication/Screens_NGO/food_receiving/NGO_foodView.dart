import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crumbles/common/Containers/primaryHeaderContainer.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/features/authentication/Screens_NGO/food_receiving/foodDetails.dart';
import 'package:crumbles/features/authentication/Screens_NGO/food_receiving/statusBox.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class FoodView extends StatelessWidget {
  const FoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // header
          StreamBuilder<Map<String, int>>(
            stream: fetchStatusCounts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final counts = snapshot.data!;
              return TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      'Request Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(height: TSizes.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatusBox(status: 'New', count: counts['New']!),
                        StatusBox(status: 'Pending', count: counts['Pending']!),
                        StatusBox(status: 'Done', count: counts['Done']!),
                      ],
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              );
            },
          ),
          // Custom Tab Bar
          StreamBuilder<Map<String, int>>(
            stream: fetchStatusCounts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final counts = snapshot.data!;
              return DefaultTabController(
                length: 3,
                child: Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Color(0xFF5a77ff)),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Color(0xFF5a77ff),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Color(0xFF5a77ff),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(text: 'New ${counts['New']}'),
                            Tab(text: 'Pending ${counts['Pending']}'),
                            Tab(text: 'Done ${counts['Done']}'),
                          ],
                        ),
                      ),
                      // TabBarView
                      Expanded(
                        child: TabBarView(
                          children: [
                            StreamRequestListView(status: 'New'),
                            StreamRequestListView(status: 'Pending'),
                            StreamRequestListView(status: 'Done'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Stream<Map<String, int>> fetchStatusCounts() {
  final userController = UserController.instance;
  final currentUserId = userController.user.value.id;

  return FirebaseFirestore.instance.collection('posts').snapshots().asyncMap((snapshot) async {
    int newCount = 0;
    int pendingCount = 0;
    int doneCount = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['status'] == 'New') {
        newCount++;
      } else if (data['status'] == 'Pending' || data['status'] == 'Done') {
        final ngoSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .doc(doc.id)
            .collection('NGOs')
            .doc(currentUserId)
            .get();
        if (ngoSnapshot.exists) {
          if (data['status'] == 'Pending') {
            pendingCount++;
          } else if (data['status'] == 'Done') {
            doneCount++;
          }
        }
      }
    }

    return {
      'New': newCount,
      'Pending': pendingCount,
      'Done': doneCount,
    };
  });
}

class StreamRequestListView extends StatelessWidget {
  final String status;

  const StreamRequestListView({required this.status});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final currentUserId = userController.user.value.id;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').where('status', isEqualTo: status).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          print('No data received');
          return Center(child: Text('No requests found'));
        }
        if (snapshot.data!.docs.isEmpty) {
          print('No documents found for status: $status');
          return Center(child: Text('No requests found'));
        }

        return FutureBuilder<List<RequestCard>>(
          future: _buildRequestCards(snapshot.data!.docs, currentUserId, status),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (asyncSnapshot.hasError) {
              return Center(child: Text('Error: ${asyncSnapshot.error}'));
            }
            if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
              print('No documents found for status: $status');
              return Center(child: Text('No requests found'));
            }

            return RequestListView(requests: asyncSnapshot.data!);
          },
        );
      },
    );
  }

  Future<List<RequestCard>> _buildRequestCards(List<DocumentSnapshot> docs, String currentUserId, String status) async {
    List<RequestCard> requests = [];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final ngoSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(doc.id)
          .collection('NGOs')
          .doc(currentUserId)
          .get();
      if ((status == 'Pending' || status == 'Done') && !ngoSnapshot.exists) {
        continue;
      }
      print('Fetched post: $data'); // Add this line to log fetched data
      requests.add(RequestCard(
        postId: doc.id,
        imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
        title: data['description'] ?? 'No description',
        foodFor: (data['foodQuantity'] ?? 0).toString(),
        cookingTime: data['cookingTime'] ?? 'Unknown time',
        location: data['address'] ?? 'Unknown location',
        status: data['status'] ?? 'Unknown status', // Pass the status
        onAccept: () {
          // Callback to refresh the view
          Get.off(() => const FoodView());
        },
      ));
    }
    return requests;
  }
}

class RequestListView extends StatelessWidget {
  final List<RequestCard> requests;

  const RequestListView({required this.requests});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return requests[index];
        },
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'Pending':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        displayText = 'Pending';
        break;
      case 'Done':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        displayText = 'Completed';
        break;
      default:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        displayText = 'New';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String postId;
  final String imageUrl;
  final String title;
  final String foodFor;
  final String cookingTime;
  final String location;
  final String status; // Add status field
  final VoidCallback onAccept; // Add this line

  const RequestCard({
    required this.postId,
    required this.imageUrl,
    required this.title,
    required this.foodFor,
    required this.cookingTime,
    required this.location,
    required this.status, // Add this line
    required this.onAccept, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final currentUserId = userController.user.value.id;

    return GestureDetector(
      onTap: () {
        Get.to(() => FoodDetailPage(postId: postId, status: status, onAccept: onAccept)); // Pass the status
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFF4867ff)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Food for: $foodFor',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Cooking Time: $cookingTime',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Location: $location',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (status == 'Pending') // Add trash icon conditionally
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Handle delete action
                          _showDeleteConfirmation(context, postId, currentUserId);
                        },
                      ),
                    ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: StatusChip(status: status), // Add the StatusChip widget
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String postId, String currentUserId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Request'),
          content: Text('Are you sure you want to delete this request?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                // Update the status to 'New'
                await FirebaseFirestore.instance.collection('posts').doc(postId).update({'status': 'New'});
                // Remove the user ID from the NGO subcollection
                await FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .collection('NGOs')
                    .doc(currentUserId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
