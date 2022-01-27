import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/entity/net/entity_novel_book_recommend.dart';
import 'package:flutter_novel/entity/net/entity_novel_detail_info.dart';
import 'package:flutter_novel/home/model/home_recommend_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NovelDetailViewModel extends BaseViewModel<ZSSQHomeRecommendModel> {
  String novelId = '';

  NovelDetailViewModel() : super(model: ZSSQHomeRecommendModel());

  NovelDetailInfo? detailInfo;
  var recommendBooks = <RecommendBooks>[].obs;

  @override
  void onReady() {
    super.onReady();
    getNovelDetailInfo(novelId);
  }

  void getNovelDetailInfo(String novelId) async {
    var info = await model?.getNovelDetailInfo(novelId: novelId);

    if (info != null) {
      detailInfo = info;
      refresh();
    }
  }

  void queryRecommendBook(String bookId) async {
    var info = await model?.getRecommendSimilarNovel(bookId);

    if (info != null) {
      recommendBooks.value = info;
    }
  }
}
