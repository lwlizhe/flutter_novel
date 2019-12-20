// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_book_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelBookSource _$NovelBookSourceFromJson(Map<String, dynamic> json) {
  return NovelBookSource(
    json['_id'] as String,
    json['isCharge'] as bool,
    json['name'] as String,
    json['lastChapter'] as String,
    json['updated'] as String,
    json['source'] as String,
    json['link'] as String,
    json['starting'] as bool,
    json['chaptersCount'] as int,
    json['host'] as String,
  );
}

Map<String, dynamic> _$NovelBookSourceToJson(NovelBookSource instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'isCharge': instance.isCharge,
      'name': instance.name,
      'lastChapter': instance.lastChapter,
      'updated': instance.updated,
      'source': instance.source,
      'link': instance.link,
      'starting': instance.starting,
      'chaptersCount': instance.chaptersCount,
      'host': instance.host,
    };
