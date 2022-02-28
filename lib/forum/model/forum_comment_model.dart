import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/entity/net/entity_forum_comment.dart';
import 'package:flutter_novel/net/api/api_forum.dart';

class ForumCommentModel extends BaseModel {
  ForumApi api = ForumApi();

  @override
  void init() {}

  Future<List<ForumCommentInfo>?> getPostLatestComments(
      {required String id, int startIndex = 0}) async {
    var result = await api.getDiscussionPostComment(id, startIndex: startIndex);
    if (result.isSuccess) {
      return result.data;
    } else {
      return null;
    }
  }

  Future<List<ForumCommentInfo>?> getBookReviewLatestComments(
      {required String id, int startIndex = 0}) async {
    var result = await api.getBookReviewComment(id, startIndex: startIndex);
    if (result.isSuccess) {
      return result.data;
    } else {
      return null;
    }
  }

  Future<ForumCommentInfo?> getHotComments(
      {required String id, int startIndex = 0}) async {
    var result = await api.getHotComment(id);
    if (result.isSuccess) {
      return result.data;
    } else {
      return null;
    }
  }
}
