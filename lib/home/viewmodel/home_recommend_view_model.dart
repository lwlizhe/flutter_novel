import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:test_project/base/viewmodel/base_view_model.dart';
import 'package:test_project/home/model/home_recommend_model.dart';
import 'package:test_project/net/entity/entity_novel_info_by_tag.dart';

class HomeRecommendViewModel extends BaseViewModel<BaseHomeRecommendModel> {
  HomeRecommendViewModel() : super(model: ZSSQHomeRecommendModel());

  var recommendNovels = <Books>[].obs;

  void getNovelByCategoriesTag() async {
    var tags = (await model?.getRecommendTagList());
    var novels = (await model?.getRecommendNovelByTag(tag: tags?[0] ?? ''));

    if (novels != null && novels.books != null) {
      recommendNovels.clear();
      recommendNovels.addAll(novels.books!);
    }
  }
}
