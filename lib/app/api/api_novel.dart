import 'package:flutter_novel/app/novel/entity/entity_novel_book_chapter.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_key_word_search.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_recommend.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_review.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_source.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_detail.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_short_comment.dart';
import 'package:flutter_novel/base/http/manager_net_request.dart';

class NovelApi {
  static const String BASE_URL = "http://api.zhuishushenqi.com/";
  static const String READER_IMAGE_URL = 'http://statics.zhuishushenqi.com';

  static const String QUERY_AUTO_COMPLETE_QUERY_KEYWORD =
      BASE_URL + "book/auto-complete?query=";
  static const String QUERY_HOT_QUERY_KEYWORD = BASE_URL + "book/hot-word";
  static const String QUERY_BOOK_KEY_WORD = BASE_URL + "book/fuzzy-search";
  static const String QUERY_BOOK_DETAIL_INFO = BASE_URL + "book/";
  static const String QUERY_BOOK_SHORT_REVIEW = BASE_URL + "post/short-review";
  static const String QUERY_BOOK_REVIEW = BASE_URL + "post/review/by-book";
  static const String QUERY_BOOK_RECOMMEND = BASE_URL + "book/{id}/recommend";
  static const String QUERY_BOOK_CATALOG =
      BASE_URL + "atoc/{sourceid}?view=chapters";
  static const String QUERY_BOOK_SOURCE =
      BASE_URL + "btoc?book={bookId}&view=summary";
  static const String QUERY_BOOK_CHAPTER_CONTENT =
      "http://chapterup.zhuishushenqi.com/chapter/{link}";

  var client = NetRequestManager.instance;

  /// 小说搜索词
  Future<BaseResponse<List<String>>> getSearchWord(String keyWord) async {
    var response;
    BaseResponse<List<String>> result = BaseResponse();
    List<String> resultData = [];
    try {
      response =
          await client.getRequest(QUERY_AUTO_COMPLETE_QUERY_KEYWORD + keyWord);
      bool isOk = response?.data["ok"];
      if (isOk) {
        for (var data in response.data["keywords"]) {
          resultData.add(data);
        }
      }
      result.isSuccess = isOk;
      result.data = resultData;
    } catch (e) {
      print("$e");
      result.isSuccess = false;
    }
    return result;
  }

  /// 小说搜索热词
  Future<BaseResponse<List<String>>> getHotSearchWord() async {
    var response;
    BaseResponse<List<String>> result = BaseResponse();

    List<String> resultData = [];
    try {
      response = await client.getRequest(QUERY_HOT_QUERY_KEYWORD);
      for (var data in response.data["hotWords"]) {
        resultData.add(data);
      }
      result.isSuccess = true;
      result.data = resultData;
    } catch (e) {
      print("$e");
    }
    return result;
  }

  /// 小说关键词搜索
  Future<BaseResponse<NovelKeyWordSearch>> searchTargetKeyWord(String keyWord,
      {int start: 0, int limit: 20}) async {
    var response;
    BaseResponse<NovelKeyWordSearch> result = BaseResponse();

    try {
      response = await client.getRequest(QUERY_BOOK_KEY_WORD,
          queryParameters: {"query": keyWord, "start": start, "limit": limit});

      result.isSuccess = true;
      result.data = NovelKeyWordSearch.fromJson(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }

  /// 小说详情
  Future<BaseResponse<NovelDetailInfo>> getNovelDetailInfo(
      String bookId) async {
    BaseResponse<NovelDetailInfo> result = BaseResponse()..isSuccess = false;
    try {
      var response = await client.getRequest(QUERY_BOOK_DETAIL_INFO + bookId);
      result.isSuccess = true;
      result.data = NovelDetailInfo.fromJson(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }

  /// 小说短评列表
  Future<BaseResponse<NovelShortComment>> getNovelShortReview(String id,
      {String sort: 'updated', int start: 0, int limit: 2}) async {
    BaseResponse<NovelShortComment> result = BaseResponse()..isSuccess = false;
    try {
      var response = await client.getRequest(QUERY_BOOK_SHORT_REVIEW,
          queryParameters: {
            "book": id,
            "sort": sort,
            "start": start,
            "limit": limit
          });
      result.isSuccess = true;
      result.data = NovelShortComment.fromJson(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }

  /// 小说书评列表
  Future<BaseResponse<NovelBookReview>> getNovelBookReview(String id,
      {String sort: 'updated', int start: 0, int limit: 2}) async {
    BaseResponse<NovelBookReview> result = BaseResponse()..isSuccess = false;
    try {
      var response = await client.getRequest(QUERY_BOOK_REVIEW,
          queryParameters: {
            "book": id,
            "sort": sort,
            "start": start,
            "limit": limit
          });
      result.isSuccess = true;
      result.data = NovelBookReview.fromJson(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }

  /// 小说推荐书籍列表
  Future<BaseResponse<NovelBookRecommend>> getNovelBookRecommend(
      String id) async {
    BaseResponse<NovelBookRecommend> result = BaseResponse()..isSuccess = false;
    try {
      var response =
          await client.getRequest(QUERY_BOOK_RECOMMEND.replaceAll("{id}", id));
      result.isSuccess = true;
      result.data = NovelBookRecommend.fromJson(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }

  /// 小说追书神器源
  Future<BaseResponse<List<NovelBookSource>>> getNovelSource(
      String novelId) async {
    BaseResponse<List<NovelBookSource>> result = BaseResponse()
      ..isSuccess = false;
    try {
      var response = await client
          .getRequest(QUERY_BOOK_SOURCE.replaceAll("{bookId}", novelId));
      result.isSuccess = true;
      result.data = getNovelBookSourceList(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }

  /// 小说章节内容
  Future<BaseResponse<NovelBookChapter>> getNovelCatalog(
      String sourceId) async {
    BaseResponse<NovelBookChapter> result = BaseResponse()..isSuccess = false;
    try {
      var response = await client
          .getRequest(QUERY_BOOK_CATALOG.replaceAll("{sourceid}", sourceId));
      result.isSuccess = true;
      result.data = NovelBookChapter.fromJson(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }
}

class BaseResponse<T> {
  bool isSuccess;
  T data;
}
