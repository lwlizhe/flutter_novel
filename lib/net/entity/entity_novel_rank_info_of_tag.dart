import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_rank_info_of_tag.g.dart';

@JsonSerializable(explicitToJson: true)
class NovelRankInfoOfTag {
  @JsonKey(name: 'ranking')
  Ranking? ranking;

  @JsonKey(name: 'ok')
  bool? ok;

  NovelRankInfoOfTag();

  static NovelRankInfoOfTag fromJson(Map<String, dynamic> srcJson) =>
      _$NovelRankInfoOfTagFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelRankInfoOfTagToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Ranking {
  @JsonKey(name: 'updated')
  String? updated;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'tag')
  String? tag;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'icon')
  String? icon;

  @JsonKey(name: '__v')
  int? v;

  @JsonKey(name: 'monthRank')
  String? monthRank;

  @JsonKey(name: 'totalRank')
  String? totalRank;

  @JsonKey(name: 'shortTitle')
  String? shortTitle;

  @JsonKey(name: 'created')
  String? created;

  @JsonKey(name: 'biTag')
  String? biTag;

  @JsonKey(name: 'isSub')
  bool? isSub;

  @JsonKey(name: 'collapse')
  bool? collapse;

  @JsonKey(name: 'new')
  bool? isNew;

  @JsonKey(name: 'gender')
  String? gender;

  @JsonKey(name: 'priority')
  int? priority;

  @JsonKey(name: 'books')
  List<RankBooks>? books;

  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'total')
  int? total;

  Ranking();

  static Ranking fromJson(Map<String, dynamic> srcJson) =>
      _$RankingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RankingToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RankBooks {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'site')
  String? site;

  @JsonKey(name: 'author')
  String? author;

  @JsonKey(name: 'majorCate')
  String? majorCate;

  @JsonKey(name: 'minorCate')
  String? minorCate;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'shortIntro')
  String? shortIntro;

  @JsonKey(name: 'allowMonthly')
  bool? allowMonthly;

  @JsonKey(name: 'banned')
  int? banned;

  @JsonKey(name: 'latelyFollower')
  int? latelyFollower;

  @JsonKey(name: 'retentionRatio')
  String? retentionRatio;

  RankBooks();

  static RankBooks fromJson(Map<String, dynamic> srcJson) =>
      _$BooksFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BooksToJson(this);
}
