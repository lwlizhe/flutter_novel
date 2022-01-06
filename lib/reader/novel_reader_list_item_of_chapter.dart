import 'package:flutter/material.dart';
import 'package:test_project/reader/layout/simulation/controller/power_list_scroll_simulation_controller.dart';
import 'package:test_project/reader/layout/simulation/power_list_simulation_layout_manager.dart';
import 'package:test_project/reader/model/novel_content_model.dart';
import 'package:test_project/reader/novel_reader_list_item_of_page.dart';
import 'package:test_project/reader/split/content_split_util.dart';
import 'package:test_project/reader/split/entity/content_split_entity.dart';
import 'package:test_project/reader/viewmodel/novel_content_view_model.dart';
import 'package:test_project/reader/widget/novel_reader_error_widget.dart';
import 'package:test_project/reader/widget/novel_reader_loading_widget.dart';
import 'package:test_project/widget/scroll/power_scroll_view.dart';

/// 小说阅读器 章节Item部分，内容是每章多少多少页；
/// 负责章节的加载、下载缓存、计算等部分
/// 章节中内容和每页内容展示交给 NovelListChapterPageItem 处理；
class NovelListChapterItem extends StatelessWidget {
  final NovelChapterInfo novelChapterInfo;
  final int currentChapterIndex;

  const NovelListChapterItem({
    Key? key,
    required this.novelChapterInfo,
    this.currentChapterIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          NovelContentPageViewModel pageViewModel = NovelContentPageViewModel(
              contentParser: AssetNovelContentParser(),
              chapterUri: novelChapterInfo.chapterUri!);

          double pageWidth = MediaQuery.of(context).size.width;
          double pageHeight = MediaQuery.of(context).size.height;

          return FutureBuilder<NovelChapterInfo>(
            future: pageViewModel.contentParser
                .loadNovelChapter(
                    uri: novelChapterInfo.chapterUri!,
                    contentWidth: pageWidth,
                    contentHeight: pageHeight - 300)
                .then((value) => parseChapter(
                    chapterContent: value!,
                    contentHeight: pageHeight - 300,
                    contentWidth: pageWidth,
                    fontSize: 16.0,
                    lineHeight: 32.0,
                    currentIndex:
                        currentChapterIndex > novelChapterInfo.chapterIndex
                            ? 999999999999
                            : 0)),
            builder: (BuildContext context,
                AsyncSnapshot<NovelChapterInfo> snapshot) {
              if (snapshot.hasError) {
                return NovelReaderErrorWidget();
              }

              if (!snapshot.hasData) {
                return NovelReaderLoadingWidget();
              }

              var chapterInfo = snapshot.data!;
              // return NovelListChapterPageItem(pageContentConfig:chapterInfo.chapterPageContentList);

              return Container(
                height: pageHeight,
                width: pageWidth,
                child: PowerListView.builder(
                  physics: PageScrollPhysics(),
                  // controller: PowerListScrollSimulationController(
                  //     initialPage: chapterInfo.chapterIndex),
                  controller: PowerListScrollSimulationController(),
                  addRepaintBoundaries: false,
                  scrollDirection: Axis.horizontal,
                  // layoutManager: PowerListCoverLayoutManager(),
                  layoutManager: PowerListSimulationTurnLayoutManager(),
                  debugTag: 'inner_${novelChapterInfo.chapterIndex}',
                  itemBuilder: (BuildContext context, int _index) {
                    return NovelListChapterPageItem(
                        pageContentConfig:
                            chapterInfo.chapterPageContentList[_index]);
                  },
                  itemCount: chapterInfo.chapterPageContentList.length,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<NovelChapterInfo> parseChapter({
    required String chapterContent,
    required double contentHeight,
    required double contentWidth,
    required double fontSize,
    required double lineHeight,
    double paragraphSpacing = 0,
    int currentIndex = 0,
  }) async {
    return await ContentSplitUtil.calculateChapter(
      chapterContent: chapterContent,
      contentHeight: contentHeight,
      contentWidth: contentWidth,
      fontSize: fontSize,
      lineHeight: lineHeight,
      currentIndex: currentIndex,
    );
  }
}
