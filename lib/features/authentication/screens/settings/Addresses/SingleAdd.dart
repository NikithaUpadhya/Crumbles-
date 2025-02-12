import 'package:crumbles/common/Containers/Rounded_Container.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TSingleAddress extends StatelessWidget {
  final String username;
  final String address;
  final String zipCode;

  const TSingleAddress({
    Key? key,
    required this.username,
    required this.address,
    required this.zipCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.md),
      showBorder: true,
      backgroundColor: Colors.transparent,
      borderColor: TColors.primary,
      margin: EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                address,
                softWrap: true,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                zipCode,
                softWrap: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
