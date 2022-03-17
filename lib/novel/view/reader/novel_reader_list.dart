import 'package:flutter/material.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';
import 'package:flutter_novel/novel/util/novel_heler.dart';
import 'package:flutter_novel/novel/view/reader/novel_reader_list_item_of_chapter.dart';
import 'package:flutter_novel/novel/viewmodel/novel_content_view_model.dart';
import 'package:flutter_novel/reader/layout/simulation/controller/power_list_scroll_simulation_controller.dart';
import 'package:flutter_novel/reader/widget/novel_reader_loading_widget.dart';
import 'package:flutter_novel/widget/scroll/power_scroll_view.dart';
import 'package:get/get.dart';

/// 小说阅读器整体部分
/// 这部分负责处理目录和对应章节的管理
/// 具体章节内容，通过当前章节对应index，从目录中获取信息并传给 NovelListChapterItem ，由其处理具体章节内容展示
class NovelReaderListPage extends StatelessWidget {
  final String novelId;

  const NovelReaderListPage(this.novelId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GetBuilder(
          init: Get.find<NovelContentChapterViewModel>(tag: novelId),
          builder: (NovelContentChapterViewModel viewModel) {
            var value = viewModel.currentNovelInfo;
            var turnPageMode = viewModel.currentTurnMode;
            if (value.value == null ||
                (value.value!.chapterList?.isEmpty ?? false)) {
              return NovelReaderLoadingWidget();
            }

            List<NovelChapterInfo> chapterList = value.value!.chapterList!;

            var initialPageIndex = 1;

            var controller = PowerListScrollSimulationController(
                initialPage: initialPageIndex);
            return PowerListView.builder(
              key: ValueKey(turnPageMode),
              physics: PageScrollPhysics(),
              // controller: controller,
              controller: buildNovelScrollController(turnPageMode),
              // controller: PowerListScrollSimulationController(),
              addRepaintBoundaries:
                  turnPageMode != ReaderTurnPageMode.simulationMode,
              scrollDirection: Axis.horizontal,
              layoutManager: buildNovelLayoutManager(turnPageMode),
              debugTag: 'outerParent',
              itemBuilder: (BuildContext context, int _index) {
                return NovelListChapterItem(
                  novelChapterInfo: chapterList[_index],
                  currentChapterIndex: initialPageIndex,
                  turnMode: turnPageMode,
                );
                // return buildTestContentItem(constraints, _index);
              },
              itemCount: chapterList.length,
            );
          },
        ),

        // child: ObxValue<Rx<NovelBookDetailInfo?>>((value) {
        //   if (value.value == null ||
        //       (value.value!.chapterList?.isEmpty ?? false)) {
        //     return NovelReaderLoadingWidget();
        //   }
        //
        //   List<NovelChapterInfo> chapterList = value.value!.chapterList!;
        //   bool test = value.value!.test;
        //
        //   var initialPageIndex = 1;
        //
        //   var controller = PowerListScrollSimulationController(
        //       initialPage: initialPageIndex);
        //   return PowerListView.builder(
        //     physics: PageScrollPhysics(),
        //     // controller: controller,
        //     controller: test
        //         ? PowerListPageScrollController()
        //         : PowerListScrollSimulationController(),
        //     // controller: PowerListScrollSimulationController(),
        //     addRepaintBoundaries: test,
        //     scrollDirection: Axis.horizontal,
        //     layoutManager: test
        //         ? PowerListCoverLayoutManager()
        //         : PowerListSimulationTurnLayoutManager(),
        //     debugTag: 'outerParent',
        //     itemBuilder: (BuildContext context, int _index) {
        //       return NovelListChapterItem(
        //         novelChapterInfo: chapterList[_index],
        //         currentChapterIndex: initialPageIndex,
        //       );
        //       // return buildTestContentItem(constraints, _index);
        //     },
        //     itemCount: chapterList.length,
        //   );
        // },
        //     Get.find<NovelContentChapterViewModel>(tag: novelId)
        //         .currentNovelInfo),
      ),
    );
  }
}
