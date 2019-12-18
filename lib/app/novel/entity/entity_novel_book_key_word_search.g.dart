// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_book_key_word_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelKeyWordSearch _$NovelKeyWordSearchFromJson(Map<String, dynamic> json) {
  return NovelKeyWordSearch(
    (json['books'] as List)
        ?.map(
            (e) => e == null ? null : Books.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['total'] as int,
    json['ok'] as bool,
  );
}

Map<String, dynamic> _$NovelKeyWordSearchToJson(NovelKeyWordSearch instance) =>
    <String, dynamic>{
      'books': instance.books,
      'total': instance.total,
      'ok': instance.ok,
    };

Books _$BooksFromJson(Map<String, dynamic> json) {
  return Books(
    json['_id'] as String,
    json['hasCp'] as bool,
    json['title'] as String,
    json['aliases'] as String,
    json['cat'] as String,
    json['author'] as String,
    json['site'] as String,
    json['cover'] as String,
    json['shortIntro'] as String,
    json['lastChapter'] as String,
    (json['retentionRatio'] as num)?.toDouble(),
    json['banned'] as int,
    json['allowMonthly'] as bool,
    json['latelyFollower'] as int,
    json['wordCount'] as int,
    json['contentType'] as String,
    json['superscript'] as String,
    json['sizetype'] as int,
    json['highlight'] == null
        ? null
        : Highlight.fromJson(json['highlight'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BooksToJson(Books instance) => <String, dynamic>{
      '_id': instance.id,
      'hasCp': instance.hasCp,
      'title': instance.title,
      'aliases': instance.aliases,
      'cat': instance.cat,
      'author': instance.author,
      'site': instance.site,
      'cover': instance.cover,
      'shortIntro': instance.shortIntro,
      'lastChapter': instance.lastChapter,
      'retentionRatio': instance.retentionRatio,
      'banned': instance.banned,
      'allowMonthly': instance.allowMonthly,
      'latelyFollower': instance.latelyFollower,
      'wordCount': instance.wordCount,
      'contentType': instance.contentType,
      'superscript': instance.superscript,
      'sizetype': instance.sizetype,
      'highlight': instance.highlight,
    };

Highlight _$HighlightFromJson(Map<String, dynamic> json) {
  return Highlight(
    (json['title'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$HighlightToJson(Highlight instance) => <String, dynamic>{
      'title': instance.title,
    };
