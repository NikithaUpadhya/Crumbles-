import 'package:crumbles/features/authentication/controllers/onboarding_controller.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class onboardingSkip extends StatelessWidget {
  const onboardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: TDeviceUtils.getAppBarHeight(),right: TSizes.defaultSpace,child: TextButton(onPressed: ()=> OnBoardingController.instance.skipPage(), child: const Text('Skip'),));
  }
}