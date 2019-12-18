// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_book_recommend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelBookRecommend _$NovelBookRecommendFromJson(Map<String, dynamic> json) {
  return NovelBookRecommend(
    (json['books'] as List)
        ?.map(
            (e) => e == null ? null : Books.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['ok'] as bool,
  );
}

Map<String, dynamic> _$NovelBookRecommendToJson(NovelBookRecommend instance) =>
    <String, dynamic>{
      'books': instance.books,
      'ok': instance.ok,
    };

Books _$BooksFromJson(Map<String, dynamic> json) {
  return Books(
    json['_id'] as String,
    json['title'] as String,
    json['author'] as String,
    json['site'] as String,
    json['cover'] as String,
    json['shortIntro'] as String,
    json['lastChapter'] as String,
    (json['retentionRatio'] as num)?.toDouble(),
    json['latelyFollower'] as int,
    json['majorCate'] as String,
    json['minorCate'] as String,
    json['allowMonthly'] as bool,
    json['isSerial'] as bool,
    json['contentType'] as String,
    json['allowFree'] as bool,
    (json['otherReadRatio'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$BooksToJson(Books instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'site': instance.site,
      'cover': instance.cover,
      'shortIntro': instance.shortIntro,
      'lastChapter': instance.lastChapter,
      'retentionRatio': instance.retentionRatio,
      'latelyFollower': instance.latelyFollower,
      'majorCate': instance.majorCate,
      'minorCate': instance.minorCate,
      'allowMonthly': instance.allowMonthly,
      'isSerial': instance.isSerial,
      'contentType': instance.contentType,
      'allowFree': instance.allowFree,
      'otherReadRatio': instance.otherReadRatio,
    };
