// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_book_shelf_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelBookShelfInfo _$NovelBookShelfInfoFromJson(Map<String, dynamic> json) =>
    NovelBookShelfInfo()
      ..bookShelfInfoList = (json['bookShelfInfoList'] as List<dynamic>)
          .map(
              (e) => NovelBookShelfBookInfo.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$NovelBookShelfInfoToJson(NovelBookShelfInfo instance) =>
    <String, dynamic>{
      'bookShelfInfoList':
          instance.bookShelfInfoList.map((e) => e.toJson()).toList(),
    };

NovelBookShelfBookInfo _$NovelBookShelfBookInfoFromJson(
        Map<String, dynamic> json) =>
    NovelBookShelfBookInfo()
      ..cover = json['cover'] as String
      ..title = json['title'] as String
      ..id = json['id'] as String
      ..lastChapterId = json['lastChapterId'] as String
      ..lastChapterIndex = json['lastChapterIndex'] as int
      ..lastPageIndex = json['lastPageIndex'] as int
      ..readProgress = json['readProgress'] as int
      ..readCostTime = json['readCostTime'] as int
      ..lastReadTime = json['lastReadTime'] as int;

Map<String, dynamic> _$NovelBookShelfBookInfoToJson(
        NovelBookShelfBookInfo instance) =>
    <String, dynamic>{
      'cover': instance.cover,
      'title': instance.title,
      'id': instance.id,
      'lastChapterId': instance.lastChapterId,
      'lastChapterIndex': instance.lastChapterIndex,
      'lastPageIndex': instance.lastPageIndex,
      'readProgress': instance.readProgress,
      'readCostTime': instance.readCostTime,
      'lastReadTime': instance.lastReadTime,
    };
