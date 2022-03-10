import 'package:flutter/material.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';

/// 小说阅读器 章节page部分
class NovelListChapterPageItem extends StatelessWidget {
  final NovelPageContentInfo pageContentConfig;
  final NovelChapterInfo novelChapterInfo;

  const NovelListChapterPageItem(
      {Key? key,
      required this.pageContentConfig,
      required this.novelChapterInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Color(0xFFFAF9DE),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 40),
              child: Text.rich(
                TextSpan(children: pageContentConfig.paragraphContents),
                // strutStyle: StrutStyle(forceStrutHeight: true, leading: 0.5),
              ),
            ),
          ),
          Positioned(
              bottom: 16,
              right: 16,
              child: Text(
                '页码:${pageContentConfig.currentPageIndex}',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )),
          Positioned(
              top: 16,
              left: 16,
              child: Text(
                '${novelChapterInfo.chapterTitle}',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )),
        ],
      ),
    );
  }
}
