import 'package:flutter/material.dart';
import 'package:test_project/novel/novel_reader_list_item_of_chapter.dart';
import 'package:test_project/novel/split/entity/content_split_entity.dart';
import 'package:test_project/novel/viewmodel/novel_content_view_model.dart';
import 'package:test_project/novel/widget/novel_reader_loading_widget.dart';
import 'package:test_project/scroll/controller/power_list_scroll_simulation_controller.dart';
import 'package:test_project/scroll/layout/manager/simulation/power_list_simulation_layout_manager.dart';
import 'package:test_project/scroll/power_scroll_view.dart';

import 'model/novel_content_model.dart';

/// 小说阅读器整体部分
/// 这部分负责处理目录和对应章节的管理
/// 具体章节内容，通过当前章节对应index，从目录中获取信息并传给 NovelListChapterItem ，由其处理具体章节内容展示
class NovelReaderListPage extends StatelessWidget {
  const NovelReaderListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<NovelChapterInfo>>(
          future: NovelContentChapterViewModel(
                  contentParser: AssetNovelContentParser())
              .getChapterList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<NovelChapterInfo>> snapshot) {
            if (snapshot.hasData) {
              List<NovelChapterInfo> chapterList = snapshot.data!;

              var initialPageIndex = 1;

              var controller = PowerListScrollSimulationController(
                  initialPage: initialPageIndex);
              return PowerListView.builder(
                physics: PageScrollPhysics(),
                controller: controller,
                // controller: PowerListScrollController(),
                addRepaintBoundaries: false,
                scrollDirection: Axis.horizontal,
                // layoutManager: PowerListCoverLayoutManager(),
                layoutManager: PowerListSimulationTurnLayoutManager(),
                itemBuilder: (BuildContext context, int _index) {
                  return NovelListChapterItem(
                    novelChapterInfo: chapterList[_index],
                    currentChapterIndex: (controller.position.hasPixels &&
                            controller.position.hasContentDimensions)
                        ? controller.page?.toInt() ?? 0
                        : initialPageIndex,
                  );
                  // return buildTestContentItem(constraints, _index);
                },
                itemCount: chapterList.length,
              );
            } else {
              return NovelReaderLoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
