import 'package:crumbles/common/styles/spacing_styles.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String image, title, subtitle;
  final VoidCallback onPressed; 

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SingleChildScrollView( 
        child: Padding(padding: TSpacingStyle.paddingWithAppBarHeight * 2,
        child: Column( 
          children: [ 

            // Image
            Lottie.asset(image, width: MediaQuery.of(context).size.width * 0.6),
            const SizedBox(height: TSizes.spaceBtwSections),



              //title & sub title 

              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),

             

              Text(subtitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              //button

              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onPressed
              , child: const Text(TTexts.tcontinue)),),
          ],
        ),
         ),
      ),
    );
  }
}