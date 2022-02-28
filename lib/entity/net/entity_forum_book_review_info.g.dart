// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_forum_book_review_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumBookReviewInfo _$ForumBookReviewInfoFromJson(Map<String, dynamic> json) =>
    ForumBookReviewInfo()
      ..id = json['_id'] as String?
      ..book = json['book'] == null
          ? null
          : Book.fromJson(json['book'] as Map<String, dynamic>)
      ..helpful = json['helpful'] == null
          ? null
          : Helpful.fromJson(json['helpful'] as Map<String, dynamic>)
      ..likeCount = json['likeCount'] as int?
      ..haveImage = json['haveImage'] as bool?
      ..state = json['state'] as String?
      ..updated = json['updated'] as String?
      ..created = json['created'] as String?
      ..title = json['title'] as String?
      ..content = json['content'] as String?;

Map<String, dynamic> _$ForumBookReviewInfoToJson(
        ForumBookReviewInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'book': instance.book?.toJson(),
      'helpful': instance.helpful?.toJson(),
      'likeCount': instance.likeCount,
      'haveImage': instance.haveImage,
      'state': instance.state,
      'updated': instance.updated,
      'created': instance.created,
      'title': instance.title,
      'content': instance.content,
    };

Book _$BookFromJson(Map<String, dynamic> json) => Book()
  ..id = json['_id'] as String?
  ..title = json['title'] as String?
  ..site = json['site'] as String?
  ..cover = json['cover'] as String?
  ..allowFree = json['allowFree'] as bool?
  ..type = json['type'] as String?;

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'site': instance.site,
      'cover': instance.cover,
      'allowFree': instance.allowFree,
      'type': instance.type,
    };

Helpful _$HelpfulFromJson(Map<String, dynamic> json) => Helpful()
  ..total = json['total'] as int?
  ..no = json['no'] as int?
  ..yes = json['yes'] as int?;

Map<String, dynamic> _$HelpfulToJson(Helpful instance) => <String, dynamic>{
      'total': instance.total,
      'no': instance.no,
      'yes': instance.yes,
    };
