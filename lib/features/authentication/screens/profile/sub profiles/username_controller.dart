
import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/screens/profile/profile.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUsernameController extends GetxController {
  static UpdateUsernameController get instance => Get.find();

  final username = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey1 = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    username.text = userController.user.value.username;
  }

  Future<void> updateUserNamename() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog('We are updating your information...', TImages.docerAnimation);

      // Form Validation
      if (!updateUserNameFormKey1.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Update user's username in the Firebase Firestore
      Map<String, dynamic> userName = {
        'username': username.text.trim(),
      };
      await userRepository.updateSingleField(userName);

      // Update the Rx User value
      userController.user.value.username = username.text.trim();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Username has been updated.');

      // Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
