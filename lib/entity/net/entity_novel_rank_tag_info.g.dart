// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_rank_tag_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelRankTagInfo _$NovelRankTagInfoFromJson(Map<String, dynamic> json) =>
    NovelRankTagInfo()
      ..male = (json['male'] as List<dynamic>?)
          ?.map((e) => NovelRankTag.fromJson(e as Map<String, dynamic>))
          .toList()
      ..female = (json['female'] as List<dynamic>?)
          ?.map((e) => NovelRankTag.fromJson(e as Map<String, dynamic>))
          .toList()
      ..picture = (json['picture'] as List<dynamic>?)
          ?.map((e) => NovelRankTag.fromJson(e as Map<String, dynamic>))
          .toList()
      ..epub = (json['epub'] as List<dynamic>?)
          ?.map((e) => NovelRankTag.fromJson(e as Map<String, dynamic>))
          .toList()
      ..ok = json['ok'] as bool?;

Map<String, dynamic> _$NovelRankTagInfoToJson(NovelRankTagInfo instance) =>
    <String, dynamic>{
      'male': instance.male?.map((e) => e.toJson()).toList(),
      'female': instance.female?.map((e) => e.toJson()).toList(),
      'picture': instance.picture?.map((e) => e.toJson()).toList(),
      'epub': instance.epub?.map((e) => e.toJson()).toList(),
      'ok': instance.ok,
    };

NovelRankTag _$NovelRankTagFromJson(Map<String, dynamic> json) => NovelRankTag()
  ..id = json['_id'] as String?
  ..title = json['title'] as String?
  ..cover = json['cover'] as String?
  ..collapse = json['collapse'] as bool?
  ..monthRank = json['monthRank'] as String?
  ..totalRank = json['totalRank'] as String?
  ..shortTitle = json['shortTitle'] as String?;

Map<String, dynamic> _$NovelRankTagToJson(NovelRankTag instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'cover': instance.cover,
      'collapse': instance.collapse,
      'monthRank': instance.monthRank,
      'totalRank': instance.totalRank,
      'shortTitle': instance.shortTitle,
    };
