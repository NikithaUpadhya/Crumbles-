import 'package:crumbles/features/authentication/screens/signUp/signup_controller.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TTermsandConditionsCheckbox extends StatelessWidget {
  const TTermsandConditionsCheckbox({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Row( 
      children: [ 
        SizedBox(child: Obx(() => Checkbox(value: controller.privacyPolicy.value, onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value))),
        const SizedBox(width: TSizes.spaceBtwItems,),
        Text.rich(TextSpan( 
          children: [TextSpan(text: '${TTexts.iAgreeTo} ', style: Theme.of(context).textTheme.bodySmall ),
        
          
        
           TextSpan(text: '${TTexts.termsOfUse} ', style: Theme.of(context).textTheme.bodyMedium!.apply( 
            color: dark? TColors.white : TColors.primary,
            decoration: TextDecoration.underline,
            decorationColor: dark? TColors.white : TColors.primary,
        
          )),
          ]
        ))
        
      ],
    );
  }
}