import 'dart:async';

import 'package:crumbles/common/styles/success_Screen/success_screen.dart';
import 'package:crumbles/data/repositories/authencation/authentication_repo.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/pop%20up/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
 void onInit(){
  sendEmailVerification();
  setTimerForAutoRediret();
  super.onInit();
 }

 /// Send Email Verification link
 sendEmailVerification() async {
  try{

    await AuthenticationRepository.instance.sendEmailVerification();
    TLoaders.successSnackBar(title: 'Email sent', message: 'Pleae check you inbox and verify your email. ');

  } catch(e){
    TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
  }
 }

/// Timer to automatically redirect on Email Verification
setTimerForAutoRediret(){
  Timer.periodic(const Duration(seconds: 1), (timer) async { 
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if(user?.emailVerified ??  false){ 
      timer.cancel();
      Get.off(() => SuccessScreen(image: TImages.sucessRegister, title: TTexts.yourAccountCreatedTitle, subtitle: TTexts.yourAccountCreatedSubTitle, onPressed: () => AuthenticationRepository.instance.screenRedirect()) );
    }


  });

}

/// Manually Check if Email Verified
checkEmailVerificationStatus() async{
  final currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null && currentUser.emailVerified){
    Get.off(
      () => SuccessScreen( 
        image: TImages.sucessRegister,
        title: TTexts.yourAccountCreatedTitle,
        subtitle: TTexts.yourAccountCreatedSubTitle,
        onPressed: () => AuthenticationRepository.instance.screenRedirect()
      )
    );
  }
}

}