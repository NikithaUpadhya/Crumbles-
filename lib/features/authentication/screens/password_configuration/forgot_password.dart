import 'package:crumbles/features/authentication/screens/password_configuration/forget_password_controller.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold( 
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            //Headings 

            Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium,),
            const SizedBox(height: TSizes.spaceBtwItems,),

            Text(TTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium,),
            const SizedBox(height: TSizes.spaceBtwItems * 2,),


            //textfields 
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField( 
                controller: controller.email ,
                validator: TValidators.validateEmail,
                decoration: const InputDecoration( 
                  labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct_right)
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),

            //submit button 

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: ()=> controller.sendPasswordResetEmail(), child: const Text(TTexts.submit)))
          ],
        ),
        ),
    );
  }
}