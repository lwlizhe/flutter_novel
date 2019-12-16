// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelDetailInfo _$NovelDetailInfoFromJson(Map<String, dynamic> json) {
  return NovelDetailInfo(
    json['_id'] as String,
    json['title'] as String,
    json['author'] as String,
    json['majorCate'] as String,
    json['cover'] as String,
    json['longIntro'] as String,
    json['starRatingCount'] as int,
    (json['starRatings'] as List)
        ?.map((e) =>
            e == null ? null : StarRatings.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['isMakeMoneyLimit'] as bool,
    json['contentLevel'] as int,
    json['isFineBook'] as bool,
    json['safelevel'] as int,
    json['allowFree'] as bool,
    json['originalAuthor'] as String,
    json['anchors'] as List,
    json['authorDesc'] as String,
    json['rating'] == null
        ? null
        : Rating.fromJson(json['rating'] as Map<String, dynamic>),
    json['hasCopyright'] as bool,
    json['buytype'] as int,
    json['sizetype'] as int,
    json['superscript'] as String,
    json['currency'] as int,
    json['contentType'] as String,
    json['_le'] as bool,
    json['allowMonthly'] as bool,
    json['allowVoucher'] as bool,
    json['allowBeanVoucher'] as bool,
    json['hasCp'] as bool,
    json['banned'] as int,
    json['postCount'] as int,
    json['totalFollower'] as int,
    json['latelyFollower'] as int,
    json['followerCount'] as int,
    json['wordCount'] as int,
    json['serializeWordCount'] as int,
    json['retentionRatio'] as String,
    json['updated'] as String,
    json['isSerial'] as bool,
    json['chaptersCount'] as int,
    json['lastChapter'] as String,
    json['gender'] as List,
    json['tags'] as List,
    json['advertRead'] as bool,
    json['donate'] as bool,
    json['copyright'] as String,
    json['_gg'] as bool,
    json['isForbidForFreeApp'] as bool,
    json['isAllowNetSearch'] as bool,
    json['limit'] as bool,
    json['copyrightInfo'] as String,
    json['copyrightDesc'] as String,
  );
}

Map<String, dynamic> _$NovelDetailInfoToJson(NovelDetailInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'majorCate': instance.majorCate,
      'cover': instance.cover,
      'longIntro': instance.longIntro,
      'starRatingCount': instance.starRatingCount,
      'starRatings': instance.starRatings,
      'isMakeMoneyLimit': instance.isMakeMoneyLimit,
      'contentLevel': instance.contentLevel,
      'isFineBook': instance.isFineBook,
      'safelevel': instance.safelevel,
      'allowFree': instance.allowFree,
      'originalAuthor': instance.originalAuthor,
      'anchors': instance.anchors,
      'authorDesc': instance.authorDesc,
      'rating': instance.rating,
      'hasCopyright': instance.hasCopyright,
      'buytype': instance.buytype,
      'sizetype': instance.sizetype,
      'superscript': instance.superscript,
      'currency': instance.currency,
      'contentType': instance.contentType,
      '_le': instance.le,
      'allowMonthly': instance.allowMonthly,
      'allowVoucher': instance.allowVoucher,
      'allowBeanVoucher': instance.allowBeanVoucher,
      'hasCp': instance.hasCp,
      'banned': instance.banned,
      'postCount': instance.postCount,
      'totalFollower': instance.totalFollower,
      'latelyFollower': instance.latelyFollower,
      'followerCount': instance.followerCount,
      'wordCount': instance.wordCount,
      'serializeWordCount': instance.serializeWordCount,
      'retentionRatio': instance.retentionRatio,
      'updated': instance.updated,
      'isSerial': instance.isSerial,
      'chaptersCount': instance.chaptersCount,
      'lastChapter': instance.lastChapter,
      'gender': instance.gender,
      'tags': instance.tags,
      'advertRead': instance.advertRead,
      'donate': instance.donate,
      'copyright': instance.copyright,
      '_gg': instance.gg,
      'isForbidForFreeApp': instance.isForbidForFreeApp,
      'isAllowNetSearch': instance.isAllowNetSearch,
      'limit': instance.limit,
      'copyrightInfo': instance.copyrightInfo,
      'copyrightDesc': instance.copyrightDesc,
    };

StarRatings _$StarRatingsFromJson(Map<String, dynamic> json) {
  return StarRatings(
    json['count'] as int,
    json['star'] as int,
  );
}

Map<String, dynamic> _$StarRatingsToJson(StarRatings instance) =>
    <String, dynamic>{
      'count': instance.count,
      'star': instance.star,
    };

Rating _$RatingFromJson(Map<String, dynamic> json) {
  return Rating(
    (json['score'] as num)?.toDouble(),
    json['count'] as int,
    json['tip'] as String,
    json['isEffect'] as bool,
  );
}

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'score': instance.score,
      'count': instance.count,
      'tip': instance.tip,
      'isEffect': instance.isEffect,
    };
