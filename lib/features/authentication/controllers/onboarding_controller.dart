
import 'package:crumbles/features/authentication/screens/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();


  ///Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  ///
  ///// Update current index when page scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  // Jump to specific dot Selected Page
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  //update current index & jump to next page
  void nextPage(){
    if(currentPageIndex.value == 2){
      final storage = GetStorage();



      if (kDebugMode) {
    print("================ GET STORAGE ================");
    print(storage.read('isFirstTime'));
}



      storage.write('isFirstTime', false);
      Get.offAll(const LoginScreen());
    } else{
       int page = currentPageIndex.value + 1;
       pageController.jumpToPage(page);
    }
  }

  //updte current index & jump to last page 
  void skipPage() => Get.to(() => const LoginScreen());
}