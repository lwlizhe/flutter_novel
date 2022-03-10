import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';

const String LINE_FEED = '\n';

class ContentSplitUtil {
  static Future<NovelChapterInfo> calculateChapter({
    required TextSpan chapterContent,
    required double contentHeight,
    required double contentWidth,
    double paragraphSpacing = 0,
    int currentIndex = 0,
  }) {
    var pageContentConfigList = getChapterPageContentConfigList(
      chapterContent: chapterContent,
      contentHeight: contentHeight,
      contentWidth: contentWidth,
      paragraphSpacing: paragraphSpacing,
    );

    NovelChapterInfo info = NovelChapterInfo();
    info.chapterPageContentList = pageContentConfigList;
    info.chapterIndex = math.min(currentIndex, pageContentConfigList.length);

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
  static List<NovelPageContentInfo> getChapterPageContentConfigList({
    required TextSpan chapterContent,
    required double contentHeight,
    required double contentWidth,
    double paragraphSpacing = 0,
  }) {
    List<NovelPageContentInfo> pageConfigList = [];
    int pageIndex = 0;

    /// todo ：可以后续加上文字方向的设置
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

    List<TextSpan> targetList = [];

    if (chapterContent.text != null) {
      targetList.add(TextSpan(
          text: chapterContent.text, style: chapterContent.style?.copyWith()));
    }

    if (chapterContent.children != null) {
      targetList.addAll(chapterContent.children!
          .where((element) => element is TextSpan)
          .map((e) {
        var text = (e as TextSpan)
            .text
            ?.replaceAll('\r\n', LINE_FEED)
            .replaceAll('\n\n', LINE_FEED)
            .trim();
        return TextSpan(text: text, style: e.style);
      }).toList());
    }

    if (targetList.isEmpty) {
      return [];
    }

    List<TextSpan> paragraphs = [];

    for (var target in targetList) {
      var paragraphSpanList = (target.text?.split(LINE_FEED)
            ?..removeWhere((element) => element.isEmpty))
          ?.map((e) => TextSpan(text: e, style: target.style));
      if (paragraphSpanList != null && paragraphSpanList.isNotEmpty) {
        paragraphs.addAll(paragraphSpanList);
      }
    }

    // List<TextSpan> paragraphs = chapterContent
    //     .replaceAll('\r\n', '\n')
    //     .split('\n')
    //   ..removeWhere((element) => element.isEmpty);

    /// 不断计算，直到指定的段落list都计算完成；
    while (paragraphs.length > 0) {
      /// 用来放一页中有多少段落，内容、页码之类的东西；
      NovelPageContentInfo config = NovelPageContentInfo();
      config.paragraphContents = [];
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
    required NovelPageContentInfo sourceConfig,
    required List<TextSpan> sourceParagraphsList,
    required double contentHeight,
    required double contentWidth,
    required TextPainter textPainter,
  }) {
    double currentHeight = 0;
    TextSpan tempContentSpan;
    double paragraphSpacing = sourceConfig.currentContentParagraphSpacing;

    /// 循环计算，直到当前页面展示不下；这样就算出了一页的内容；
    while (currentHeight < contentHeight) {
      /// 如果最后一行再添一行比页面高度大，或者已经没有内容了，那么当前页面计算结束
      if (sourceParagraphsList.isEmpty) {
        break;
      }

      var firstLineStyle = sourceParagraphsList[0].style;

      if (firstLineStyle == null ||
          (currentHeight +
                  (firstLineStyle.fontSize ?? 0) *
                      (firstLineStyle.height ?? 0) >=
              contentHeight)) {
        break;
      }

      tempContentSpan = sourceParagraphsList.first;

      /// 配置画笔 ///
      // textPainter.text = TextSpan(
      //     text: tempContentSpan.text,
      //     style: TextStyle(fontSize: fontSize, height: lineHeight / fontSize));
      textPainter.text = tempContentSpan;
      textPainter.layout(maxWidth: contentWidth);

      var currentLineHeight =
          (firstLineStyle.height ?? 0) * (firstLineStyle.fontSize ?? 0);

      /// 当前段落内容计算偏移量
      /// 为什么要减一个lineHeight？因为getPositionForOffset判断依据是只要能展示，
      /// 所以即使展示不全，也在它的判定范围内，所以要减去一行高度，保证都能展示全
      int endOffset = textPainter
          .getPositionForOffset(Offset(
              contentWidth, contentHeight - currentHeight - currentLineHeight))
          .offset;

      /// 当前展示内容
      TextSpan currentParagraphContentSpan = TextSpan(
          text: tempContentSpan.text! + LINE_FEED,
          style: tempContentSpan.style?.copyWith());

      /// 改变当前计算高度
      List<LineMetrics> lineMetrics = textPainter.computeLineMetrics();

      /// 如果当前段落的内容展示不下，那么裁剪出展示内容，剩下内容填回去,否则移除顶部,计算下一个去
      if (endOffset < tempContentSpan.text!.length) {
        var currentParagraphContent =
            currentParagraphContentSpan.text!.substring(0, endOffset) +
                LINE_FEED;

        currentParagraphContentSpan = TextSpan(
            text: currentParagraphContent,
            style: tempContentSpan.style?.copyWith());

        /// 剩余内容
        String leftParagraphContent =
            tempContentSpan.text!.substring(endOffset);

        sourceParagraphsList[0] = TextSpan(
            text: leftParagraphContent,
            style: tempContentSpan.style?.copyWith());

        /// 改变当前计算高度,既然当前内容展示不下，那么currentHeight自然是height了
        currentHeight = contentHeight;
      } else {
        /// 计算设置当前高度
        currentHeight += lineMetrics[0].height * lineMetrics.length;
        currentHeight += paragraphSpacing;

        sourceParagraphsList.removeAt(0);
      }

      sourceConfig.paragraphContents.add(currentParagraphContentSpan);
      sourceConfig.paragraphContents.add(WidgetSpan(
          child: Container(
        height: paragraphSpacing,
      )));
    }
  }
}
