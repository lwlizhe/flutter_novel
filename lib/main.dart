import 'package:flutter/material.dart';
import 'package:flutter_novel/app/main/main_page_view.dart';
import 'package:flutter_novel/base/structure/provider/app_provider.dart';
import 'package:provider/provider.dart';

MaterialColor appThemeColor = Colors.blue;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: APPInfoProvider.instance.getProvidersList(context),
        child: Consumer<APPInfoProvider>(builder:
            (BuildContext context, APPInfoProvider appInfo, Widget child) {
          return MaterialApp(
//              showPerformanceOverlay: true,
//              checkerboardOffscreenLayers: true, // 使用了saveLayer的图形会显示为棋盘格式并随着页面刷新而闪烁
//              checkerboardRasterCacheImages: true, // 做了缓存的静态图片在刷新页面时不会改变棋盘格的颜色；如果棋盘格颜色变了说明被重新缓存了，这是我们要避免的

              title: 'Flutter Novel Reader',
              theme: ThemeData(primarySwatch: appThemeColor),
              home: MainPageView());
        }));
  }
}
