import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/device/device_utility.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key, required this.text, this.icon = FontAwesomeIcons.handHoldingHeart, this.showBackground = true, this.showBorder = true, this.onTap,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {

    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Container( 
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration( 
            color: showBackground? dark? TColors.dark : TColors.light : Colors.transparent,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: showBorder? Border.all(color: TColors.grey) : null,
          ),
      
          child: Row( 
            children: [ 
              Icon(icon, color: TColors.darkGrey ,),
              const SizedBox( width: TSizes.spaceBtwItems,),
              Text(text, style: Theme.of(context).textTheme.bodySmall,),
            ],
          ),
        ),
      ),
    );
  }
}
