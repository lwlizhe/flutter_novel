import 'package:json_annotation/json_annotation.dart';

part 'entity_forum_post_info.g.dart';

@JsonSerializable(explicitToJson: true)
class ForumPostInfo {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'author')
  Author? author;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'likeCount')
  int? likeCount;

  @JsonKey(name: 'block')
  String? block;

  @JsonKey(name: 'haveImage')
  bool? haveImage;

  @JsonKey(name: 'state')
  String? state;

  @JsonKey(name: 'updated')
  String? updated;

  @JsonKey(name: 'created')
  String? created;

  @JsonKey(name: 'commentCount')
  int? commentCount;

  @JsonKey(name: 'voteCount')
  int? voteCount;

  @JsonKey(name: 'title')
  String? title;

  ForumPostInfo();

  static ForumPostInfo fromJson(Map<String, dynamic> srcJson) =>
      _$ForumPostInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ForumPostInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Author {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'avatar')
  String? avatar;

  @JsonKey(name: 'nickname')
  String? nickname;

  @JsonKey(name: 'activityAvatar')
  String? activityAvatar;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'lv')
  int? lv;

  @JsonKey(name: 'gender')
  String? gender;

  Author();

  static Author fromJson(Map<String, dynamic> srcJson) =>
      _$AuthorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
