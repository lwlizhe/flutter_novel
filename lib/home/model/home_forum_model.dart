import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/entity/net/entity_forum_book_review_info.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/net/api/api_forum.dart';

class HomeForumModel extends BaseModel {
  late ForumApi _api;

  @override
  void init() {
    _api = ForumApi();
  }

  Future<List<ForumPostInfo>?> getDiscussionPost(
      int startIndex, int limit) async {
    var result = await _api.getDiscussionPostList(startIndex, limit);

    if (result.isSuccess) {
      return result.data;
    } else {
      return null;
    }
  }

  Future<List<ForumBookReviewInfo>?> getBookReview(
      int startIndex, int limit) async {
    var result = await _api.getBookReviewList(startIndex, limit);

    if (result.isSuccess) {
      return result.data;
    } else {
      return null;
    }
  }
}
