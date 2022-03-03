import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';
import 'package:flutter_novel/net/api/api_novel.dart';
import 'package:flutter_novel/novel/model/novel_content_model.dart';
import 'package:flutter_novel/novel/viewmodel/novel_chapter_content_view_model.dart';
import 'package:flutter_novel/reader/layout/simulation/controller/power_list_scroll_simulation_controller.dart';
import 'package:flutter_novel/reader/layout/simulation/power_list_simulation_layout_manager.dart';
import 'package:flutter_novel/widget/scroll/power_scroll_view.dart';
import 'package:get/get.dart';

import 'novel_reader_list_item_of_page.dart';

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
          return _NovelListChapterContentView(
            novelChapterInfo: novelChapterInfo,
            contentWidth: constraints.maxWidth,
            contentHeight: constraints.maxHeight,
            currentChapterIndex: currentChapterIndex,
          );
        },
      ),
    );
  }
}

class _NovelListChapterContentView
    extends BaseView<NovelChapterContentViewModel> {
  final NovelChapterInfo novelChapterInfo;
  final int currentChapterIndex;
  final double contentWidth;
  final double contentHeight;

  const _NovelListChapterContentView({
    Key? key,
    required this.novelChapterInfo,
    this.currentChapterIndex = 0,
    required this.contentWidth,
    required this.contentHeight,
  }) : super(key: key);

  @override
  Widget buildContent(
      BuildContext context, NovelChapterContentViewModel viewModel) {
    return Container(
      child: ObxValue<Rx<NovelChapterInfo?>>((data) {
        if (null == data.value ||
            (data.value?.chapterPageContentList.isEmpty ?? false)) {
          return Container(
            child: Text('正在解析'),
          );
        }

        var chapterInfo = data.value!;

        return Container(
          height: contentHeight,
          width: contentWidth,
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
      }, viewModel.chapterData),
    );
  }

  @override
  NovelChapterContentViewModel buildViewModel() {
    return NovelChapterContentViewModel(
        currentChapterInfo: novelChapterInfo,
        contentWidth: contentWidth,
        contentHeight: contentHeight,
        contentParser: NetNovelContentModel(XiaShuWangApi()));
  }

  @override
  String? get tag => novelChapterInfo.chapterUri.toString();
}
