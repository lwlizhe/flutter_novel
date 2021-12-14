import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:test_project/item/split/content_manager.dart';
import 'package:test_project/item/split/content_split_util.dart';

class TestSplitPage extends StatefulWidget {
  const TestSplitPage({Key? key}) : super(key: key);

  @override
  _TestSplitPageState createState() => _TestSplitPageState();
}

class _TestSplitPageState extends State<TestSplitPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<ReaderChapterPageContentConfig> loadAsset() async {
    print('asset load start : ${DateTime.now().millisecond}');
    var s = await rootBundle.loadString('assets/test.txt', cache: false);

    print('asset load asset : ${DateTime.now().millisecond}');

    var contentWidth = MediaQuery.of(context).size.width;
    var contentHeight = MediaQuery.of(context).size.height;

    print('asset load parse start : ${DateTime.now().millisecond}');

    var info = ContentSplitUtil.getChapterPageContentConfigList(
        content: s,
        contentHeight: contentHeight,
        contentWidth: contentWidth,
        fontSize: 16,
        lineHeight: 20,
        paragraphSpacing: 5);
    print('asset load end : ${DateTime.now().millisecond}');
    return info[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: FutureBuilder<ReaderChapterPageContentConfig>(
            future: loadAsset(),
            builder: (BuildContext context,
                AsyncSnapshot<ReaderChapterPageContentConfig> snapshot) {
              if (!snapshot.hasData) {
                return Text('loading');
              } else {
                var data = snapshot.data;
                return Text(data?.paragraphContents[0] ?? '');
              }
            },
          ),
        ),
      ),
    );
  }
}
