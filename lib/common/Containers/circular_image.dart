import 'package:cached_network_image/cached_network_image.dart';
import 'package:crumbles/common/styles/shimmer.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TCircleurImage extends StatelessWidget {
  const TCircleurImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overLayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overLayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        // If image background color is null then switch it to light and dark mode color design.
        color: backgroundColor ?? (THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white),
        borderRadius: BorderRadius.circular(100),
      ), // BoxDecoration
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: Center(
          child: isNetworkImage? 
          CachedNetworkImage(
            fit: fit,
            color:overLayColor,
            imageUrl: image,
            progressIndicatorBuilder: (context, url, downloadProgress) => const TShimmerEffect(width: 55, height: 55),
            errorWidget: (context, url, error) => const Icon(Icons.error),)
        
            :Image(
              image: AssetImage(image),
              fit: fit,
              color: overLayColor,
            )
          ),
      ),); // Center
     // Container
  }
}
