import 'package:flutter/services.dart' show rootBundle;
import 'package:test_project/reader/mixin/novel_lifecycle.dart';
import 'package:test_project/reader/split/entity/content_split_entity.dart';

abstract class NovelChapterContentModel with NovelPageLifeCycle {
  /// 加载 reader 章节内容
  Future<String?> loadNovelChapter(
      {required Uri uri,
      required double contentWidth,
      required double contentHeight}) async {
    /// 1、 先去从缓存中查找是否存在对应缓存
    /// 2、 没有的话就去请求
    /// 3、 请求到了加入到缓存中

    String? content = await queryCachedNovelChapterContent(uri: uri);
    if (content == null || content.length == 0) {
      var content = await getNovelChapterContent(uri: uri);
      cacheContent(chapterContent: content);
      return content;
    }

    return null;
  }

  Future<NovelInfo> getNovelInfo();

  /// 通过URI 查询缓存内容
  Future<String?> queryCachedNovelChapterContent({required Uri uri});

  /// 通过URI 解析章节内容
  Future<String> getNovelChapterContent({required Uri uri});

  /// 缓存内容
  Future<bool> cacheContent({required String chapterContent});

  @override
  void onDisposed() {}
}

class AssetNovelContentParser extends NovelChapterContentModel {
  @override
  Future<bool> cacheContent({required String chapterContent}) async {
    return true;
  }

  @override
  Future<String> getNovelChapterContent({required Uri uri}) async {
    // var s = await rootBundle.loadString('assets/test.txt', cache: false);
    // return s;
    var s = await rootBundle.loadString('assets/${uri.path}', cache: false);
    return s;
    // return await rootBundle.loadString('assets/${uri.path}', cache: false);
  }

  @override
  Future<NovelInfo> getNovelInfo() async {
    NovelInfo info = NovelInfo();
    info.currentChapterIndex = 0;

    var testChapterList = <NovelChapterInfo>[];
    testChapterList.add(NovelChapterInfo()
      ..chapterUri = Uri(path: 'chapter1.txt')
      ..chapterIndex = 0);
    testChapterList.add(NovelChapterInfo()
      ..chapterUri = Uri(path: 'chapter2.txt')
      ..chapterIndex = 1);
    testChapterList.add(NovelChapterInfo()
      ..chapterUri = Uri(path: 'chapter3.txt')
      ..chapterIndex = 2);
    testChapterList.add(NovelChapterInfo()
      ..chapterUri = Uri(path: 'chapter4.txt')
      ..chapterIndex = 3);
    testChapterList.add(NovelChapterInfo()
      ..chapterUri = Uri(path: 'chapter5.txt')
      ..chapterIndex = 4);
    testChapterList.add(NovelChapterInfo()
      ..chapterUri = Uri(path: 'chapter6.txt')
      ..chapterIndex = 5);

    info.novelChapterList = testChapterList;

    return info;
  }

  @override
  Future<String?> queryCachedNovelChapterContent({required Uri uri}) async {
    return null;
  }
}

class LocalNovelContentParser extends NovelChapterContentModel {
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
  Future<NovelInfo> getNovelInfo() async {
    // TODO: implement loadNovelChapter
    throw UnimplementedError();
  }

  @override
  Future<String?> queryCachedNovelChapterContent({required Uri uri}) {
    // TODO: implement queryCachedNovelChapterContent
    throw UnimplementedError();
  }
}
