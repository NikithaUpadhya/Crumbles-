// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crumbles/features/authentication/Screens_NGO/food_receiving/NGO_foodView.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:url_launcher/url_launcher.dart';

// class FoodDetailPage extends StatelessWidget {
//   final String postId;
//   final String status;
//   final VoidCallback onAccept;

//   const FoodDetailPage({
//     required this.postId,
//     required this.status,
//     required this.onAccept,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Food Detail'),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('posts').doc(postId).get(),
//         builder: (context, postSnapshot) {
//           if (postSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!postSnapshot.hasData || postSnapshot.data == null || postSnapshot.data!.data() == null) {
//             print('Post data not found for postId: $postId');
//             return Center(child: Text('Post not found'));
//           }

//           final postData = postSnapshot.data!.data() as Map<String, dynamic>;
//           print('Post data: $postData');

//           String userId = postData['userId'] ?? '';
//           if (userId.isEmpty) {
//             return Center(child: Text('User ID not found in post data'));
//           }

//           return FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
//             builder: (context, userSnapshot) {
//               if (userSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (!userSnapshot.hasData || userSnapshot.data == null || userSnapshot.data!.data() == null) {
//                 print('User data not found for userId: $userId');
//                 return Center(child: Text('User not found'));
//               }

//               final userData = userSnapshot.data!.data() as Map<String, dynamic>;
//               print('User data: $userData');

//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(16.0),
//                               child: Image.network(
//                                 postData['imageUrl'] ?? 'https://via.placeholder.com/150',
//                                 width: double.infinity,
//                                 height: 250,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   postData['description'] ?? 'No description',
//                                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 8.0),
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundImage: NetworkImage(userData['ProfilePicture'] ?? 'https://via.placeholder.com/150'),
//                                       radius: 20,
//                                     ),
//                                     const SizedBox(width: 8.0),
//                                     Text(
//                                       userData['Username'] ?? 'Unknown User',
//                                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 buildInfoRow('Cooking Time', postData['cookingTime'] ?? 'N/A'),
//                                 buildInfoRow('Quantity', 'For ${postData['foodQuantity'] ?? 'N/A'} People'),
//                                 buildInfoRow('Address', postData['address'] ?? 'N/A'),
//                                 buildInfoRow('Zip Code', postData['zipCode'] ?? 'N/A'),
//                                 TextButton(
//                                   onPressed: () {
//                                     String address = postData['address'];
//                                     String query = Uri.encodeComponent(address);
//                                     String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$query";
//                                     launch(googleMapsUrl);
//                                   },
//                                   child: Text(
//                                     'Open in Maps',
//                                     style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 15),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                 const SizedBox(height: 8),
//                                 Text('Phone Number: ${userData['PhoneNumber']}'),
//                                 const SizedBox(height: 8),
//                                 Text('Email: ${userData['Email']}'),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (status != 'Done') // Conditionally display the button
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           if (postData['status'] == 'Pending') {
//                             // Update the status to "Done"
//                             await FirebaseFirestore.instance.collection('posts').doc(postId).update({'status': 'Done'});

//                             // Show pop-up dialog
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text('Completed!'),
//                                   content: Text('You have completed and received the donation.'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       child: Text('Close'),
//                                       onPressed: () {
//                                         Navigator.of(context).pop(); // Close the dialog
//                                         Get.off(() => const FoodView()); // Navigate back and refresh
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           } else {
//                             // Update the status to "Pending"
//                             await FirebaseFirestore.instance.collection('posts').doc(postId).update({'status': 'Pending'});

//                             // Show pop-up dialog
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text('Thank you!'),
//                                   content: Text('Thank you for accepting the food donation.'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       child: Text('Close'),
//                                       onPressed: () {
//                                         Navigator.of(context).pop(); // Close the dialog
//                                         Get.off(() => const FoodView()); // Navigate back and refresh
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           }
//                         },
//                         child: Text(postData['status'] == 'Pending' ? 'Complete' : 'Accept'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: postData['status'] == 'Pending' ? Colors.green : Colors.blue,
//                           minimumSize: Size(double.infinity, 50),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget buildInfoRow(String title, String content) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4.0),
//           Text(
//             content,
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }
