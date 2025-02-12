
import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/screens/profile/profile.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateNumberController extends GetxController {
  static UpdateNumberController get instance => Get.find();

  final phoneNumber = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    phoneNumber.text = userController.user.value.phoneNumber;
  }

  Future<void> updateNumber() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog('We are updating your information...', TImages.docerAnimation);

      // Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Update user's username in the Firebase Firestore
      Map<String, dynamic> phone = {
        'number': phoneNumber.text.trim(),
      };
      await userRepository.updateSingleField(phone);

      // Update the Rx User value
      userController.user.value.phoneNumber = phoneNumber.text.trim();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Phone number has been updated.');

      // Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
