import 'package:flutter/material.dart';

class TextStyleConstant {

  static TextStyle textStyle({double fontSize: 12,
    Color color: Colors.white,
    FontWeight fontWeight}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: TextDecoration.none,
        fontWeight: fontWeight);
  }
}