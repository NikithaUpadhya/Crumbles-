import 'package:crumbles/features/authentication/controllers/onboarding_controller.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onboardingNavigation extends StatelessWidget {
  const onboardingNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() +25,
      left: TSizes.defaultSpace,
    
      child: SmoothPageIndicator(controller: controller.pageController, 
      onDotClicked: controller.dotNavigationClick ,
      count: 3, effect: const ExpandingDotsEffect(activeDotColor: TColors.dark, dotHeight: 6),),);
  }
}
