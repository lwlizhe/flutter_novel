import 'package:flutter_novel/base/http/manager_net_request.dart';
import 'package:flutter_novel/entity/net/entity_forum_book_review_info.dart';
import 'package:flutter_novel/entity/net/entity_forum_comment.dart';
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
          .getDiscussionPostListUrl(startIndex: startIndex, limit: limit));
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

  /// 讨论区帖子详情
  Future<BaseResponse<ForumPostInfo>> getDiscussionPostDetail(String id) async {
    var response;
    BaseResponse<ForumPostInfo> result = BaseResponse();

    try {
      response = await client
          .getRequest(ApiConstant().getDiscussionPostDetailUrl(postId: id));
      bool isOk = response?.data["ok"];

      if (isOk) {
        result.data = ForumPostInfo.fromJson(response.data["post"]);
      }

      result.isSuccess = isOk;
    } catch (e) {
      result.isSuccess = false;
      print("$e");
    }
    return result;
  }

  /// 讨论区评论
  Future<BaseResponse<List<ForumCommentInfo>>> getDiscussionPostComment(
      String id,
      {int startIndex = 0,
      int limit = 20}) async {
    var response;
    BaseResponse<List<ForumCommentInfo>> result = BaseResponse();

    List<ForumCommentInfo> resultData = [];

    try {
      response = await client.getRequest(ApiConstant()
          .getDiscussionPostCommentUrl(
              postId: id, start: startIndex, limit: limit));
      bool isOk = response?.data["ok"];

      if (isOk) {
        for (var data in response?.data['comments']) {
          resultData.add(ForumCommentInfo.fromJson(data));
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
      response = await client.getRequest(ApiConstant()
          .getBookReviewListUrl(startIndex: startIndex, limit: limit));
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

  /// 书评详情
  Future<BaseResponse<ForumBookReviewInfo>> getBookReviewDetail(
      String id) async {
    var response;
    BaseResponse<ForumBookReviewInfo> result = BaseResponse();

    try {
      response = await client
          .getRequest(ApiConstant().getBookReviewDetailUrl(bookReviewId: id));
      bool isOk = response?.data["ok"];

      if (isOk) {
        result.data = ForumBookReviewInfo.fromJson(response.data["review"]);
      }

      result.isSuccess = isOk;
    } catch (e) {
      result.isSuccess = false;
      print("$e");
    }
    return result;
  }

  /// 书评区评论
  Future<BaseResponse<List<ForumCommentInfo>>> getBookReviewComment(String id,
      {int startIndex = 0, int limit = 20}) async {
    var response;
    BaseResponse<List<ForumCommentInfo>> result = BaseResponse();

    List<ForumCommentInfo> resultData = [];

    try {
      response = await client.getRequest(ApiConstant().getBookReviewCommentUrl(
          bookReviewId: id, start: startIndex, limit: limit));
      bool isOk = response?.data["ok"];

      if (isOk) {
        for (var data in response?.data['comments']) {
          resultData.add(ForumCommentInfo.fromJson(data));
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

  /// 书评区评论
  Future<BaseResponse<ForumCommentInfo>> getHotComment(String id) async {
    var response;
    BaseResponse<ForumCommentInfo> result = BaseResponse();

    try {
      response =
          await client.getRequest(ApiConstant().getHotComment(targetId: id));
      bool isOk = response?.data["ok"];

      if (isOk) {
        result.data = ForumCommentInfo.fromJson(response?.data['comment']);
      }

      result.isSuccess = isOk;
    } catch (e) {
      result.isSuccess = false;
      print("$e");
    }
    return result;
  }
}
