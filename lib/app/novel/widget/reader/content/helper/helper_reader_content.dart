import 'dart:collection';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ReaderContentProvider {
  /// em…………由于大量文字计算，即Cpu计算，在UI的Isolate会阻塞后续的UI事件（例如跳转，动画啥的），所以采取新建Isolate的方式，这也是flutter中建议的&……
  /// 但是目前尴尬的是：
  /// 非UI的Isolate不支持UI控件，即下面的textPainter废了……一调用就报错
  /// https://github.com/flutter/flutter/issues/30604
  /// 所以，理论上来说，这块的计算应该放到一个子线程中，对于目前功能来说，也可以说是isolate中，但是flutter 现在不支持……
  /// 现在个人有几种想法：
  /// 1、翻页的时候动态计算，只缓存几页的内容，下次翻页的时候再计算
  /// 2、https://github.com/flutter/flutter/issues/30604 裁剪canvas
  /// 3、平台计算……
  /// 4、自己新建一个主isolate？但是不给它任何View？
  ///
  ///
  /// 评测结果记录：
  /// 1、这样不行，这样无法计算上一章的最后一页
  /// 2、但是这种方式是基于不自定义段落间距，而固定所有行距实现的，无法自定义
  /// 3、但是不能保证Android平台和ios平台自己计算结果和flutter的一致……
  /// 4、好像https://pub.dev/packages/flutter_isolate 实现了这点。
  ///
  /// 现阶段基于flutter v1.10.14,其中有个LineMetrics，解决了无法获得段落展示高度的问题(说白了就是提供了行数，这样直接用行数*行高)，因此不需要一行一行的那种计算，大大减少了layout的次数
  /// 计算慢说白了就是layout导致的，flutter啥时候出个像android stackLayout或者painter breakText这种不需要布局测绘即可得出展示指针位置的方法啊

  static List<ReaderChapterPageContentConfig> getChapterPageContentConfigList(
    int targetChapterId,
    String content,
    double height,
    double width,
    int fontSize,
    int lineHeight,
    int paragraphSpacing,
  ) {
    String tempContent;
    List<ReaderChapterPageContentConfig> pageConfigList = [];
    double currentHeight = 0;
    int pageIndex = 0;

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

    if(content==null){
      return [];
    }

    List<String> paragraphs = content.split("\n");

    while (paragraphs.length > 0) {
      ReaderChapterPageContentConfig config = ReaderChapterPageContentConfig();
      config.paragraphContents = [];
      config.currentChapterId = targetChapterId;
      config.currentContentFontSize = fontSize;
      config.currentContentLineHeight = lineHeight;
      config.currentContentParagraphSpacing = paragraphSpacing;
      config.currentPageIndex = pageIndex;

      while (currentHeight < height) {
        /// 如果最后一行再添一行比页面高度大，或者已经没有内容了，那么当前页面计算结束
        if (currentHeight + lineHeight >= height || paragraphs.length == 0) {
          break;
        }

        tempContent = paragraphs[0];

        /// 配置画笔 ///
        textPainter.text = TextSpan(
            text: tempContent,
            style:
                TextStyle(fontSize: fontSize.toDouble(), height: lineHeight / fontSize));
        textPainter.layout(maxWidth: width);

        /// 当前段落内容计算偏移量
        /// 为什么要减一个lineHeight？因为getPositionForOffset判断依据是只要能展示，即使展示不全，也在它的判定范围内，所以如需要减去一行高度
        int endOffset = textPainter
            .getPositionForOffset(
                Offset(width, height - currentHeight - lineHeight))
            .offset;

        /// 当前展示内容
        String currentParagraphContent = tempContent;

        /// 改变当前计算高度
        List<ui.LineMetrics> lineMetrics = textPainter.computeLineMetrics();

        /// 如果当前段落的内容展示不下，那么裁剪出展示内容，剩下内容填回去,否则移除顶部,计算下一个去
        if (endOffset < tempContent.length) {
          currentParagraphContent = tempContent.substring(0, endOffset);

          /// 剩余内容
          String leftParagraphContent = tempContent.substring(endOffset);

          /// 填入原先的段落数组中
          paragraphs[0] = leftParagraphContent;

          /// 改变当前计算高度,既然当前内容展示不下，那么currentHeight自然是height了
          currentHeight = height;
        } else {
          paragraphs.removeAt(0);

          currentHeight += lineHeight * lineMetrics.length;
          currentHeight += paragraphSpacing;
        }

        config.paragraphContents.add(currentParagraphContent);
      }

      pageConfigList.add(config);
      currentHeight = 0;
      pageIndex++;
    }

    return pageConfigList;
  }

  static ui.Picture getNextPicture(
      HashMap<int, ReaderContentCanvasDataValue> currentChapterCanvasMap,
      HashMap<int, ReaderContentCanvasDataValue> nextChapterCanvasMap,
      int ind) {}

  static ui.Picture goPreChapter() {}
}

class ReaderChapterPageContentConfig {
  int currentContentFontSize;
  int currentContentLineHeight;
  int currentContentParagraphSpacing;

  int currentPageIndex;
  int currentChapterId;

  List<String> paragraphContents;

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

  Map toJson() {
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
        ?.map((e) => e == null ? null : (e as String))
        ?.toList();
    return chapterConfig;
  }
}

class ReaderContentDataValue {
  List<ReaderChapterPageContentConfig> chapterContentConfigs = [];
  HashMap<int, ReaderContentCanvasDataValue> chapterCanvasDataMap = HashMap();
  String contentData;

  int chapterIndex = 0;
  String novelId;
  String title;

  int currentPageIndex = 0;

  ContentState contentState=ContentState.STATE_NORMAL;

  bool isSameChapter(ReaderContentDataValue target){
    return target?.chapterIndex!=null&&target.chapterIndex==this.chapterIndex&&target?.novelId!=null&&target.novelId==this.novelId;
  }

  void clearCalculateResult(){
    chapterContentConfigs.clear();
    chapterCanvasDataMap.clear();
  }

  void clear(){
    clearCalculateResult();
    contentData=null;
    chapterIndex=0;
    title=null;
    currentPageIndex=0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ReaderContentDataValue &&
              runtimeType == other.runtimeType &&
              chapterIndex == other.chapterIndex &&
              novelId == other.novelId &&
              currentPageIndex == other.currentPageIndex;

  @override
  int get hashCode =>
      chapterIndex.hashCode ^
      novelId.hashCode ^
      currentPageIndex.hashCode;
}

class ReaderContentCanvasDataValue {
  int pageIndex;

  ui.Picture pagePicture;
  ui.Image pageImage;
}

class ReaderParseContentDataValue {

  ContentState contentState=ContentState.STATE_NORMAL;

  String content;
  String title;
  String novelId;
  int chapterIndex;

  ReaderParseContentDataValue(
      this.content, this.novelId,this.title,this.chapterIndex);
}

enum ContentState{
  STATE_NORMAL,
  STATE_NOT_FOUND,
  STATE_NET_ERROR,
}
