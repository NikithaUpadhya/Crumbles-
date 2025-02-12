import 'package:crumbles/features/authentication/Screens_NGO/Home_NGO_screen/home_ngo1.dart';
import 'package:crumbles/features/authentication/Screens_NGO/food_receiving/NGO_foodView.dart';
import 'package:crumbles/features/authentication/Screens_NGO/settings_NGO/settings_ngo.dart';
import 'package:crumbles/features/authentication/screens/chatbot/chatbot.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationMenuNgo extends StatelessWidget {
  const NavigationMenuNgo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : TColors.white,
          indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.category), label: "Food Requests"),
            NavigationDestination(icon: Icon(Iconsax.message_square), label: "Chatbot"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const HomeScreenNgo(),
    const FoodView(),
    const ChatbotPage(),
    const SettingsScreenNgo(),
  ];
}
