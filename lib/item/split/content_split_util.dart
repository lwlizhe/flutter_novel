import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_project/item/split/content_manager.dart';

class ContentSplitUtil {
  static Future<ChapterInfo> calculateChapter(String chapterContent) {
    List<String> paragraphList = chapterContent.split('\r\n')
      ..removeWhere((element) => element.isEmpty);

    ChapterInfo info = ChapterInfo();
    info.chapterPageContentList = paragraphList;

    return Future.value(info);
  }

  static List<ReaderChapterPageContentConfig> getChapterPageContentConfigList({
    required String content,
    required double contentHeight,
    required double contentWidth,
    required int fontSize,
    required int lineHeight,
    int paragraphSpacing = 0,
  }) {
    String tempContent;
    List<ReaderChapterPageContentConfig> pageConfigList = [];
    double? currentHeight = 0;
    int pageIndex = 0;

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

    if (content.isEmpty) {
      return [];
    }

    List<String> paragraphs = content.split('\r\n')
      ..removeWhere((element) => element.isEmpty);

    while (paragraphs.length > 0) {
      ReaderChapterPageContentConfig config = ReaderChapterPageContentConfig();
      config.paragraphContents = [];
      config.currentContentFontSize = fontSize;
      config.currentContentLineHeight = lineHeight;
      config.currentContentParagraphSpacing = paragraphSpacing;
      config.currentPageIndex = pageIndex;

      while (currentHeight! < contentHeight) {
        /// 如果最后一行再添一行比页面高度大，或者已经没有内容了，那么当前页面计算结束
        if (currentHeight + lineHeight >= contentHeight ||
            paragraphs.length == 0) {
          break;
        }

        tempContent = paragraphs.first;

        /// 配置画笔 ///
        textPainter.text = TextSpan(
            text: tempContent,
            style: TextStyle(
                fontSize: fontSize.toDouble(), height: lineHeight / fontSize));
        textPainter.layout(maxWidth: contentWidth);

        /// 当前段落内容计算偏移量
        /// 为什么要减一个lineHeight？因为getPositionForOffset判断依据是只要能展示，即使展示不全，也在它的判定范围内，所以如需要减去一行高度
        int endOffset = textPainter
            .getPositionForOffset(Offset(
                contentWidth, contentHeight - currentHeight - lineHeight))
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

          /// 填入原先的段落数组中
          paragraphs.first = leftParagraphContent;

          /// 改变当前计算高度,既然当前内容展示不下，那么currentHeight自然是height了
          currentHeight = contentHeight;
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
}
