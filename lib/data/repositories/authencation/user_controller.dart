import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crumbles/data/repositories/authencation/authentication_repo.dart';
import 'package:crumbles/data/repositories/authencation/user_model.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/screens/login/login.dart';
import 'package:crumbles/features/authentication/screens/profile/sub%20profiles/re_authenticate.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var unreadMessagesCount = 0.obs;

  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  final profileLoading = false.obs;
  final imageUploading = false.obs;
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();


  @override
  void onInit() { 
    super.onInit();
    fetchUserRecord();
  }


  //fetch user record 

  Future<void> fetchUserRecord() async{
    try{ 
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e){ 
      user(UserModel.empty());
    } finally{
      profileLoading.value = false;
    }
  }


  void _monitorUnreadMessages() {
    FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: _auth.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      int count = 0;
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('unreadMessages')) {
          count += (data['unreadMessages'][_auth.currentUser!.uid] ?? 0) as int;
        }
      }
      unreadMessagesCount.value = count;
    });
  }


  // Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials, String userType, {String? ngoName, String? ngoType, String? ngoDescription}) async {
    try {
      //refresh user record 
      if (userCredentials != null) {
        // Convert Name to First and Last Name
        final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
        final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

        // Map Data
        final user = UserModel(
          id: userCredentials.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          username: username,
          email: userCredentials.user!.email ?? '',
          phoneNumber: userCredentials.user!.phoneNumber ?? '',
          profilePicture: userCredentials.user!.photoURL ?? '', 
          userType: userType,
          ngoName: userType == 'NGO' ? ngoName : null,
          ngoType: userType == 'NGO' ? ngoType : null,
          ngoDescription: userType == 'NGO' ? ngoDescription : null,
        );

        // Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    }
  }




  /// Delete Account Warning
void deleteAccountWarningPopup() {
  Get.defaultDialog(
    contentPadding: const EdgeInsets.all(TSizes.md),
    title: 'Delete Account',
    middleText: 'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
    confirm: ElevatedButton(
      onPressed: () async => deleteUserAccount(),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
        child: Text('Delete'),
      ),
    ), // ElevatedButton
    cancel: OutlinedButton(
      child: const Text('Cancel'),
      onPressed: () => Navigator.of(Get.overlayContext!).pop(),
    ), // OutlinedButton
  );
}

//delete user account 
void deleteUserAccount() async {
  try {
    TFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);

    /// First re-authenticate user
    final auth = AuthenticationRepository.instance;
    final provider = auth.authUser!.providerData.map((e) => e.providerId).first;

    if (provider.isNotEmpty) {
      if (provider == 'password') {
        TFullScreenLoader.stopLoading();
        Get.to(() => const ReAuthLoginForm());
      } else {
        // Handle other providers if necessary
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(title: 'Oh Snap!', message: 'Unsupported authentication provider.');
      }
    }
  } catch (e) {
    TFullScreenLoader.stopLoading();
    TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
  }
}



// RE-AUTHENTICATE before deleting
Future<void> reAuthenticateEmailAndPasswordUser() async {
  try {
    TFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);

    if (!reAuthFormKey.currentState!.validate()) {
      TFullScreenLoader.stopLoading();
      return;
    }

    await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(
      verifyEmail.text.trim(),
      verifyPassword.text.trim(),
    );
    await AuthenticationRepository.instance.deleteAccount();
    TFullScreenLoader.stopLoading();
    Get.offAll(() => const LoginScreen());
  } catch (e) {
    TFullScreenLoader.stopLoading();
    TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
  }
}


uploadUserProfilePicture() async{
  try{
  final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
  if (image != null){
    imageUploading.value = true;
    final imageUrl = await userRepository.uploadImage('Users/Images/Profile', image);
    //update image 
    Map<String, dynamic> json = {'ProfilePicture': imageUrl};
    await userRepository.updateSingleField(json);

    user.value.profilePicture = imageUrl;
    user.refresh();
    TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Profile Picture has been updated');

  }
  }catch(e){
    TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());

} finally{
  imageUploading.value = false;
}



}


}