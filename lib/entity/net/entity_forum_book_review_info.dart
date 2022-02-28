import 'package:json_annotation/json_annotation.dart';

part 'entity_forum_book_review_info.g.dart';

@JsonSerializable(explicitToJson: true)
class ForumBookReviewInfo {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'book')
  Book? book;

  @JsonKey(name: 'helpful')
  Helpful? helpful;

  @JsonKey(name: 'likeCount')
  int? likeCount;

  @JsonKey(name: 'haveImage')
  bool? haveImage;

  @JsonKey(name: 'state')
  String? state;

  @JsonKey(name: 'updated')
  String? updated;

  @JsonKey(name: 'created')
  String? created;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'content')
  String? content;

  ForumBookReviewInfo();

  static ForumBookReviewInfo fromJson(Map<String, dynamic> srcJson) =>
      _$ForumBookReviewInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ForumBookReviewInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Book {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'site')
  String? site;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'allowFree')
  bool? allowFree;

  @JsonKey(name: 'type')
  String? type;

  Book();

  static Book fromJson(Map<String, dynamic> srcJson) => _$BookFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Helpful {
  @JsonKey(name: 'total')
  int? total;

  @JsonKey(name: 'no')
  int? no;

  @JsonKey(name: 'yes')
  int? yes;

  Helpful();

  static Helpful fromJson(Map<String, dynamic> srcJson) =>
      _$HelpfulFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HelpfulToJson(this);
}
