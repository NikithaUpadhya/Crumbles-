import 'package:crumbles/data/repositories/authencation/authentication_repo.dart';
import 'package:crumbles/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/pop%20up/full_screen_loader.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();


  //Variables 

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async{
    try{
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.docerAnimation);

      //form validation 

      if(!forgetPasswordFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email link sent to reset your password'.tr);

      Get.to(() => ResetPassword(email: email.text.trim()));


    } catch (e){ 
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());

    }
  }

  resendPasswordResetEmail(String email) async {
    try{
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.docerAnimation);


      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email link sent to reset your password'.tr);


    } catch (e){ 
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());

    }
  }
}