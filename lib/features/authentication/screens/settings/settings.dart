import 'package:crumbles/common/Containers/primaryHeaderContainer.dart';
import 'package:crumbles/common/Containers/section_headings.dart';
import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/features/authentication/screens/HistoryScreen/history.dart';
import 'package:crumbles/features/authentication/screens/settings/Addresses/address.dart';
import 'package:crumbles/features/authentication/screens/settings/widgets/setting_menu_tile.dart';
import 'package:crumbles/features/authentication/screens/settings/widgets/user_profile_tile.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:crumbles/data/repositories/authencation/authentication_repo.dart'; // Ensure the correct import

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  // User profile card
                  const TUserProfileTile(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(title: 'Account Settings', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TSettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'My Address',
                    subtitle: 'Set Address',
                    onTap: ()=> Get.to(() =>  UserAddressScreen()),
                  ),
                   TSettingsMenuTile(
                    icon: FontAwesomeIcons.utensils,
                    title: 'My Donations History',
                    subtitle: 'View food donated by you',
                    onTap: () => Get.to(() => const HistoryPage()),
                  ),
                  
                  
                 
                  // App Settings
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const TSectionHeading(title: 'App Settings', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Load Data',
                    subtitle: 'Upload Data to your Cloud Firebase',
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.location,
                    title: 'Geolocation',
                    subtitle: 'Set recommendation based on location',
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  
                  
                  // Logout Button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await AuthenticationRepository.instance.logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 1.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
