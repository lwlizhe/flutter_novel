import 'package:flutter/cupertino.dart';

class NovelBookDetailInfo {
  String? bookAuthor;
  String? bookTitle;
  String? lastChapterTitle;
  String? detailUrl;

  List<NovelChapterInfo>? chapterList;
  int currentChapterIndex = 0;
}

class NovelChapterInfo {
  int chapterIndex = 0;
  Uri? chapterUri;
  String? chapterTitle;

  List<NovelPageContentInfo> chapterPageContentList = [];

  int get chapterPageCount => chapterPageContentList.length;
}

class NovelPageContentInfo {
  double currentContentParagraphSpacing = 0;

  int currentPageIndex = 0;

  List<InlineSpan> paragraphContents = [];
  //
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is NovelPageContentInfo &&
  //         runtimeType == other.runtimeType &&
  //         currentContentFontSize == other.currentContentFontSize &&
  //         currentContentLineHeight == other.currentContentLineHeight &&
  //         currentContentParagraphSpacing ==
  //             other.currentContentParagraphSpacing &&
  //         currentPageIndex == other.currentPageIndex &&
  //         paragraphContents == other.paragraphContents;
  //
  // @override
  // int get hashCode =>
  //     currentContentFontSize.hashCode ^
  //     currentContentLineHeight.hashCode ^
  //     currentContentParagraphSpacing.hashCode ^
  //     currentPageIndex.hashCode ^
  //     paragraphContents.hashCode;
  //
  // Map toMap() {
  //   Map map = new Map();
  //   map["currentContentFontSize"] = this.currentContentFontSize;
  //   map["currentContentLineHeight"] = this.currentContentLineHeight;
  //   map["currentContentParagraphSpacing"] = this.currentContentParagraphSpacing;
  //   map["currentPageIndex"] = this.currentPageIndex;
  //   map["paragraphConfigs"] = this.paragraphContents;
  //   return map;
  // }
  //
  // static NovelPageContentInfo fromMap(Map<String, dynamic> map) {
  //   NovelPageContentInfo chapterConfig = new NovelPageContentInfo();
  //   chapterConfig.currentContentFontSize = map['currentContentFontSize'];
  //   chapterConfig.currentContentLineHeight = map['currentContentLineHeight'];
  //   chapterConfig.currentContentParagraphSpacing =
  //       map['currentContentParagraphSpacing'];
  //   chapterConfig.currentPageIndex = map['currentPageIndex'];
  //   chapterConfig.paragraphContents = (map['paragraphConfigs'] as List)
  //       .map((e) => e == null ? '' : (e as String))
  //       .cast<String>()
  //       .toList();
  //   return chapterConfig;
  // }
}
