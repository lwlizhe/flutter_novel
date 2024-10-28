import 'package:flutter/cupertino.dart';

/// 书籍详情
class NovelBookDetailInfo {
  final String? bookAuthor;
  final String? bookTitle;
  final String? lastChapterTitle;
  final String? detailUrl;

  final List<NovelChapterInfo> chapterList;

  const NovelBookDetailInfo({
    this.bookAuthor,
    this.bookTitle,
    this.lastChapterTitle,
    this.detailUrl,
    this.chapterList = const [],
  });
}

/// 书籍章节信息
class NovelChapterInfo {
  final int chapterIndex;
  final Uri? chapterUri;
  final String? chapterTitle;
  final bool isEnable;
  final List<NovelPageContentInfo> chapterPageContentList;

  const NovelChapterInfo({
    this.chapterIndex = 0,
    this.chapterUri,
    this.chapterTitle,
    this.isEnable = true,
    this.chapterPageContentList = const [],
  });

  int get chapterPageCount => chapterPageContentList.length;
}

/// 书籍页数信息
class NovelPageContentInfo {
  final int currentPageIndex;
  final double contentDisplayHeight;
  final List<InlineSpan> paragraphContents;

  NovelPageContentInfo({
    required this.currentPageIndex,
    this.contentDisplayHeight = 0,
    this.paragraphContents = const [],
  });
}

/// 书籍进度信息
class NovelProgressConfigInfo {
  final int pageIndex;
  final int chapterIndex;

  const NovelProgressConfigInfo(
      {required this.chapterIndex, required this.pageIndex});

  NovelProgressConfigInfo copyWith({int? chapterIndex, int? pageIndex}) {
    return NovelProgressConfigInfo(
        chapterIndex: chapterIndex ?? this.chapterIndex,
        pageIndex: pageIndex ?? this.pageIndex);
  }
}
