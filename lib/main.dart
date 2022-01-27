import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/db/common_db.dart';
import 'package:flutter_novel/home/home_page.dart';
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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  void initInstance() {
    Get.put(CommonDB()..init());
  }
}
