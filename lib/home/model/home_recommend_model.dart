import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/entity/net/entity_novel_book_recommend.dart';
import 'package:flutter_novel/entity/net/entity_novel_detail_info.dart';
import 'package:flutter_novel/entity/net/entity_novel_info_by_tag.dart';
import 'package:flutter_novel/entity/net/entity_novel_rank_info_of_tag.dart';
import 'package:flutter_novel/entity/net/entity_novel_rank_tag_info.dart';
import 'package:flutter_novel/net/api/api_home.dart';

abstract class BaseHomeRecommendModel extends BaseModel {
  /// todo : 数据库或者缓存

  /// todo : 用于方便切换的api

  Future<List<NovelRankTag>?> getRankTagList();

  Future<NovelRankInfoOfTag?> getRankInfoOfTag(String tagId);

  Future<List<String>?> getRecommendTagList();

  Future<List<RecommendBooks>?> getRecommendSimilarNovel(String novelId);

  Future<NovelInfoByTag?> getRecommendNovelByTag(
      {required String tag,
      String? minorTag,
      String gender = 'male',
      String type = 'hot',
      int start = 0,
      int limit = 20});

  Future<NovelDetailInfo?> getNovelDetailInfo({required String novelId});
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
  Future<List<NovelRankTag>?> getRankTagList() async {
    List<NovelRankTag>? rankTagList =
        (await api.getNovelRankTagInfoList()).data?.male;

    return rankTagList;
  }

  @override
  Future<NovelRankInfoOfTag?> getRankInfoOfTag(String tagId) async {
    NovelRankInfoOfTag? rankTagList =
        (await api.getNovelRankInfoOfTag(tagId)).data;

    return rankTagList;
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

  @override
  Future<NovelDetailInfo?> getNovelDetailInfo({required String novelId}) async {
    NovelDetailInfo? detailInfo = (await api.getNovelDetailInfo(novelId)).data;

    return detailInfo;
  }

  @override
  Future<List<RecommendBooks>?> getRecommendSimilarNovel(String novelId) async {
    NovelBookRecommend? recommendInfo =
        (await api.getNovelBookRecommend(novelId)).data;

    return recommendInfo?.books;
  }
}
