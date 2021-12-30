import 'package:flutter/material.dart';

/// 出错的时候展示的widget
class NovelReaderErrorWidget extends StatelessWidget {
  const NovelReaderErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('error'),
    );
  }
}
