import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';
import 'package:flutter_novel/novel/model/novel_content_model.dart';
import 'package:flutter_novel/novel/util/novel_heler.dart';
import 'package:flutter_novel/novel/view/reader/novel_reader_list_item_of_page.dart';
import 'package:flutter_novel/novel/viewmodel/novel_chapter_content_view_model.dart';
import 'package:flutter_novel/novel/viewmodel/novel_content_view_model.dart';
import 'package:flutter_novel/widget/scroll/power_scroll_view.dart';
import 'package:get/get.dart';

/// 小说阅读器 章节Item部分，内容是每章多少多少页；
/// 负责章节的加载、下载缓存、计算等部分
/// 章节中内容和每页内容展示交给 NovelListChapterPageItem 处理；
class NovelListChapterItem extends StatelessWidget {
  final NovelChapterInfo novelChapterInfo;
  final int currentChapterIndex;
  final ReaderTurnPageMode turnMode;

  const NovelListChapterItem(
      {Key? key,
      required this.novelChapterInfo,
      this.currentChapterIndex = 0,
      this.turnMode = ReaderTurnPageMode.normalMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Container(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return _NovelListChapterContentView(
                novelChapterInfo: novelChapterInfo,
                contentWidth: constraints.maxWidth,
                contentHeight: constraints.maxHeight,
                currentChapterIndex: currentChapterIndex,
                turnMode: turnMode,
              );
            },
          ),
        ));
  }
}

class _NovelListChapterContentView
    extends BaseView<NovelChapterContentViewModel> {
  final NovelChapterInfo novelChapterInfo;
  final int currentChapterIndex;
  final double contentWidth;
  final double contentHeight;
  final ReaderTurnPageMode turnMode;

  const _NovelListChapterContentView({
    Key? key,
    required this.novelChapterInfo,
    this.turnMode = ReaderTurnPageMode.normalMode,
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
            alignment: AlignmentDirectional.center,
            child: Text(
              '正在解析',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        var chapterInfo = data.value!;

        return Container(
          height: contentHeight,
          width: contentWidth,
          child: PowerListView.builder(
            key: ValueKey('$turnMode+${novelChapterInfo.chapterIndex}'),
            physics: PageScrollPhysics(),
            controller: buildNovelScrollController(turnMode),
            addRepaintBoundaries: turnMode != ReaderTurnPageMode.simulationMode,
            scrollDirection: Axis.horizontal,
            layoutManager: buildNovelLayoutManager(turnMode),
            debugTag: 'inner_${novelChapterInfo.chapterIndex}',
            itemBuilder: (BuildContext context, int _index) {
              return Container(
                child: NovelListChapterPageItem(
                  pageContentConfig: chapterInfo.chapterPageContentList[_index],
                  novelChapterInfo: novelChapterInfo,
                ),
              );
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
        contentWidth: contentWidth - 16 * 2,
        contentHeight: contentHeight - 70,
        contentParser: AssetNovelContentParser());
  }

  @override
  String? get tag => novelChapterInfo.chapterUri.toString();
}
