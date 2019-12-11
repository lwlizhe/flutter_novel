import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenUtils{

  static double getScreenHeight(){
    return MediaQueryData.fromWindow(window).size.height;
  }

  static double getScreenWidth(){
    return MediaQueryData.fromWindow(window).size.width;
  }

}