import 'package:flutter/material.dart';

/// 加载中展示的widget
class NovelReaderLoadingWidget extends StatelessWidget {
  const NovelReaderLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('loading'),
    );
  }
}
