// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_short_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelShortComment _$NovelShortCommentFromJson(Map<String, dynamic> json) {
  return NovelShortComment(
    json['today'] as int,
    (json['docs'] as List)
        ?.map(
            (e) => e == null ? null : Docs.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['ok'] as bool,
  );
}

Map<String, dynamic> _$NovelShortCommentToJson(NovelShortComment instance) =>
    <String, dynamic>{
      'today': instance.today,
      'docs': instance.docs,
      'ok': instance.ok,
    };

Docs _$DocsFromJson(Map<String, dynamic> json) {
  return Docs(
    json['_id'] as String,
    json['rating'] as int,
    json['type'] as String,
    json['author'] == null
        ? null
        : Author.fromJson(json['author'] as Map<String, dynamic>),
    json['book'] == null
        ? null
        : Book.fromJson(json['book'] as Map<String, dynamic>),
    json['likeCount'] as int,
    (json['priority'] as num)?.toDouble(),
    json['block'] as String,
    json['state'] as String,
    json['updated'] as String,
    json['created'] as String,
    json['content'] as String,
  );
}

Map<String, dynamic> _$DocsToJson(Docs instance) => <String, dynamic>{
      '_id': instance.id,
      'rating': instance.rating,
      'type': instance.type,
      'author': instance.author,
      'book': instance.book,
      'likeCount': instance.likeCount,
      'priority': instance.priority,
      'block': instance.block,
      'state': instance.state,
      'updated': instance.updated,
      'created': instance.created,
      'content': instance.content,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return Author(
    json['_id'] as String,
    json['avatar'] as String,
    json['nickname'] as String,
    json['activityAvatar'] as String,
    json['type'] as String,
    json['lv'] as int,
    json['gender'] as String,
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'activityAvatar': instance.activityAvatar,
      'type': instance.type,
      'lv': instance.lv,
      'gender': instance.gender,
    };

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
    json['_id'] as String,
    json['title'] as String,
    json['cover'] as String,
  );
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'cover': instance.cover,
    };
