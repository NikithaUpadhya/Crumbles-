import 'package:crumbles/features/authentication/controllers/onboarding_controller.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/device/device_utility.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class onboardingNextButton extends StatelessWidget {
  const onboardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
       right: TSizes.defaultSpace,
       bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton( 
        onPressed:() => OnBoardingController.instance.nextPage()  ,
        style: ElevatedButton.styleFrom(shape: const CircleBorder(),  backgroundColor: Colors.black,),
        child: Icon(Iconsax.arrow_right_3),
     
    
    ));
  }
}
