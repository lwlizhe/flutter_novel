import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/net/api/api_home.dart';
import 'package:flutter_novel/net/entity/entity_novel_info_by_tag.dart';

abstract class BaseHomeRecommendModel extends BaseModel {
  /// todo : 数据库或者缓存

  /// todo : 用于方便切换的api

  Future<List<String>?> getRecommendTagList();

  Future<NovelInfoByTag?> getRecommendNovelByTag(
      {required String tag,
      String? minorTag,
      String gender = 'male',
      String type = 'hot',
      int start = 0,
      int limit = 20});
}

class ZSSQHomeRecommendModel extends BaseHomeRecommendModel {
  late HomeApi api;

  @override
  void init() {
    api = HomeApi();
  }

  @override
  Future<List<String>?> getRecommendTagList() async {
    var categories = (await api.getCategories()).data;

    return categories?.male.map((e) => e.name).toList();
  }

  @override
  Future<NovelInfoByTag?> getRecommendNovelByTag(
      {required String tag,
      String? minorTag,
      String gender = 'male',
      String type = 'hot',
      int start = 0,
      int limit = 20}) async {
    var info = (await api.getNovelInfoByTag(
            tag: tag,
            minorTag: minorTag,
            type: type,
            gender: gender,
            start: start,
            limit: limit))
        .data;

    return info;
  }
}
