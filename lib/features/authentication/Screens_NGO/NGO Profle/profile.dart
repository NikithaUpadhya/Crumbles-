import 'package:crumbles/common/Containers/circular_image.dart';
import 'package:crumbles/common/Containers/section_headings.dart';
import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/common/styles/shimmer.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/features/authentication/Screens_NGO/NGO%20Profle/subprofile/change_Ngo_des.dart';
import 'package:crumbles/features/authentication/Screens_NGO/NGO%20Profle/subprofile/change_ngo_name.dart';
import 'package:crumbles/features/authentication/Screens_NGO/NGO%20Profle/subprofile/change_type.dart';
import 'package:crumbles/features/authentication/screens/profile/sub%20profiles/change_name.dart';
import 'package:crumbles/features/authentication/screens/profile/sub%20profiles/change_number.dart';
import 'package:crumbles/features/authentication/screens/profile/sub%20profiles/change_username.dart';
import 'package:crumbles/features/authentication/screens/profile/widgets/profile_menu.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProfileScreenNgo extends StatelessWidget {
  const ProfileScreenNgo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold( 
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView( 
        child: Padding(padding:  EdgeInsets.all(TSizes.defaultSpace),
        child: Column( 
          children: [ 
            // Profile Picture
            SizedBox(
              width: double.infinity,
              child: Column( 
                children: [ 
                  Obx(() {
                    final networkImage = controller.user.value.profilePicture;
                    final image = networkImage.isNotEmpty? networkImage : TImages.user;
                    return controller.imageUploading.value?
                    const TShimmerEffect(width: 80, height: 80, radius: 80,) : TCircleurImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty,);
                  }),
                  TextButton(onPressed: () => controller.uploadUserProfilePicture(), child: Text('Change Profile Picture')),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Profile Information
            const TSectionHeading(title: 'Profile Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfileMenu(title: 'Name', value: controller.user.value.fullName, onPressed: () => Get.to(()=> ChangeName())),
            TProfileMenu(title: 'Username', value: controller.user.value.username, onPressed: () => Get.to(() => ChangeUserName())),
            const SizedBox(height: TSizes.spaceBtwItems),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Personal Information
            const TSectionHeading(title: 'Personal Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfileMenu(title: 'User ID', value: controller.user.value.id, icon: Iconsax.copy, onPressed: () {}),
            TProfileMenu(title: 'E-mail', value: controller.user.value.email, onPressed: () {}),
            TProfileMenu(title: 'Phone Number', value: controller.user.value.phoneNumber, onPressed: () => Get.to(() => ChangeNumber())),
            TProfileMenu(title: 'Gender', value: 'Female', onPressed: () {}),
            TProfileMenu(title: 'Date of Birth', value: '9 Nov, 2002', onPressed: () {}),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            // NGO Information
            const TSectionHeading(title: 'NGO Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfileMenu(title: 'NGO Description', value: controller.user.value.ngoDescription!, onPressed: () => Get.to(() => ChangeNGODescription())),
            TProfileMenu(title: 'NGO Name', value: controller.user.value.ngoName!, onPressed: () => Get.to(() => ChangeNGOName())),
            TProfileMenu(title: 'NGO Type', value: controller.user.value.ngoType!, onPressed: () => Get.to(() => ChangeNGOType())),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),
            
            Center(
              child: TextButton(
                onPressed: () => controller.deleteAccountWarningPopup(),
                child: const Text('Delete Account', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
