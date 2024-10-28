import 'package:flutter/services.dart' show rootBundle;

import '../entity/novel/entity_novel_book_info.dart';
import '../entity/novel/entity_novel_config_info.dart';
import '../util/content_split_util.dart';

abstract class NovelChapterContentModel {
  /// 加载 reader 章节内容
  Future<NovelChapterInfo?> loadNovelChapter({
    required NovelChapterInfo chapterInfo,
    required NovelConfigInfo config,
  }) async {
    /// 1、 先去从缓存中查找是否存在对应缓存
    /// 2、 没有的话就去请求
    /// 3、 请求到了加入到缓存中

    if (chapterInfo.chapterUri != null) {
      String? content =
          await queryCachedNovelChapterContent(chapterInfo: chapterInfo);
      if (content == null || content.isEmpty) {
        content = await getNovelChapterContent(chapterInfo: chapterInfo);
        cacheContent(chapterContent: content);
      }

      return await parseChapterContent(
          content: content, chapterInfo: chapterInfo, config: config);
    } else {
      return Future.error('uri 为空');
    }
  }

  Future<NovelBookDetailInfo?> getNovelInfo({required Uri uri});

  Future<NovelChapterInfo?> parseChapterContent(
      {required String? content,
      required NovelChapterInfo chapterInfo,
      required NovelConfigInfo config});

  /// 通过URI 查询缓存内容
  Future<String?> queryCachedNovelChapterContent(
      {required NovelChapterInfo chapterInfo});

  /// 通过URI 解析章节内容
  Future<String> getNovelChapterContent(
      {required NovelChapterInfo chapterInfo});

  /// 通过URI 查询章节列表
  Future<List<NovelChapterInfo>?> queryNovelChapterList({required Uri uri});

  /// 缓存内容
  Future<bool> cacheContent({required String chapterContent});
}

class FakeTestNovelContentParser extends NovelChapterContentModel {
  @override
  Future<bool> cacheContent({required String chapterContent}) async {
    return true;
  }

  @override
  Future<String> getNovelChapterContent(
      {required NovelChapterInfo chapterInfo}) async {
    var s = await rootBundle.loadString('assets/test.txt', cache: false);
    return s;
  }

  @override
  Future<NovelBookDetailInfo> getNovelInfo({required Uri uri}) async {
    var testChapterList = <NovelChapterInfo>[];
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 0,
        chapterTitle: 'Title1',
        chapterUri: Uri(path: 'chapter1.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 1,
        chapterTitle: 'Title2',
        chapterUri: Uri(path: 'chapter2.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 2,
        chapterTitle: 'Title3',
        chapterUri: Uri(path: 'chapter3.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 3,
        chapterTitle: 'Title4',
        chapterUri: Uri(path: 'chapter4.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 4,
        chapterTitle: 'Title5',
        chapterUri: Uri(path: 'chapter5.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 5,
        chapterTitle: 'Title6',
        chapterUri: Uri(path: 'chapter6.txt')));

    return NovelBookDetailInfo(
        bookAuthor: '本地测试', chapterList: testChapterList);
  }

  @override
  Future<String?> queryCachedNovelChapterContent(
      {required NovelChapterInfo chapterInfo}) async {
    return null;
  }

  @override
  Future<List<NovelChapterInfo>?> queryNovelChapterList(
      {required Uri uri}) async {
    return [];
  }

  @override
  Future<NovelChapterInfo?> parseChapterContent(
      {required String? content,
      required NovelChapterInfo chapterInfo,
      required NovelConfigInfo config}) async {
    if (content != null && content.isNotEmpty) {
      return await ContentSplitUtil.calculateChapter(
        chapterContent: content,
        chapterInfo: chapterInfo,
        config: config,
        contentHeight: config.displayHeight,
        contentWidth: config.displayWidth,
      );
    } else {
      return Future.error('内容为空');
    }
  }
}

class AssetNovelContentParser extends NovelChapterContentModel {
  @override
  Future<bool> cacheContent({required String chapterContent}) async {
    return true;
  }

  @override
  Future<String> getNovelChapterContent(
      {required NovelChapterInfo chapterInfo}) async {
    // var s = await rootBundle.loadString('assets/test.txt', cache: false);
    // return s;
    var s = await rootBundle
        .loadString('assets/${chapterInfo.chapterUri!.path}', cache: false);
    return s;
    // return await rootBundle.loadString('assets/${uri.path}', cache: false);
  }

  @override
  Future<NovelBookDetailInfo> getNovelInfo({required Uri uri}) async {
    var testChapterList = <NovelChapterInfo>[];
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 0,
        chapterTitle: 'Title1',
        chapterUri: Uri(path: 'chapter1.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 1,
        chapterTitle: 'Title2',
        chapterUri: Uri(path: 'chapter2.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 2,
        chapterTitle: 'Title3',
        chapterUri: Uri(path: 'chapter3.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 3,
        chapterTitle: 'Title4',
        chapterUri: Uri(path: 'chapter4.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 4,
        chapterTitle: 'Title5',
        chapterUri: Uri(path: 'chapter5.txt')));
    testChapterList.add(NovelChapterInfo(
        chapterIndex: 5,
        chapterTitle: 'Title6',
        chapterUri: Uri(path: 'chapter6.txt')));

    return NovelBookDetailInfo(
        bookAuthor: '本地测试', chapterList: testChapterList);
  }

  @override
  Future<String?> queryCachedNovelChapterContent(
      {required NovelChapterInfo chapterInfo}) async {
    return null;
  }

  @override
  Future<List<NovelChapterInfo>?> queryNovelChapterList(
      {required Uri uri}) async {
    return [];
  }

  @override
  Future<NovelChapterInfo?> parseChapterContent(
      {required String? content,
      required NovelChapterInfo chapterInfo,
      required NovelConfigInfo config}) async {
    if (content != null && content.isNotEmpty) {
      return await ContentSplitUtil.calculateChapter(
        chapterContent: content,
        chapterInfo: chapterInfo,
        config: config,
        contentHeight: config.displayHeight,
        contentWidth: config.displayWidth,
      );
    } else {
      return Future.error('内容为空');
    }
  }
}