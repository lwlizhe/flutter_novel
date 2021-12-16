typedef void OnRequestContent<T>(int novelId, int volumeId, int chapterId);

class ItemContentManager {
  var testContent = '';

  ChapterInfo? currentChapter;
  ChapterInfo? preChapter;
  ChapterInfo? nextChapter;
}

class ChapterInfo {
  int chapterTotalPage = 0;
  int chapterCurrentPage = 0;

  List<String> chapterPageContentList = [];
}

class ReaderChapterPageContentConfig {
  double currentContentFontSize = 0;
  double currentContentLineHeight = 0;
  double currentContentParagraphSpacing = 0;

  int currentPageIndex = 0;
  int currentChapterId = 0;

  String pendingPartContent = '';

  List<String> paragraphContents = [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReaderChapterPageContentConfig &&
          runtimeType == other.runtimeType &&
          currentContentFontSize == other.currentContentFontSize &&
          currentContentLineHeight == other.currentContentLineHeight &&
          currentContentParagraphSpacing ==
              other.currentContentParagraphSpacing &&
          currentPageIndex == other.currentPageIndex &&
          currentChapterId == other.currentChapterId &&
          paragraphContents == other.paragraphContents;

  @override
  int get hashCode =>
      currentContentFontSize.hashCode ^
      currentContentLineHeight.hashCode ^
      currentContentParagraphSpacing.hashCode ^
      currentPageIndex.hashCode ^
      currentChapterId.hashCode ^
      paragraphContents.hashCode;

  Map toMap() {
    Map map = new Map();
    map["currentContentFontSize"] = this.currentContentFontSize;
    map["currentContentLineHeight"] = this.currentContentLineHeight;
    map["currentContentParagraphSpacing"] = this.currentContentParagraphSpacing;
    map["currentPageIndex"] = this.currentPageIndex;
    map["currentChapterId"] = this.currentChapterId;
    map["paragraphConfigs"] = this.paragraphContents;
    return map;
  }

  static ReaderChapterPageContentConfig fromMap(Map<String, dynamic> map) {
    ReaderChapterPageContentConfig chapterConfig =
        new ReaderChapterPageContentConfig();
    chapterConfig.currentContentFontSize = map['currentContentFontSize'];
    chapterConfig.currentContentLineHeight = map['currentContentLineHeight'];
    chapterConfig.currentContentParagraphSpacing =
        map['currentContentParagraphSpacing'];
    chapterConfig.currentPageIndex = map['currentPageIndex'];
    chapterConfig.currentChapterId = map['currentChapterId'];
    chapterConfig.paragraphContents = (map['paragraphConfigs'] as List)
        .map((e) => e == null ? '' : (e as String))
        .cast<String>()
        .toList();
    return chapterConfig;
  }
}
