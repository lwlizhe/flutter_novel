import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/db/common_db.dart';
import 'package:flutter_novel/test2.dart';
import 'package:get/get.dart';

void main() {
  debugPrintGestureArenaDiagnostics = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initInstance();
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: buildThemeData(null),
      home: Test2Page(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  void initInstance() {
    Get.put(CommonDB()..init());
  }

  ThemeData buildThemeData(var config) {
    var isDark = true;

    var themeColor = Colors.blue;
    var textColor = Colors.white;

    var primaryColor = MaterialColor(themeColor.value, <int, Color>{
      50: themeColor.withAlpha(255 * 50 ~/ 1000),
      100: themeColor.withAlpha(255 * 100 ~/ 1000),
      200: themeColor.withAlpha(255 * 200 ~/ 1000),
      300: themeColor.withAlpha(255 * 300 ~/ 1000),
      400: themeColor.withAlpha(255 * 400 ~/ 1000),
      500: themeColor.withAlpha(255 * 500 ~/ 1000),
      600: themeColor.withAlpha(255 * 600 ~/ 1000),
      700: themeColor.withAlpha(255 * 700 ~/ 1000),
      800: themeColor.withAlpha(255 * 800 ~/ 1000),
      900: themeColor.withAlpha(255 * 900 ~/ 1000),
    });

    var textTheme = TextTheme(
      bodyText1: TextStyle(color: textColor),
      bodyText2: TextStyle(color: textColor),
      button: TextStyle(color: textColor),
    );

    return ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      indicatorColor: Colors.green,
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: primaryColor,
              brightness: isDark ? Brightness.dark : Brightness.light)
          .copyWith(secondary: Colors.white),
      appBarTheme: AppBarTheme(
          backgroundColor: isDark ? ColorScheme.dark().surface : primaryColor),
    );
  }
}
