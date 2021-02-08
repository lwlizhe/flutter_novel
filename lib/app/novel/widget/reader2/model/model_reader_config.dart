import 'dart:ui';

import 'package:flutter_novel/app/novel/entity/entity_novel_book_chapter.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';

class NovelReaderConfigModel {


  NovelReaderViewModel viewModel;

  NovelBookChapter catalog;
  bool isMenuOpen=false;

  ReaderConfigEntity configEntity = ReaderConfigEntity();

  NovelReaderConfigModel(this.viewModel);

  void clear() {
    viewModel = null;
    catalog = null;
    configEntity = null;
    isMenuOpen=false;
  }
}

class ReaderConfigEntity {
  /// 翻页动画类型
  int currentAnimationMode = ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN;

  /// 背景色
  Color currentCanvasBgColor = Color(0xfffff2cc);

  int currentPageIndex = 0;
  int currentChapterIndex = 0;
  String novelId;

  int fontSize = 20;
  int lineHeight = 30;
  int paragraphSpacing = 10;

  Offset pageSize;

  int contentPadding=10;
  int titleHeight=25;
  int bottomTipHeight=20;

  int titleFontSize=20;
  int bottomTipFontSize=20;

  ReaderConfigEntity(
      {this.currentAnimationMode,
      this.currentCanvasBgColor,
      this.currentPageIndex,
      this.currentChapterIndex,
      this.novelId,
      this.fontSize,
      this.lineHeight,
      this.paragraphSpacing,
      this.pageSize});

  ReaderConfigEntity copy() {
    return ReaderConfigEntity(
      currentAnimationMode: this.currentAnimationMode,
      currentCanvasBgColor: this.currentCanvasBgColor,
      currentPageIndex: this.currentPageIndex,
      currentChapterIndex: this.currentChapterIndex,
      novelId: this.novelId,
      fontSize: this.fontSize,
      lineHeight: this.lineHeight,
      paragraphSpacing: this.paragraphSpacing,
      pageSize: this.pageSize,
    );
  }
}
