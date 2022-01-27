import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_info_by_tag.g.dart';

@JsonSerializable(explicitToJson: true)
class NovelInfoByTag {
  @JsonKey(name: 'total')
  int? total;

  @JsonKey(name: 'books')
  List<Books>? books;

  @JsonKey(name: 'ok')
  bool? ok;

  NovelInfoByTag();

  static NovelInfoByTag fromJson(Map<String, dynamic> srcJson) =>
      _$NovelInfoByTagFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelInfoByTagToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Books {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'author')
  String? author;

  @JsonKey(name: 'shortIntro')
  String? shortIntro;

  @JsonKey(name: 'majorCate')
  String? majorCate;

  @JsonKey(name: 'minorCate')
  String? minorCate;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'site')
  String? site;

  @JsonKey(name: 'sizetype')
  int? sizetype;

  @JsonKey(name: 'superscript')
  String? superscript;

  @JsonKey(name: 'contentType')
  String? contentType;

  @JsonKey(name: 'allowMonthly')
  bool? allowMonthly;

  @JsonKey(name: 'banned')
  int? banned;

  @JsonKey(name: 'latelyFollower')
  int? latelyFollower;

  @JsonKey(name: 'retentionRatio')
  double? retentionRatio;

  @JsonKey(name: 'lastChapter')
  String? lastChapter;

  @JsonKey(name: 'tags')
  List<String>? tags;

  Books();

  static Books fromJson(Map<String, dynamic> srcJson) =>
      _$BooksFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BooksToJson(this);
}
