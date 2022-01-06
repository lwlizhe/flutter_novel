import 'package:test_project/base/model/base_model.dart';

abstract class BaseHomeRecommendModel extends BaseModel {
  /// todo : 数据库或者缓存

  /// todo : 用于方便切换的api

}

class ZSSQHomeRecommendModel extends BaseHomeRecommendModel {
  @override
  void init() {}
}
