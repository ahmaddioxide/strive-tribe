import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class AppSnackbar {

  static showErrorSnackBar({String title = 'OOPs', required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        title: title,
        message: message,
        messageText: Text(
          message,
          style: TextUtils.getStyle(color: AppColors.white),
        ),
        titleText: Text(
          title,
          style: TextUtils.getStyle(color: AppColors.white),
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: AppColors.red,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  static showSuccessSnackBar({String title = 'Success', required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        title: title,
        message: message,
        messageText: Text(
          message,
          style: TextUtils.getStyle(color: AppColors.white),
        ),
        titleText: Text(
          title,
          style: TextUtils.getStyle(color: AppColors.white),
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: AppColors.primaryLight,
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }
}
