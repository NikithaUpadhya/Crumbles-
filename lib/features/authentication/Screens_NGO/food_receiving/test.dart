// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crumbles/common/Containers/primaryHeaderContainer.dart';
// import 'package:crumbles/features/authentication/Screens_NGO/food_receiving/foodDetails.dart';
// import 'package:crumbles/features/authentication/Screens_NGO/food_receiving/statusBox.dart';
// import 'package:crumbles/utils/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';

// class FoodView extends StatelessWidget {
//   const FoodView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // header
//           StreamBuilder<Map<String, int>>(
//             stream: fetchStatusCounts(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return CircularProgressIndicator();
//               }

//               final counts = snapshot.data!;
//               return TPrimaryHeaderContainer(
//                 child: Column(
//                   children: [
//                     SizedBox(height: TSizes.spaceBtwSections),
//                     SizedBox(height: TSizes.spaceBtwSections),
//                     Text(
//                       'Request Status',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: TSizes.spaceBtwSections),
//                     SizedBox(height: TSizes.spaceBtwSections),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         StatusBox(status: 'New', count: counts['New']!),
//                         StatusBox(status: 'Pending', count: counts['Pending']!),
//                         StatusBox(status: 'Done', count: counts['Done']!),
//                       ],
//                     ),
//                     SizedBox(height: TSizes.spaceBtwSections),
//                     SizedBox(height: TSizes.spaceBtwSections),
//                   ],
//                 ),
//               );
//             },
//           ),
//           // Custom Tab Bar
//           StreamBuilder<Map<String, int>>(
//             stream: fetchStatusCounts(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return CircularProgressIndicator();
//               }

//               final counts = snapshot.data!;
//               return DefaultTabController(
//                 length: 3,
//                 child: Expanded(
//                   child: Column(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.all(Radius.circular(10)),
//                           border: Border.all(color: Color(0xFF5a77ff)),
//                         ),
//                         child: TabBar(
//                           indicator: BoxDecoration(
//                             color: Color(0xFF5a77ff),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           labelColor: Colors.white,
//                           unselectedLabelColor: Color(0xFF5a77ff),
//                           indicatorSize: TabBarIndicatorSize.tab,
//                           tabs: [
//                             Tab(text: 'New ${counts['New']}'),
//                             Tab(text: 'Pending ${counts['Pending']}'),
//                             Tab(text: 'Done ${counts['Done']}'),
//                           ],
//                         ),
//                       ),
//                       // TabBarView
//                       Expanded(
//                         child: TabBarView(
//                           children: [
//                             StreamRequestListView(status: 'New'),
//                             StreamRequestListView(status: 'Pending'),
//                             StreamRequestListView(status: 'Done'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// Stream<Map<String, int>> fetchStatusCounts() {
//   return FirebaseFirestore.instance.collection('posts').snapshots().map((snapshot) {
//     int newCount = 0;
//     int pendingCount = 0;
//     int doneCount = 0;

//     for (var doc in snapshot.docs) {
//       var data = doc.data() as Map<String, dynamic>;
//       if (data['status'] == 'New') {
//         newCount++;
//       } else if (data['status'] == 'Pending') {
//         pendingCount++;
//       } else if (data['status'] == 'Done') {
//         doneCount++;
//       }
//     }

//     return {
//       'New': newCount,
//       'Pending': pendingCount,
//       'Done': doneCount,
//     };
//   });
// }


// void fetchPendingRequests() async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('posts')
//       .where('status', isEqualTo: 'Pending')
//       .get();

//   print('Total pending requests: ${querySnapshot.docs.length}');
//   querySnapshot.docs.forEach((doc) {
//     print('Document ID: ${doc.id}');
//     print('Document Data: ${doc.data()}');
//   });
// }


// class StreamRequestListView extends StatelessWidget {
//   final String status;

//   const StreamRequestListView({required this.status});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('posts').where('status', isEqualTo: status).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (!snapshot.hasData) {
//           print('No data received');
//           return Center(child: Text('No requests found'));
//         }
//         if (snapshot.data!.docs.isEmpty) {
//           print('No documents found for status: $status');
//           return Center(child: Text('No requests found'));
//         }

//         final requests = snapshot.data!.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           print('Fetched post: $data'); // Add this line to log fetched data
//           return RequestCard(
//             postId: doc.id,
//             imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
//             title: data['description'] ?? 'No description',
//             foodFor: (data['foodQuantity'] ?? 0).toString(),
//             cookingTime: data['cookingTime'] ?? 'Unknown time',
//             location: data['address'] ?? 'Unknown location',
//             status: data['status'] ?? 'Unknown status', // Pass the status
//             onAccept: () {
//               // Callback to refresh the view
//               Get.off(() => const FoodView());
//             },
//           );
//         }).toList();

//         print('Number of requests: ${requests.length}'); // Log the number of requests

//         return RequestListView(requests: requests);
//       },
//     );
//   }
// }




// class RequestListView extends StatelessWidget {
//   final List<RequestCard> requests;

//   const RequestListView({required this.requests});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: requests.length,
//         itemBuilder: (context, index) {
//           return requests[index];
//         },
//       ),
//     );
//   }
// }



// class StatusChip extends StatelessWidget {
//   final String status;

//   const StatusChip({required this.status});

//   @override
//   Widget build(BuildContext context) {
//     Color backgroundColor;
//     Color textColor;
//     String displayText;

//     switch (status) {
//       case 'Pending':
//         backgroundColor = Colors.red[100]!;
//         textColor = Colors.red[700]!;
//         displayText = 'Pending';
//         break;
//       case 'Done':
//         backgroundColor = Colors.green[100]!;
//         textColor = Colors.green[700]!;
//         displayText = 'Completed';
//         break;
//       default:
//         backgroundColor = Colors.blue[100]!;
//         textColor = Colors.blue[700]!;
//         displayText = 'New';
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         displayText,
//         style: TextStyle(
//           color: textColor,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }


// class RequestCard extends StatelessWidget {
//   final String postId;
//   final String imageUrl;
//   final String title;
//   final String foodFor;
//   final String cookingTime;
//   final String location;
//   final String status; // Add status field
//   final VoidCallback onAccept; // Add this line

//   const RequestCard({
//     required this.postId,
//     required this.imageUrl,
//     required this.title,
//     required this.foodFor,
//     required this.cookingTime,
//     required this.location,
//     required this.status, // Add this line
//     required this.onAccept, // Add this line
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => FoodDetailPage(postId: postId, status: status, onAccept: onAccept)); // Pass the status
//       },
//       child: Card(
//         color: Colors.white,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: BorderSide(color: Color(0xFF4867ff)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Stack(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.network(
//                     imageUrl,
//                     width: 80,
//                     height: 80,
//                     fit: BoxFit.cover,
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Food for: $foodFor',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Cooking Time: $cookingTime',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Location: $location',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: StatusChip(status: status), // Add the StatusChip widget
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

