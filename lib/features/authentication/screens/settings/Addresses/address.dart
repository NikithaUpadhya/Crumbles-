import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/features/authentication/screens/settings/Addresses/SingleAdd.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';

import 'package:crumbles/features/authentication/screens/settings/Addresses/Addnewad.dart';

class UserAddressScreen extends StatelessWidget {
  final UserController userController = Get.find();
  final AddressRepository addressRepository = AddressRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar( 
        showBackArrow: true,
        title: Text("My Addresses"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: addressRepository.fetchUserAddresses(userController.user.value.username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching addresses'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No addresses found'));
          }

          List<Map<String, dynamic>> addresses = snapshot.data!;
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return TSingleAddress(
                username: userController.user.value.username,
                address: addresses[index]['address'],
                zipCode: addresses[index]['zipCode'],
              );
            },
          );
        },
      ),
    );
  }
}
