import 'dart:math';
import 'package:flutter/material.dart';

class ColorUtils{
  /// 文字转颜色
  static Color strToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  /// 随机颜色
  static Color randomRGB() {
    return Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255),
        Random().nextInt(255));
  }

  static Color randomARGB() {
    Random random = new Random();
    return Color.fromARGB(random.nextInt(180), random.nextInt(255),
        random.nextInt(255), random.nextInt(255));
  }
}