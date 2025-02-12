import 'package:crumbles/common/styles/spacing_styles.dart';
import 'package:crumbles/common/styles/widget.login_signup/form_divider.dart';
import 'package:crumbles/common/styles/widget.login_signup/social_buttons.dart';
import 'package:crumbles/features/authentication/screens/login/widgets/login_form.dart';
import 'package:crumbles/features/authentication/screens/login/widgets/login_header.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final dark = THelperFunctions.isDarkMode(context);
    return const Scaffold(
      body: SingleChildScrollView( 
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
        child: Column( 
          children: [ 
            TLoginHeader(),

            // form
            TLoginForm(),

            //Divider 

           TFormDivider(dividerText: TTexts.orSignInWith),

            SizedBox(height: TSizes.spaceBtwSections,),

            //Footer
            TSocalButtons(),


          ],
        ),),
      ),
    );
  }
}