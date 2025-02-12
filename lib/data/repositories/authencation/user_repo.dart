

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crumbles/data/repositories/authencation/user_model.dart';
import 'package:crumbles/firebase/exceptions/firebase_exception.dart';
import 'package:crumbles/firebase/exceptions/format_exception.dart';
import 'package:crumbles/firebase/exceptions/platfom_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      print("Attempting to save user record: ${user.toJson()}");
      await _db.collection("Users").doc(user.id).set(user.toJson());
      print("User record saved successfully");
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print("FormatException");
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Unknown error: $e");
      throw 'Something went wrong. Please try again.';
    }
  }

  //fetch user details 

  Future<UserModel> fetchUserDetails() async {
    try {
      final DocumentSnapshot = await _db.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).get();

      if (DocumentSnapshot.exists){
        return UserModel.fromSnapshot(DocumentSnapshot);
      } else{
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print("FormatException");
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Unknown error: $e");
      throw 'Something went wrong. Please try again.';
    }
  }


  //update user data 

  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
     await _db.collection("Users").doc(updateUser.id).update(updateUser.toJson());

    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print("FormatException");
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Unknown error: $e");
      throw 'Something went wrong. Please try again.';
    }
  }

  // update any field in specific user collection

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
     await _db.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).update(json);

    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print("FormatException");
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Unknown error: $e");
      throw 'Something went wrong. Please try again.';
    }
  }

  

  // function to remove user data from firestore 

   Future<void> removeUserRecord(String userId) async {
    try {
     await _db.collection("Users").doc(userId).delete();

    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print("FormatException");
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Unknown error: $e");
      throw 'Something went wrong. Please try again.';
    }
  }


  //upload any image
  Future<String> uploadImage(String path, XFile image) async{

    try {
     final ref = FirebaseStorage.instance.ref(path).child(image.name);
     await ref.putFile(File(image.path));
     final url = await ref.getDownloadURL();
     return url;

    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print("FormatException");
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Unknown error: $e");
      throw 'Something went wrong. Please try again.';
    }

  }


}
