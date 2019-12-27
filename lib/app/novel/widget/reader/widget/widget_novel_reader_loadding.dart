import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/helper_reader_content.dart';

class NovelReaderLoadingPageWidget extends StatelessWidget {
  final ReaderContentDataValue dataValue;

  NovelReaderLoadingPageWidget(this.dataValue);

  @override
  Widget build(BuildContext context) {
    Widget result;

    result = Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );

    return result;
  }
}
