import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: Colors.white,
    splashColor: AppColors.primaryLight.withOpacity(0.2),
    textTheme: GoogleFonts.interTextTheme(),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
    ),
  );
}
