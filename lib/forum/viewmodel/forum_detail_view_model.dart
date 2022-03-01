import 'package:flutter_novel/base/util/time_util.dart';
import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/forum/model/forum_detail_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

abstract class ForumDetailViewModel<M extends ForumDetailModel>
    extends BaseViewModel<M> {
  final String? targetId;

  ForumDetailViewModel(M model, this.targetId) : super(model: model);

  getDetailInfo();
}

class ForumPostDetailViewModel
    extends ForumDetailViewModel<ForumPostDetailModel> {
  ForumPostDetailViewModel(String? id) : super(ForumPostDetailModel(), id);

  var currentDetailInfo = Rx<ForumPostInfo?>(null);

  @override
  void onReady() {
    super.onReady();
    getDetailInfo();
  }

  @override
  getDetailInfo() async {
    var data = await model?.getPostDetail(targetId ?? '');
    data?.created = TimeUtil.formatDateTimeString(data.created ?? '');
    currentDetailInfo.value = data;
  }
}

class ForumBookReviewDetailViewModel
    extends ForumDetailViewModel<ForumBookReviewDetailModel> {
  ForumBookReviewDetailViewModel(String? id)
      : super(ForumBookReviewDetailModel(), id);

  @override
  getDetailInfo() {
    // TODO: implement getDetailInfo
    throw UnimplementedError();
  }
}
