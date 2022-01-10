import 'package:flutter_novel/reader/mixin/novel_lifecycle.dart';
import 'package:flutter_novel/reader/model/novel_content_model.dart';
import 'package:flutter_novel/reader/split/entity/content_split_entity.dart';

class NovelContentChapterViewModel with NovelPageLifeCycle {
  NovelChapterContentModel contentParser;

  List<NovelChapterInfo>? currentNovelChapterList = [];

  int chapterIndex = 0;

  NovelContentChapterViewModel({required this.contentParser});

  Future<List<NovelChapterInfo>> getChapterList() async {
    return (await contentParser.getNovelInfo()).novelChapterList;
  }

  @override
  void onInit() {
    // contentParser.onInit();
    //
    // contentParser
    //     .getNovelInfo()
    //     .then((value) => currentNovelChapterList = value.novelChapterList);
  }

  @override
  void onDisposed() {
    contentParser.onDisposed();
  }
}

class NovelContentPageViewModel with NovelPageLifeCycle {
  NovelChapterContentModel contentParser;

  NovelChapterInfo? chapterInfo = NovelChapterInfo();
  Uri chapterUri;

  int currentPageIndex = 0;

  NovelContentPageViewModel(
      {required this.contentParser, required this.chapterUri});

  @override
  void onInit() async {
    contentParser.onInit();
  }

  @override
  void onDisposed() {
    contentParser.onDisposed();
  }
}
