import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TSocalButtons extends StatelessWidget {
  const TSocalButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container( 
                  decoration: BoxDecoration(border: Border.all(color: TColors.grey), borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                  onPressed: (){}, 
                  icon: const Image(
                    width: TSizes.iconMd,
                    height: TSizes.iconMd,
                    image: AssetImage(TImages.google))
                  )
                ),
                

              ],
            );
  }
}