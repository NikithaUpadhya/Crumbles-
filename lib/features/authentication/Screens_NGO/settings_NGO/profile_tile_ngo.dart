import 'package:crumbles/common/Containers/circular_image.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/features/authentication/Screens_NGO/NGO%20Profle/profile.dart';
import 'package:crumbles/features/authentication/screens/profile/profile.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TUserProfileTileNgo extends StatelessWidget {
  const TUserProfileTileNgo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Obx(() {
      final networkImage = controller.user.value.profilePicture;
      final image = networkImage.isNotEmpty ? networkImage : TImages.user;
      return ListTile(
        leading: TCircleurImage(
          image: image,
          width: 50,
          height: 50,
          padding: 0,
          isNetworkImage: networkImage.isNotEmpty,
        ),
        title: Text(
          controller.user.value.fullName,
          style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),
        ),
        subtitle: Text(
          controller.user.value.email,
          style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),
        ),
        trailing: IconButton(
          onPressed: () => Get.to(() => const ProfileScreenNgo()),
          icon: const Icon(Iconsax.edit, color: TColors.white),
        ),
      );
    });
  }
}
