import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryLight),
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.white,
    splashColor: AppColors.primaryLight.withAlpha(50),
    textTheme: GoogleFonts.interTextTheme(),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(AppColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
    ),
    cardColor: Colors.white,
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.white),
        surfaceTintColor: WidgetStateProperty.all(AppColors.white),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.grey,
      ),
    ),
  );
}
