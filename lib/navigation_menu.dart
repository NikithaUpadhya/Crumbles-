import 'package:crumbles/features/authentication/screens/Add%20Food/add_food.dart';

import 'package:crumbles/features/authentication/screens/HistoryScreen/history.dart';
import 'package:crumbles/features/authentication/screens/chatbot/chatbot.dart';
import 'package:crumbles/features/authentication/screens/home/home.dart';
import 'package:crumbles/features/authentication/screens/settings/settings.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.selectedIndex.value == 0 || controller.selectedIndex.value == 1,
          child: FloatingActionButton(
            onPressed: ()=> Get.to(() => AddScreen()),
            child: Icon(CupertinoIcons.add),
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
          ),
        ),
      ),
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
            NavigationDestination(icon: Icon(Iconsax.clock), label: "History"),
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
    const HomeScreen(),
     HistoryPage(),
    const ChatbotPage(),
    const SettingsScreen(),
  ];
}
