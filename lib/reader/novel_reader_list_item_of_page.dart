import 'package:flutter/material.dart';
import 'package:flutter_novel/reader/split/content_split_util.dart';
import 'package:flutter_novel/reader/split/entity/content_split_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 小说阅读器 章节page部分
class NovelListChapterPageItem extends StatelessWidget {
  final NovelPageContentInfo pageContentConfig;

  const NovelListChapterPageItem({Key? key, required this.pageContentConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorList = <MaterialAccentColor>[
      Colors.redAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
      Colors.greenAccent
    ];

    return Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: colorList[pageContentConfig.currentPageIndex % 4],
          alignment: AlignmentDirectional.topCenter,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Text.rich(TextSpan(children: [
                  ...ContentSplitUtil.buildTextSpanListByPageContentConfig(
                      pageContentConfig),
                  WidgetSpan(
                      child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: '加了个点击事件');
                    },
                    child: Container(
                      width: 200,
                      height: 300,
                      color: Colors.pink,
                      alignment: Alignment.center,
                      child: Text(
                        '假装这里有个评论区，或者广告区;\r\n(可以点击)',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )),
                ])),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      '页码:${pageContentConfig.currentPageIndex}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ],
            ),
          ),
        ));
  }
}
