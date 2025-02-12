import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUserAddresses(String username) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where('username', isEqualTo: username)
          .get();

      List<Map<String, dynamic>> addresses = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('address')) {
          addresses.add({
            'address': data['address'],
            'zipCode': data['zipCode'],
          });
        }
      }
      return addresses;
    } catch (e) {
      print('Error fetching addresses: $e');
      return [];
    }
  }
}
