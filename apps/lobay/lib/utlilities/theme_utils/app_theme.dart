import 'package:flutter/material.dart';
import 'package:lobay/utlilities/theme_utils/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: Colors.white,
    splashColor: AppColors.primaryLight,
  );
}
