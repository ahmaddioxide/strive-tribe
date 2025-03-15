import 'package:flutter/material.dart';

class TextUtils {
  static getStyle({
    Color color = Colors.black,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration textDecoration = TextDecoration.none,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: textDecoration,
      fontFamily: 'Inter',
    );
  }
}
