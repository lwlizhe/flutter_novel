import 'package:flutter_novel/base/util/time_util.dart';
import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/entity/net/entity_forum_comment.dart';
import 'package:flutter_novel/forum/model/forum_comment_model.dart';
import 'package:flutter_novel/forum/view/forum_post_detail_page.dart';
import 'package:get/get.dart';

class ForumCommentViewModel extends BaseViewModel<ForumCommentModel> {
  final String targetId;
  final ForumDetailType detailType;

  ForumCommentViewModel(this.targetId, this.detailType)
      : super(model: ForumCommentModel());

  var hotComment = Rx<ForumCommentInfo?>(null);
  var latestComments = <ForumCommentInfo>[].obs;

  @override
  void onReady() {
    super.onReady();
    getHotComment();
    switch (detailType) {
      case ForumDetailType.bookReview:
        getBookReviewLatestComments();
        break;
      case ForumDetailType.post:
      default:
        getPostLatestComments();
        break;
    }
  }

  void getPostLatestComments() async {
    var data = await model?.getPostLatestComments(id: targetId);
    if (data != null && data.isNotEmpty) {
      for (var item in data) {
        item.created = TimeUtil.formatDateTimeString(item.created ?? '');
      }
      latestComments.value = data;
    }
  }

  void getBookReviewLatestComments() async {
    var data = await model?.getBookReviewLatestComments(id: targetId);
    if (data != null && data.isNotEmpty) {
      for (var item in data) {
        item.created = TimeUtil.formatDateTimeString(item.created ?? '');
      }
      latestComments.value = data;
    }
  }

  void getHotComment() async {
    var data = await model?.getHotComments(id: targetId);
    if (data != null) {
      data.created = TimeUtil.formatDateTimeString(data.created ?? '');
      hotComment.value = data;
    }
  }
}
