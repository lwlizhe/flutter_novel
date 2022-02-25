import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/entity/net/entity_forum_book_review_info.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/home/model/home_forum_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeForumViewModel extends BaseViewModel<HomeForumModel> {
  HomeForumViewModel() : super(model: HomeForumModel());

  var discussionPostList = <ForumPostInfo>[].obs;
  var bookReviewList = <ForumBookReviewInfo>[].obs;

  @override
  void onReady() {
    super.onReady();
    getDiscussionPostList(0);
    getBookReviewList(0);
  }

  void getDiscussionPostList(int page) async {
    var list = await model?.getDiscussionPost(20 * page, 20);
    if (list != null) {
      discussionPostList.addAll(list);
    }
  }

  void getBookReviewList(int page) async {
    var list = await model?.getBookReview(20 * page, 20);
    if (list != null) {
      bookReviewList.addAll(list);
    }
  }
}
