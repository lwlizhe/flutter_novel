
import 'dart:ui';

import 'package:flutter_novel/app/novel/helper/helper_db.dart';

class NovelBookInfo{
  String bookId;
  String cover;
  String title;

  int currentPageIndex = 0;
  int currentChapterIndex = 0;
  int currentVolumeIndex = 0;

  Map<String, dynamic> toDBMap() => {
    DBHelper.COLUMN_BOOK_ID: bookId,
    DBHelper.COLUMN_IMAGE: cover,
    DBHelper.COLUMN_TITLE: title,
    DBHelper.COLUMN_CHAPTER_INDEX: currentChapterIndex,
    DBHelper.COLUMN_VOLUME_INDEX: currentVolumeIndex,
    DBHelper.COLUMN_PAGE_INDEX: currentPageIndex,
  };

  static NovelBookInfo fromDBMap(Map<String, dynamic> dbMap) {
    if (dbMap == null) return null;
    NovelBookInfo bookInfo = NovelBookInfo();
    bookInfo.bookId = dbMap[DBHelper.COLUMN_BOOK_ID];
    bookInfo.cover = dbMap[DBHelper.COLUMN_IMAGE];
    bookInfo.title = dbMap[DBHelper.COLUMN_TITLE];
    bookInfo.currentPageIndex = dbMap[DBHelper.COLUMN_PAGE_INDEX];
    bookInfo.currentChapterIndex = dbMap[DBHelper.COLUMN_CHAPTER_INDEX];
    bookInfo.currentVolumeIndex = dbMap[DBHelper.COLUMN_VOLUME_INDEX];
    return bookInfo;
  }
}

class NovelConfigInfo{

  int currentAnimationMode;
  Color currentCanvasBgColor=Color(0xfffff2cc);

  int fontSize = 20;
  int lineHeight = 30;
  int paragraphSpacing = 10;

}
