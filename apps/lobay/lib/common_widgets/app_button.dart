import 'package:flutter/material.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class AppButton extends StatelessWidget with DeviceSizeUtil {
  final String? buttonText;
  final Function()? onPressed;
  final Widget? child;
  final bool isEnabled;

  const AppButton({
    super.key,
    this.buttonText,
    this.onPressed,
    this.child,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, getDeviceHeight() * 0.06),
        backgroundColor:isEnabled==true? AppColors.primaryLight:AppColors.grey,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: child ??
          Text(
            buttonText ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
    );
  }
}
