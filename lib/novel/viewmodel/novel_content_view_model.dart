import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';
import 'package:flutter_novel/novel/model/novel_content_model.dart';
import 'package:get/get.dart';

enum ReaderTurnPageMode { normalMode, coverMode, simulationMode }

class NovelContentChapterViewModel
    extends BaseViewModel<NovelChapterContentModel> {
  int chapterIndex = 0;
  final String novelId;

  var currentNovelInfo = Rx<NovelBookDetailInfo?>(null);
  ReaderTurnPageMode currentTurnMode = ReaderTurnPageMode.normalMode;

  NovelContentChapterViewModel(this.novelId,
      {required NovelChapterContentModel contentParserModel})
      : super(model: contentParserModel);

  Future<NovelBookDetailInfo?> getBookInfo(String tag) async {
    var queryResult = await model?.getNovelInfo(uri: Uri.parse(tag));
    return queryResult;
  }

  @override
  void onReady() async {
    super.onReady();
    model?.init();
    currentNovelInfo.value = await getBookInfo('绝世剑神');
    print(currentNovelInfo);
    refresh();
  }

  void changeTurnMode(ReaderTurnPageMode mode) {
    currentTurnMode = mode;
    refresh();
  }
}

class NovelContentPageViewModel {
  NovelChapterContentModel contentParser;

  NovelChapterInfo? chapterInfo = NovelChapterInfo();
  Uri chapterUri;

  int currentPageIndex = 0;

  NovelContentPageViewModel(
      {required this.contentParser, required this.chapterUri});
}
