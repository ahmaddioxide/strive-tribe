import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class AppButton extends StatelessWidget with DeviceSizeUtil {
  final String? buttonText;
  final Function()? onPressed;
  final Widget? child;
  final bool isEnabled;
  final bool isLoading;
  final double textSize;

  const AppButton({
    super.key,
    this.buttonText,
    this.onPressed,
    this.child,
    this.isEnabled = true,
    this.isLoading = false,
    this.textSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, getDeviceHeight() * 0.06),
        backgroundColor:
            isEnabled == true ? AppColors.primaryLight : AppColors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isLoading
          ? () {
              log('Loading so on press will not work');
            }
          : onPressed,
      child: isLoading
          ? CircularProgressIndicator(
              color: AppColors.white,
            )
          : child ??
              Text(
                buttonText ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }
}
