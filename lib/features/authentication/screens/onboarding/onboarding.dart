import 'package:crumbles/features/authentication/controllers/onboarding_controller.dart';
import 'package:crumbles/features/authentication/screens/onboarding/widgets/onboarding_naigation.dart';
import 'package:crumbles/features/authentication/screens/onboarding/widgets/onboarding_next_botton.dart';
import 'package:crumbles/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:crumbles/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class onBoardingScreen extends StatelessWidget {
  const onBoardingScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [ 
          PageView(
            controller: controller.pageController,
            onPageChanged:controller.updatePageIndicator ,
            children: const [ 
              onboardingPage(
                image: TImages.onboardingImage1, 
                title: TTexts.onboardingTitle1, 
                subTitle: TTexts.onboardingSubTitle1),

                onboardingPage(
                image: TImages.onboardingImage2, 
                title: TTexts.onboardingTitle2, 
                subTitle: TTexts.onboardingSubTitle2),

                onboardingPage(
                image: TImages.onboardingImage3, 
                title: TTexts.onboardingTitle3, 
                subTitle: TTexts.onboardingTitle3),
            ],
          ),
          //Skip button
          const onboardingSkip(),

          //Dot Navigation smooth page indicator
          const onboardingNavigation(),

          //circular button
          const onboardingNextButton()
        ],
      ),
    );
  }
}



 