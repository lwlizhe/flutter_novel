import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_project/item/split/entity/content_split_entity.dart';

class ContentSplitUtil {
  static Future<ChapterInfo> calculateChapter({
    required String chapterContent,
    required double contentHeight,
    required double contentWidth,
    required double fontSize,
    required double lineHeight,
    double paragraphSpacing = 0,
    int currentIndex = 0,
  }) {
    var pageContentConfigList = getChapterPageContentConfigList(
        chapterContent: chapterContent,
        contentHeight: contentHeight,
        contentWidth: contentWidth,
        fontSize: fontSize,
        lineHeight: lineHeight);

    ChapterInfo info = ChapterInfo();
    info.chapterPageContentList = pageContentConfigList;
    info.currentPageIndex =
        math.min(currentIndex, pageContentConfigList.length);

    return Future.value(info);
  }

  /// 根据给定的内容，分页计算；
  /// content ： 小说一章的内容；
  /// contentHeight ： 指定展示内容区域的高度；
  /// contentWidth ： 指定展示内容区域的宽度；
  /// fontSize ： 文字大小；
  /// lineHeight ： 文字行高；
  /// paragraphSpacing ： 段落之间的间距；
  ///
  /// return ：承载每页中的内容，页码等数据的列表
  static List<ReaderChapterPageContentConfig> getChapterPageContentConfigList({
    required String chapterContent,
    required double contentHeight,
    required double contentWidth,
    required double fontSize,
    required double lineHeight,
    double paragraphSpacing = 0,
  }) {
    List<ReaderChapterPageContentConfig> pageConfigList = [];
    int pageIndex = 0;

    /// todo ： 可以后续加上文字方向的设置
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

    if (chapterContent.isEmpty) {
      return [];
    }

    List<String> paragraphs = chapterContent.split('\r\n')
      ..removeWhere((element) => element.isEmpty);

    /// 不断计算，直到指定的段落list都计算完成；
    while (paragraphs.length > 0) {
      /// 用来放一页中有多少段落，内容、页码之类的东西；
      ReaderChapterPageContentConfig config = ReaderChapterPageContentConfig();
      config.paragraphContents = [];
      config.currentContentFontSize = fontSize;
      config.currentContentLineHeight = lineHeight;
      config.currentContentParagraphSpacing = paragraphSpacing;
      config.currentPageIndex = pageIndex;

      /// 计算一页中的内容
      getPageConfig(
          sourceConfig: config,
          sourceParagraphsList: paragraphs,
          contentWidth: contentWidth,
          contentHeight: contentHeight,
          textPainter: textPainter);

      pageConfigList.add(config);

      /// 指针+1
      pageIndex++;
    }

    return pageConfigList;
  }

  /// 计算一页的内容；
  /// return 剩余未处理的部分
  static void getPageConfig({
    required ReaderChapterPageContentConfig sourceConfig,
    required List<String> sourceParagraphsList,
    required double contentHeight,
    required double contentWidth,
    required TextPainter textPainter,
  }) {
    double currentHeight = 0;
    String tempContent;
    double lineHeight = sourceConfig.currentContentLineHeight;
    double fontSize = sourceConfig.currentContentFontSize;
    double paragraphSpacing = sourceConfig.currentContentParagraphSpacing;

    /// 循环计算，直到当前页面展示不下；这样就算出了一页的内容；
    while (currentHeight < contentHeight) {
      /// 如果最后一行再添一行比页面高度大，或者已经没有内容了，那么当前页面计算结束
      if (currentHeight + lineHeight >= contentHeight ||
          sourceParagraphsList.isEmpty) {
        break;
      }

      tempContent = sourceParagraphsList.first;

      /// 配置画笔 ///
      textPainter.text = TextSpan(
          text: tempContent,
          style: TextStyle(fontSize: fontSize, height: lineHeight / fontSize));
      textPainter.layout(maxWidth: contentWidth);

      /// 当前段落内容计算偏移量
      /// 为什么要减一个lineHeight？因为getPositionForOffset判断依据是只要能展示，
      /// 所以即使展示不全，也在它的判定范围内，所以要减去一行高度，保证都能展示全
      int endOffset = textPainter
          .getPositionForOffset(
              Offset(contentWidth, contentHeight - currentHeight - lineHeight))
          .offset;

      /// 当前展示内容
      String currentParagraphContent = tempContent;

      /// 改变当前计算高度
      List<LineMetrics> lineMetrics = textPainter.computeLineMetrics();

      /// 如果当前段落的内容展示不下，那么裁剪出展示内容，剩下内容填回去,否则移除顶部,计算下一个去
      if (endOffset < tempContent.length) {
        currentParagraphContent = tempContent.substring(0, endOffset);

        /// 剩余内容
        String leftParagraphContent = tempContent.substring(endOffset);

        sourceParagraphsList[0] = leftParagraphContent;

        /// 改变当前计算高度,既然当前内容展示不下，那么currentHeight自然是height了
        currentHeight = contentHeight;
      } else {
        /// 计算设置当前高度
        currentHeight += lineHeight * lineMetrics.length;
        currentHeight += paragraphSpacing;

        sourceParagraphsList.removeAt(0);
      }

      sourceConfig.paragraphContents.add(currentParagraphContent);
    }
  }

  /// 根据给定的页面配置的数据，生成对应的TextSpan
  static List<TextSpan> buildTextSpanListByPageContentConfig(
      ReaderChapterPageContentConfig sourceConfig) {
    var result = <TextSpan>[];

    var paragraphSpacing = sourceConfig.currentContentParagraphSpacing;

    for (var paragraphData in sourceConfig.paragraphContents) {
      var paragraphSpan = TextSpan(
          text: paragraphData + '\r\n',
          style: TextStyle(
              fontSize: sourceConfig.currentContentFontSize,
              height: sourceConfig.currentContentLineHeight /
                  sourceConfig.currentContentFontSize));

      result.add(paragraphSpan);
    }

    return result;
  }
}
