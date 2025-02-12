import 'package:crumbles/data/repositories/authencation/authentication_repo.dart';
import 'package:crumbles/data/repositories/authencation/user_model.dart';
import 'package:crumbles/data/repositories/authencation/user_repo.dart';
import 'package:crumbles/features/authentication/screens/signUp/verify_email.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstname = TextEditingController();
  final phoneNumber = TextEditingController();
  final ngoName = TextEditingController();
  final ngoDescription = TextEditingController();
  final selectedRole = 'NGO'.obs;
  final selectedNgoType = 'NGO1'.obs;

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  /// -- SIGNUP
  void signup() async {
    try {
      TFullScreenLoader.openLoadingDialog('We are processing your information...', TImages.docerAnimation);

      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
        );
        return;
      }

      await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      final newUser = UserModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        firstName: firstname.text.trim(),
        lastName: lastname.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
        userType: selectedRole.value,
        ngoName: selectedRole.value == 'NGO' ? ngoName.text.trim() : null,
        ngoType: selectedRole.value == 'NGO' ? selectedNgoType.value : null,
        ngoDescription: selectedRole.value == 'NGO' ? ngoDescription.text.trim() : null,
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your account has been created! Verify email to continue.');

      Get.to(() => VerfiyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'On snap!', message: e.toString());
    }
  }
}
