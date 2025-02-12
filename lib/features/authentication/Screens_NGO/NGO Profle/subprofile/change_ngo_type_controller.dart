import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/screens/profile/profile.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UpdateNGODescriptionController extends GetxController {
  static UpdateNGODescriptionController get instance => Get.find();

  final ngoDescription = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateNGODescriptionFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNGODescription();
    super.onInit();
  }

  Future<void> initializeNGODescription() async {
    ngoDescription.text = userController.user.value.ngoDescription!;
  }

  Future<void> updateNGODescription() async {
    try {
      TFullScreenLoader.openLoadingDialog('We are updating your information...', TImages.docerAnimation);

      if (!updateNGODescriptionFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> description = {'NGODescription': ngoDescription.text.trim()};
      await userRepository.updateSingleField(description);

      userController.user.value.ngoDescription = ngoDescription.text.trim();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your NGO description has been updated.');

      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
