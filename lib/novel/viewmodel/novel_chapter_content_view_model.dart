import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';
import 'package:flutter_novel/novel/model/novel_content_model.dart';
import 'package:get/get.dart';

class NovelChapterContentViewModel
    extends BaseViewModel<NovelChapterContentModel> {
  final NovelChapterInfo currentChapterInfo;
  final double contentWidth;
  final double contentHeight;
  final NovelChapterContentModel contentParser;

  NovelChapterContentViewModel(
      {required this.currentChapterInfo,
      required this.contentWidth,
      required this.contentHeight,
      required this.contentParser})
      : super(model: contentParser);

  var chapterData = Rx<NovelChapterInfo?>(null);

  void parseChapterContent() {
    model
        ?.loadNovelChapter(
            uri: currentChapterInfo.chapterUri ?? Uri.parse(''),
            contentWidth: contentWidth,
            contentHeight: contentHeight)
        .then((value) async {
      chapterData.value = value;
    });
  }

  @override
  void onReady() {
    super.onReady();
    parseChapterContent();
  }
}
