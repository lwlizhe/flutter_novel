import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/home/model/home_recommend_model.dart';
import 'package:flutter_novel/net/entity/entity_novel_info_by_tag.dart';
import 'package:flutter_novel/net/entity/entity_novel_rank_tag_info.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeRecommendViewModel extends BaseViewModel<BaseHomeRecommendModel> {
  HomeRecommendViewModel() : super(model: ZSSQHomeRecommendModel());

  var recommendNovels = <Books>[].obs;
  var rankTagList = <NovelRankTag>[].obs;

  @override
  void onReady() {
    super.onReady();
    getNovelByCategoriesTag();
    getNovelRankTagList();
  }

  void getNovelByCategoriesTag() async {
    var tags = (await model?.getRecommendTagList());
    var novels = (await model?.getRecommendNovelByTag(tag: tags?[0] ?? ''));
    isLoading = false;

    if (novels != null && novels.books != null) {
      recommendNovels.clear();
      recommendNovels.addAll(novels.books!);
    }
  }

  void getNovelRankTagList() async {
    var rankTag = await model?.getRankTagList();
    if (rankTag != null && rankTag.isNotEmpty) {
      rankTagList.clear();
      rankTagList.addAll(rankTag);
    }
  }
}
