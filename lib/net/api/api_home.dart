import 'package:flutter_novel/base/http/manager_net_request.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:flutter_novel/net/entity/base/base_resp.dart';
import 'package:flutter_novel/net/entity/entity_novel_book_key_word_search.dart';
import 'package:flutter_novel/net/entity/entity_novel_book_recommend.dart';
import 'package:flutter_novel/net/entity/entity_novel_book_review.dart';
import 'package:flutter_novel/net/entity/entity_novel_categories.dart';
import 'package:flutter_novel/net/entity/entity_novel_detail_info.dart';
import 'package:flutter_novel/net/entity/entity_novel_info_by_tag.dart';
import 'package:flutter_novel/net/entity/entity_novel_rank_info_of_tag.dart';
import 'package:flutter_novel/net/entity/entity_novel_rank_tag_info.dart';
import 'package:flutter_novel/net/entity/entity_novel_short_comment.dart';

class HomeApi {
  var client = NetRequestManager();

  /// 获取分类
  Future<BaseResponse<NovelCategories>> getCategories() async {
    var response;
    BaseResponse<NovelCategories> result = BaseResponse();
    try {
      response = await client.getRequest(QUERY_NOVEL_CATEGORIES);
      bool isOk = response?.data["ok"];
      if (isOk) {
        result.isSuccess = isOk;
        result.data = NovelCategories.fromJson(response.data);
      }
    } catch (e) {
      print("$e");
      result.isSuccess = false;
    }
    return result;
  }

  /// 获取排行榜标签列表
  Future<BaseResponse<NovelRankTagInfo>> getNovelRankTagInfoList() async {
    var response;
    BaseResponse<NovelRankTagInfo> result = BaseResponse();
    try {
      response = await client.getRequest(
        QUERY_NOVEL_RANK_TAG_INFO,
      );
      bool isOk = response?.data["ok"];
      if (isOk) {
        result.isSuccess = isOk;
        result.data = NovelRankTagInfo.fromJson(response.data);
      }
    } catch (e) {
      print("$e");
      result.isSuccess = false;
    }
    return result;
  }

  /// 根据标签获取排行榜单列表信息
  Future<BaseResponse<NovelRankInfoOfTag>> getNovelRankInfoOfTag(
      String tagId) async {
    var response;
    BaseResponse<NovelRankInfoOfTag> result = BaseResponse();
    try {
      response = await client.getRequest(
        QUERY_NOVEL_RANK_INFO_Of_TAG.replaceAll("{rankingId}", tagId),
      );
      bool isOk = response?.data["ok"];
      if (isOk) {
        result.isSuccess = isOk;
        result.data = NovelRankInfoOfTag.fromJson(response.data);
      }
    } catch (e) {
      print("$e");
      result.isSuccess = false;
    }
    return result;
  }

  /// 根据Tag获取小说
  Future<BaseResponse<NovelInfoByTag>> getNovelInfoByTag(
      {required String tag,
      String? minorTag,
      String gender = 'male',
      String type = 'hot',
      int start = 0,
      int limit = 20}) async {
    var response;
    BaseResponse<NovelInfoByTag> result = BaseResponse();
    try {
      var queryParameters = <String, String>{
        'major': tag,
        'gender': gender,
        'type': type,
        'start': start.toString(),
        'limit': limit.toString()
      };

      if (minorTag != null && minorTag.isNotEmpty) {
        queryParameters['minor'] = minorTag;
      }

      response = await client.getRequest(QUERY_NOVEL_INFO_BY_TAG,
          queryParameters: queryParameters);
      bool isOk = response?.data["ok"];
      if (isOk) {
        result.isSuccess = isOk;
        result.data = NovelInfoByTag.fromJson(response.data);
      }
    } catch (e) {
      print("$e");
      result.isSuccess = false;
    }
    return result;
  }

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
      response = await client.getRequest(QUERY_BOOK_KEY_WORD, queryParameters: {
        "query": keyWord,
        "start": start.toString(),
        "limit": limit.toString()
      });

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
            "start": start.toString(),
            "limit": limit.toString()
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
            "start": start.toString(),
            "limit": limit.toString()
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
