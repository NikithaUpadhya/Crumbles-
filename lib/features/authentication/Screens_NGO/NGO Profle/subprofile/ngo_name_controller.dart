import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/screens/profile/profile.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UpdateNGONameController extends GetxController {
  static UpdateNGONameController get instance => Get.find();

  final ngoName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateNGONameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNGOName();
    super.onInit();
  }

  Future<void> initializeNGOName() async {
    ngoName.text = userController.user.value.ngoName ?? '';
  }

  Future<void> updateNgoName() async {
    try {
      TFullScreenLoader.openLoadingDialog('We are updating your information...', TImages.docerAnimation);

      if (!updateNGONameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> name = {'ngoName': ngoName.text.trim()};
      await userRepository.updateSingleField(name);

      userController.user.value.ngoName = ngoName.text.trim();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your NGO name has been updated.');

      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}

