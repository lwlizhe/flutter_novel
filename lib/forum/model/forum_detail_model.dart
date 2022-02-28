import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/net/api/api_forum.dart';

abstract class ForumDetailModel extends BaseModel {
  final ForumApi forumApi = ForumApi();
}

class ForumPostDetailModel extends ForumDetailModel {
  @override
  void init() {}

  Future<ForumPostInfo?> getPostDetail(String id) async {
    var result = await forumApi.getDiscussionPostDetail(id);
    if (result.isSuccess) {
      return result.data;
    } else {
      return null;
    }
  }
}

class ForumBookReviewDetailModel extends ForumDetailModel {
  @override
  void init() {}
}
