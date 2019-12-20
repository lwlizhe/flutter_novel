import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';

class NovelPagePainter extends CustomPainter {
  ReaderPageManager pageManager;
  TouchEvent currentTouchData;
  int currentPageIndex;
  int currentChapterId;

  NovelPagePainter({this.pageManager});

  void setCurrentTouchEvent(TouchEvent event) {
    currentTouchData = event;
    pageManager.setCurrentTouchEvent(currentTouchData);
  }

  @override
  void paint(Canvas canvas, Size size) {

    ///-------------------background----------------///
//    var _bgPaint = Paint()
//      ..isAntiAlias = true
//      ..style = PaintingStyle.fill //填充
//      ..color = Color(0xfffff2cc); //背景为纸黄色
//    canvas.drawRect(Offset.zero & size, _bgPaint);
//
    ///-----------------animation-------------------///

    if (pageManager != null) {
      pageManager.setPageSize(size);
      pageManager.onPageDraw(canvas);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return pageManager.shouldRepaint(oldDelegate,this);
  }
}
