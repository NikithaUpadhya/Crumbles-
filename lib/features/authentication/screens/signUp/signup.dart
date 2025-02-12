import 'package:crumbles/common/styles/widget.login_signup/form_divider.dart';
import 'package:crumbles/common/styles/widget.login_signup/social_buttons.dart';
import 'package:crumbles/features/authentication/screens/signUp/widgets/SignupForm.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(),
      body: SingleChildScrollView( 
        child: Padding( 
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.start ,
            children: [ 
              //Title
              Text(TTexts.signUpTitle, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: TSizes.spaceBtwSections,),

              //form
              const TSignupForm(),
               const SizedBox(height: TSizes.spaceBtwSections,),

              

             

            ],

          ),
        ),
      ),
    );
  }
}

