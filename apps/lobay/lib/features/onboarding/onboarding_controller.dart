import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lobay/features/bottom_navigation/bottom_navigation_main.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  final pageController = PageController();

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Get.offAll(() => BottomNavigationScreen());
      // For now, just print:
      log("Onboarding finished!");
    }
  }

  /// Skip directly to the last page
  void skipOnboarding() {
    pageController.jumpToPage(2);
    currentPage.value = 2;
  }

  /// Restart onboarding from first page
  void restartOnboarding() {
    pageController.jumpToPage(0);
    currentPage.value = 0;
  }
}
