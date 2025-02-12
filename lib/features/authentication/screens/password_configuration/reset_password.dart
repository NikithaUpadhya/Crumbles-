import 'package:crumbles/features/authentication/screens/login/login.dart';
import 'package:crumbles/features/authentication/screens/password_configuration/forget_password_controller.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        automaticallyImplyLeading: false,
        actions: [ 
          IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear),)
        ],
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column( 
            children: [ 
              // Image
            Image(image: const AssetImage(TImages.reset), width: THelperFunctions.screenWidtht() *0.6,),
             const SizedBox(height: TSizes.spaceBtwItems,),




              //title & sub title 

              Text(email, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              Text(TTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),

             

              Text(TTexts.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              //button

              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.offAll(() => const LoginScreen())
              , child: const Text(TTexts.done)),),

               const SizedBox(height: TSizes.spaceBtwItems,),

                SizedBox(width: double.infinity, child: TextButton(onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email)
              , child: const Text(TTexts.resendEmail)),),
            ],
          ),
          ),
      ),
    );
  }
}