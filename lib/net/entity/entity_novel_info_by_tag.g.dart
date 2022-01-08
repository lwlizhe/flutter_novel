// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_info_by_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelInfoByTag _$NovelInfoByTagFromJson(Map<String, dynamic> json) =>
    NovelInfoByTag()
      ..total = json['total'] as int?
      ..books = (json['books'] as List<dynamic>?)
          ?.map((e) => Books.fromJson(e as Map<String, dynamic>))
          .toList()
      ..ok = json['ok'] as bool?;

Map<String, dynamic> _$NovelInfoByTagToJson(NovelInfoByTag instance) =>
    <String, dynamic>{
      'total': instance.total,
      'books': instance.books?.map((e) => e.toJson()).toList(),
      'ok': instance.ok,
    };

Books _$BooksFromJson(Map<String, dynamic> json) => Books()
  ..id = json['_id'] as String?
  ..title = json['title'] as String?
  ..author = json['author'] as String?
  ..shortIntro = json['shortIntro'] as String?
  ..majorCate = json['majorCate'] as String?
  ..minorCate = json['minorCate'] as String?
  ..cover = json['cover'] as String?
  ..site = json['site'] as String?
  ..sizetype = json['sizetype'] as int?
  ..superscript = json['superscript'] as String?
  ..contentType = json['contentType'] as String?
  ..allowMonthly = json['allowMonthly'] as bool?
  ..banned = json['banned'] as int?
  ..latelyFollower = json['latelyFollower'] as int?
  ..retentionRatio = (json['retentionRatio'] as num?)?.toDouble()
  ..lastChapter = json['lastChapter'] as String?
  ..tags = (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$BooksToJson(Books instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'shortIntro': instance.shortIntro,
      'majorCate': instance.majorCate,
      'minorCate': instance.minorCate,
      'cover': instance.cover,
      'site': instance.site,
      'sizetype': instance.sizetype,
      'superscript': instance.superscript,
      'contentType': instance.contentType,
      'allowMonthly': instance.allowMonthly,
      'banned': instance.banned,
      'latelyFollower': instance.latelyFollower,
      'retentionRatio': instance.retentionRatio,
      'lastChapter': instance.lastChapter,
      'tags': instance.tags,
    };
