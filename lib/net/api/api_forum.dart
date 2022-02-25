import 'package:flutter_novel/base/http/manager_net_request.dart';
import 'package:flutter_novel/entity/net/entity_forum_book_review_info.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:flutter_novel/net/entity/base/base_resp.dart';

class ForumApi {
  var client = NetRequestManager();

  /// 讨论区帖子列表
  Future<BaseResponse<List<ForumPostInfo>>> getDiscussionPostList(
      int startIndex, int limit) async {
    var response;
    BaseResponse<List<ForumPostInfo>> result = BaseResponse();

    List<ForumPostInfo> resultData = [];
    try {
      response = await client.getRequest(ApiConstant()
          .getDiscussionPostUrl(startIndex: startIndex, limit: limit));
      bool isOk = response?.data["ok"];

      if (isOk) {
        for (var data in response.data["posts"]) {
          resultData.add(ForumPostInfo.fromJson(data));
        }

        result.data = resultData;
      }

      result.isSuccess = isOk;
    } catch (e) {
      result.isSuccess = false;
      print("$e");
    }
    return result;
  }

  /// 书评区帖子列表
  Future<BaseResponse<List<ForumBookReviewInfo>>> getBookReviewList(
      int startIndex, int limit) async {
    var response;
    BaseResponse<List<ForumBookReviewInfo>> result = BaseResponse();

    List<ForumBookReviewInfo> resultData = [];
    try {
      response = await client.getRequest(
          ApiConstant().getBookReviewUrl(startIndex: startIndex, limit: limit));
      bool isOk = response?.data["ok"];

      if (isOk) {
        for (var data in response.data["reviews"]) {
          resultData.add(ForumBookReviewInfo.fromJson(data));
        }

        result.data = resultData;
      }

      result.isSuccess = isOk;
    } catch (e) {
      result.isSuccess = false;
      print("$e");
    }
    return result;
  }
}
