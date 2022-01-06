import 'package:test_project/base/viewmodel/base_view_model.dart';
import 'package:test_project/home/model/home_recommend_model.dart';

class HomeRecommendViewModel extends BaseViewModel<BaseHomeRecommendModel> {
  HomeRecommendViewModel() : super(model: ZSSQHomeRecommendModel());
}
