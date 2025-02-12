
import 'package:crumbles/data/repositories/authencation/authentication_repo.dart';
import 'package:crumbles/features/authentication/screens/signUp/verify_email_controller.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerfiyEmailScreen extends StatelessWidget {
  const VerfiyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());



    return Scaffold( 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [ 
          IconButton(onPressed: () => AuthenticationRepository.instance.logout(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
           child: Column( 
            children: [ 
              //image 

              Image(image: AssetImage(TImages.verifyEmailImg1), width: THelperFunctions.screenWidtht() * 0.6,),
              const SizedBox(height: TSizes.spaceBtwSections,),


              //title & sub title 

              Text(TTexts.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              Text(email?? '', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              Text(TTexts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),


              // Buttons 

              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.checkEmailVerificationStatus()
              , child: const Text(TTexts.tcontinue)),),

              const SizedBox(height: TSizes.spaceBtwItems),

              SizedBox(width: double.infinity, child: TextButton(onPressed: () => controller.sendEmailVerification(), child: const Text(TTexts.Remail)), )



              
            ],
          )
          ),
         
      ),
    );
  }
}