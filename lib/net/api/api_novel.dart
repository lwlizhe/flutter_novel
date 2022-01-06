import 'package:test_project/base/http/manager_net_request.dart';
import 'package:test_project/net/constant.dart';
import 'package:test_project/net/entity/entity_novel_book_key_word_search.dart';
import 'package:test_project/net/entity/entity_novel_book_recommend.dart';
import 'package:test_project/net/entity/entity_novel_book_review.dart';
import 'package:test_project/net/entity/entity_novel_detail.dart';
import 'package:test_project/net/entity/entity_novel_short_comment.dart';

class NovelApi {
  var client = NetRequestManager();

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
}

class BaseResponse<T> {
  bool isSuccess = false;
  T? data;
}
