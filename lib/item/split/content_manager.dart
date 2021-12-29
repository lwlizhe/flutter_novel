import 'package:async/async.dart';
import 'package:test_project/item/split/entity/content_split_entity.dart';

mixin NovelPageLifeCycle {
  void onInit() {}

  void onDisposed() {}
}

class NovelContentManager with NovelPageLifeCycle {
  NovelContentParser contentParser;

  ChapterInfo? currentChapter;
  ChapterInfo? preChapter;
  ChapterInfo? nextChapter;

  List<ChapterInfo>? currentNovelChapterList = [];
  int chapterIndex = 0;

  NovelContentManager({required this.contentParser});

  @override
  void onInit() {
    contentParser.onInit();

    contentParser
        .getNovelChapterList()
        .then((value) => currentNovelChapterList = value);
  }

  @override
  void onDisposed() {
    contentParser.onDisposed();
  }
}

abstract class NovelContentParser with NovelPageLifeCycle {
  CancelableOperation? cancelOperation;

  /// 加载 novel 章节内容
  void loadNovelChapter({required Uri uri}) async {
    /// 1、 先去从缓存中查找是否存在对应缓存
    /// 2、 没有的话就去请求
    /// 3、 请求到了加入到缓存中

    String? content = await queryCachedNovelChapterContent(uri: uri);
    if (content == null || content.length == 0) {
      cancelOperation =
          CancelableOperation.fromFuture(getNovelChapterContent(uri: uri));
      cancelOperation?.then((content) {
        cacheContent(chapterContent: content);
      });
    }
  }

  Uri get chapterUri;

  Future<List<ChapterInfo>> getNovelChapterList();

  /// 通过URI 查询缓存内容
  Future<String?> queryCachedNovelChapterContent({required Uri uri});

  /// 通过URI 解析章节内容
  Future<String> getNovelChapterContent({required Uri uri});

  /// 缓存内容
  Future<bool> cacheContent({required String chapterContent});

  @override
  void onInit() {
    loadNovelChapter(uri: chapterUri);
  }

  @override
  void onDisposed() {
    cancelOperation?.cancel();
  }
}

class NetNovelContentParser extends NovelContentParser {
  @override
  Future<bool> cacheContent({required String chapterContent}) {
    // TODO: implement cacheContent
    throw UnimplementedError();
  }

  @override
  Future<String> getNovelChapterContent({required Uri uri}) {
    // TODO: implement loadNovelChapter
    throw UnimplementedError();
  }

  @override
  Future<List<ChapterInfo>> getNovelChapterList() {
    // TODO: implement getNovelChapterList
    throw UnimplementedError();
  }

  @override
  Future<String?> queryCachedNovelChapterContent({required Uri uri}) {
    // TODO: implement queryCachedNovelChapterContent
    throw UnimplementedError();
  }

  @override
  // TODO: implement chapterUri
  Uri get chapterUri => throw UnimplementedError();
}

class LocalNovelContentParser extends NovelContentParser {
  @override
  Future<bool> cacheContent({required String chapterContent}) {
    // TODO: implement cacheContent
    throw UnimplementedError();
  }

  @override
  Future<String> getNovelChapterContent({required Uri uri}) {
    // TODO: implement loadNovelChapter
    throw UnimplementedError();
  }

  @override
  Future<List<ChapterInfo>> getNovelChapterList() {
    // TODO: implement getNovelChapterList
    throw UnimplementedError();
  }

  @override
  Future<String?> queryCachedNovelChapterContent({required Uri uri}) {
    // TODO: implement queryCachedNovelChapterContent
    throw UnimplementedError();
  }

  @override
  // TODO: implement chapterUri
  Uri get chapterUri => throw UnimplementedError();
}
