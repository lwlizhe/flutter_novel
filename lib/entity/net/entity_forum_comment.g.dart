// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_forum_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumCommentInfo _$ForumCommentInfoFromJson(Map<String, dynamic> json) =>
    ForumCommentInfo()
      ..id = json['_id'] as String?
      ..content = json['content'] as String?
      ..author = json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>)
      ..floor = json['floor'] as int?
      ..likeCount = json['likeCount'] as int?
      ..created = json['created'] as String?;

Map<String, dynamic> _$ForumCommentInfoToJson(ForumCommentInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'author': instance.author?.toJson(),
      'floor': instance.floor,
      'likeCount': instance.likeCount,
      'created': instance.created,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author()
  ..id = json['_id'] as String?
  ..avatar = json['avatar'] as String?
  ..nickname = json['nickname'] as String?
  ..activityAvatar = json['activityAvatar'] as String?
  ..type = json['type'] as String?
  ..lv = json['lv'] as int?
  ..gender = json['gender'] as String?;

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'activityAvatar': instance.activityAvatar,
      'type': instance.type,
      'lv': instance.lv,
      'gender': instance.gender,
    };
