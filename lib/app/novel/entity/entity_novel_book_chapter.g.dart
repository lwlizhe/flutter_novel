// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_book_chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelBookChapter _$NovelBookChapterFromJson(Map<String, dynamic> json) {
  return NovelBookChapter(
    json['_id'] as String,
    json['name'] as String,
    json['source'] as String,
    json['book'] as String,
    json['link'] as String,
    (json['chapters'] as List)
        ?.map((e) =>
            e == null ? null : Chapters.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['updated'] as String,
    json['host'] as String,
  );
}

Map<String, dynamic> _$NovelBookChapterToJson(NovelBookChapter instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'source': instance.source,
      'book': instance.book,
      'link': instance.link,
      'chapters': instance.chapters,
      'updated': instance.updated,
      'host': instance.host,
    };

Chapters _$ChaptersFromJson(Map<String, dynamic> json) {
  return Chapters(
    json['_id'] as String,
    json['title'] as String,
    json['link'] as String,
    json['id'] as String,
    json['time'] as int,
    json['chapterCover'] as String,
    json['totalpage'] as int,
    json['partsize'] as int,
    json['order'] as int,
    json['currency'] as int,
    json['unreadble'] as bool,
    json['isVip'] as bool,
  );
}

Map<String, dynamic> _$ChaptersToJson(Chapters instance) => <String, dynamic>{
      '_id': instance.bookId,
      'title': instance.title,
      'link': instance.link,
      'id': instance.id,
      'time': instance.time,
      'chapterCover': instance.chapterCover,
      'totalpage': instance.totalpage,
      'partsize': instance.partsize,
      'order': instance.order,
      'currency': instance.currency,
      'unreadble': instance.unreadble,
      'isVip': instance.isVip,
    };
