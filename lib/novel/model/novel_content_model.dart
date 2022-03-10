import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';
import 'package:flutter_novel/net/api/api_novel.dart';
import 'package:flutter_novel/reader/split/content_split_util.dart';

class ParseConfig {
  double contentWidth;
  double contentHeight;
  double fontSize;
  double lineHeight;
  int pageIndex;

  ParseConfig(
      {required this.contentHeight,
      required this.contentWidth,
      this.fontSize = 16,
      this.lineHeight = 32,
      this.pageIndex = 0});
}

abstract class NovelChapterContentModel extends BaseModel {
  /// 加载 reader 章节内容
  Future<NovelChapterInfo?> loadNovelChapter(
      {required NovelChapterInfo chapterInfo,
      required double contentWidth,
      required double contentHeight}) async {
    /// 1、 先去从缓存中查找是否存在对应缓存
    /// 2、 没有的话就去请求
    /// 3、 请求到了加入到缓存中

    if (chapterInfo.chapterUri != null) {
      String? content =
          await queryCachedNovelChapterContent(uri: chapterInfo.chapterUri!);
      if (content == null || content.length == 0) {
        content = await getNovelChapterContent(uri: chapterInfo.chapterUri!);
        cacheContent(chapterContent: content);
      }

      return await parseChapterContent(
          content: content,
          chapterInfo: chapterInfo,
          config: ParseConfig(
              contentHeight: contentHeight, contentWidth: contentWidth));
    } else {
      return Future.error('uri 为空');
    }
  }

  Future<NovelBookDetailInfo?> getNovelInfo({required Uri uri});

  Future<NovelChapterInfo?> parseChapterContent(
      {required String? content,
      required NovelChapterInfo chapterInfo,
      required ParseConfig config});

  /// 通过URI 查询缓存内容
  Future<String?> queryCachedNovelChapterContent({required Uri uri});

  /// 通过URI 解析章节内容
  Future<String> getNovelChapterContent({required Uri uri});

  /// 通过URI 查询章节列表
  Future<List<NovelChapterInfo>?> queryNovelChapterList({required Uri uri});

  /// 缓存内容
  Future<bool> cacheContent({required String chapterContent});
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
  Future<NovelBookDetailInfo> getNovelInfo({required Uri uri}) async {
    NovelBookDetailInfo info = NovelBookDetailInfo();
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

    info.chapterList = testChapterList;

    return info;
  }

  @override
  Future<String?> queryCachedNovelChapterContent({required Uri uri}) async {
    return null;
  }

  @override
  void init() {}

  @override
  Future<List<NovelChapterInfo>?> queryNovelChapterList(
      {required Uri uri}) async {
    return [];
  }

  @override
  Future<NovelChapterInfo?> parseChapterContent(
      {required String? content,
      required NovelChapterInfo chapterInfo,
      required ParseConfig config}) async {
    if (content != null && content.isNotEmpty) {
      return await ContentSplitUtil.calculateChapter(
        chapterContent: TextSpan(
            text: content, style: TextStyle(fontSize: config.fontSize)),
        contentHeight: config.contentHeight,
        contentWidth: config.contentWidth,
        currentIndex: config.pageIndex,
      );
    } else {
      return Future.error('内容为空');
    }
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
  Future<NovelBookDetailInfo> getNovelInfo({required Uri uri}) async {
    // TODO: implement loadNovelChapter
    throw UnimplementedError();
  }

  @override
  Future<String?> queryCachedNovelChapterContent({required Uri uri}) {
    // TODO: implement queryCachedNovelChapterContent
    throw UnimplementedError();
  }

  @override
  void init() {
    // TODO: implement init
  }

  @override
  Future<List<NovelChapterInfo>?> queryNovelChapterList({required Uri uri}) {
    // TODO: implement queryNovelChapterList
    throw UnimplementedError();
  }

  @override
  Future<NovelChapterInfo?> parseChapterContent(
      {required String? content,
      required NovelChapterInfo chapterInfo,
      required ParseConfig config}) {
    // TODO: implement parseChapterContent
    throw UnimplementedError();
  }
}

class NetNovelContentModel extends NovelChapterContentModel {
  BaseNovelApi currentApi;

  NetNovelContentModel(this.currentApi);

  @override
  Future<bool> cacheContent({required String chapterContent}) async {
    return true;
  }

  @override
  Future<String> getNovelChapterContent({required Uri uri}) {
    return currentApi.getChapterContent(uri);
  }

  @override
  Future<NovelBookDetailInfo> getNovelInfo({required Uri uri}) async {
    return await currentApi.getNovelInfo(uri);
  }

  @override
  void init() {}

  @override
  Future<String?> queryCachedNovelChapterContent({required Uri uri}) async {
    return await getNovelChapterContent(uri: uri);
  }

  @override
  Future<List<NovelChapterInfo>?> queryNovelChapterList(
      {required Uri uri}) async {
    return await currentApi.getChapterList(uri.toString());
  }

  @override
  Future<NovelChapterInfo?> parseChapterContent(
      {required String? content,
      required NovelChapterInfo chapterInfo,
      required ParseConfig config}) async {
    var titleStyle = TextStyle(
      color: Colors.black,
      fontSize: config.fontSize * 2,
      height: config.lineHeight / config.fontSize,
    );

    var contentStyle = TextStyle(
        color: Colors.black,
        fontSize: config.fontSize,
        height: config.lineHeight / config.fontSize);

    if (content != null && content.isNotEmpty) {
      return await ContentSplitUtil.calculateChapter(
        chapterContent: TextSpan(
            text: chapterInfo.chapterTitle,
            children: [TextSpan(text: content, style: contentStyle)],
            style: titleStyle),
        contentHeight: config.contentHeight,
        contentWidth: config.contentWidth,
        paragraphSpacing: 10.0,
        currentIndex: config.pageIndex,
      );
    } else {
      return Future.error('内容为空');
    }
  }
}
