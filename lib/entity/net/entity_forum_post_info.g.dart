// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_forum_post_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPostInfo _$ForumPostInfoFromJson(Map<String, dynamic> json) =>
    ForumPostInfo()
      ..id = json['_id'] as String?
      ..author = json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>)
      ..type = json['type'] as String?
      ..likeCount = json['likeCount'] as int?
      ..block = json['block'] as String?
      ..haveImage = json['haveImage'] as bool?
      ..state = json['state'] as String?
      ..updated = json['updated'] as String?
      ..created = json['created'] as String?
      ..commentCount = json['commentCount'] as int?
      ..voteCount = json['voteCount'] as int?
      ..title = json['title'] as String?;

Map<String, dynamic> _$ForumPostInfoToJson(ForumPostInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'author': instance.author?.toJson(),
      'type': instance.type,
      'likeCount': instance.likeCount,
      'block': instance.block,
      'haveImage': instance.haveImage,
      'state': instance.state,
      'updated': instance.updated,
      'created': instance.created,
      'commentCount': instance.commentCount,
      'voteCount': instance.voteCount,
      'title': instance.title,
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
