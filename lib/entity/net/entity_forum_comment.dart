import 'package:json_annotation/json_annotation.dart';

part 'entity_forum_comment.g.dart';

@JsonSerializable(explicitToJson: true)
class ForumCommentInfo {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'content')
  String? content;

  @JsonKey(name: 'author')
  Author? author;

  @JsonKey(name: 'floor')
  int? floor;

  @JsonKey(name: 'likeCount')
  int? likeCount;

  @JsonKey(name: 'created')
  String? created;

  ForumCommentInfo();

  static ForumCommentInfo fromJson(Map<String, dynamic> srcJson) =>
      _$ForumCommentInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ForumCommentInfoToJson(this);
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
