import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/screens/profile/profile.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UpdateNGOTypeController extends GetxController {
  static UpdateNGOTypeController get instance => Get.find();

  final ngoType = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateNGOTypeFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNGOType();
    super.onInit();
  }

  Future<void> initializeNGOType() async {
    ngoType.text = userController.user.value.ngoType!;
  }

  Future<void> updateNGOType() async {
    try {
      TFullScreenLoader.openLoadingDialog('We are updating your information...', TImages.docerAnimation);

      if (!updateNGOTypeFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> type = {'NGOType': ngoType.text.trim()};
      await userRepository.updateSingleField(type);

      userController.user.value.ngoType = ngoType.text.trim();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your NGO type has been updated.');

      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
