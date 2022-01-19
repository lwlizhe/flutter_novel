// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_rank_info_of_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelRankInfoOfTag _$NovelRankInfoOfTagFromJson(Map<String, dynamic> json) =>
    NovelRankInfoOfTag()
      ..ranking = json['ranking'] == null
          ? null
          : Ranking.fromJson(json['ranking'] as Map<String, dynamic>)
      ..ok = json['ok'] as bool?;

Map<String, dynamic> _$NovelRankInfoOfTagToJson(NovelRankInfoOfTag instance) =>
    <String, dynamic>{
      'ranking': instance.ranking?.toJson(),
      'ok': instance.ok,
    };

Ranking _$RankingFromJson(Map<String, dynamic> json) => Ranking()
  ..updated = json['updated'] as String?
  ..title = json['title'] as String?
  ..tag = json['tag'] as String?
  ..cover = json['cover'] as String?
  ..icon = json['icon'] as String?
  ..v = json['__v'] as int?
  ..monthRank = json['monthRank'] as String?
  ..totalRank = json['totalRank'] as String?
  ..shortTitle = json['shortTitle'] as String?
  ..created = json['created'] as String?
  ..biTag = json['biTag'] as String?
  ..isSub = json['isSub'] as bool?
  ..collapse = json['collapse'] as bool?
  ..isNew = json['new'] as bool?
  ..gender = json['gender'] as String?
  ..priority = json['priority'] as int?
  ..books = (json['books'] as List<dynamic>?)
      ?.map((e) => RankBooks.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as String?
  ..total = json['total'] as int?;

Map<String, dynamic> _$RankingToJson(Ranking instance) => <String, dynamic>{
      'updated': instance.updated,
      'title': instance.title,
      'tag': instance.tag,
      'cover': instance.cover,
      'icon': instance.icon,
      '__v': instance.v,
      'monthRank': instance.monthRank,
      'totalRank': instance.totalRank,
      'shortTitle': instance.shortTitle,
      'created': instance.created,
      'biTag': instance.biTag,
      'isSub': instance.isSub,
      'collapse': instance.collapse,
      'new': instance.isNew,
      'gender': instance.gender,
      'priority': instance.priority,
      'books': instance.books?.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'total': instance.total,
    };

RankBooks _$BooksFromJson(Map<String, dynamic> json) => RankBooks()
  ..id = json['_id'] as String?
  ..site = json['site'] as String?
  ..author = json['author'] as String?
  ..majorCate = json['majorCate'] as String?
  ..minorCate = json['minorCate'] as String?
  ..title = json['title'] as String?
  ..cover = json['cover'] as String?
  ..shortIntro = json['shortIntro'] as String?
  ..allowMonthly = json['allowMonthly'] as bool?
  ..banned = json['banned'] as int?
  ..latelyFollower = json['latelyFollower'] as int?
  ..retentionRatio = json['retentionRatio'] as String?;

Map<String, dynamic> _$BooksToJson(RankBooks instance) => <String, dynamic>{
      '_id': instance.id,
      'site': instance.site,
      'author': instance.author,
      'majorCate': instance.majorCate,
      'minorCate': instance.minorCate,
      'title': instance.title,
      'cover': instance.cover,
      'shortIntro': instance.shortIntro,
      'allowMonthly': instance.allowMonthly,
      'banned': instance.banned,
      'latelyFollower': instance.latelyFollower,
      'retentionRatio': instance.retentionRatio,
    };
