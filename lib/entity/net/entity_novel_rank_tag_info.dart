import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_rank_tag_info.g.dart';

@JsonSerializable(explicitToJson: true)
class NovelRankTagInfo {
  @JsonKey(name: 'male')
  List<NovelRankTag>? male;

  @JsonKey(name: 'female')
  List<NovelRankTag>? female;

  @JsonKey(name: 'picture')
  List<NovelRankTag>? picture;

  @JsonKey(name: 'epub')
  List<NovelRankTag>? epub;

  @JsonKey(name: 'ok')
  bool? ok;

  NovelRankTagInfo();

  static NovelRankTagInfo fromJson(Map<String, dynamic> srcJson) =>
      _$NovelRankTagInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelRankTagInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NovelRankTag {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'collapse')
  bool? collapse;

  @JsonKey(name: 'monthRank')
  String? monthRank;

  @JsonKey(name: 'totalRank')
  String? totalRank;

  @JsonKey(name: 'shortTitle')
  String? shortTitle;

  NovelRankTag();

  static NovelRankTag fromJson(Map<String, dynamic> srcJson) =>
      _$NovelRankTagFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelRankTagToJson(this);
}
