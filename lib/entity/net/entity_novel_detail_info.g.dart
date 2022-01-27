// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_detail_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelDetailInfo _$NovelDetailInfoFromJson(Map<String, dynamic> json) =>
    NovelDetailInfo()
      ..id = json['_id'] as String?
      ..title = json['title'] as String?
      ..author = json['author'] as String?
      ..cover = json['cover'] as String?
      ..longIntro = json['longIntro'] as String?
      ..majorCate = json['majorCate'] as String?
      ..minorCate = json['minorCate'] as String?
      ..majorCateV2 = json['majorCateV2'] as String?
      ..minorCateV2 = json['minorCateV2'] as String?
      ..creater = json['creater'] as String?
      ..starRatingCount = json['starRatingCount'] as int?
      ..starRatings = (json['starRatings'] as List<dynamic>?)
          ?.map((e) => StarRatings.fromJson(e as Map<String, dynamic>))
          .toList()
      ..isMakeMoneyLimit = json['isMakeMoneyLimit'] as bool?
      ..contentLevel = json['contentLevel'] as int?
      ..isFineBook = json['isFineBook'] as bool?
      ..safelevel = json['safelevel'] as int?
      ..allowFree = json['allowFree'] as bool?
      ..originalAuthor = json['originalAuthor'] as String?
      ..anchors = json['anchors'] as List<dynamic>?
      ..authorDesc = json['authorDesc'] as String?
      ..rating = json['rating'] == null
          ? null
          : Rating.fromJson(json['rating'] as Map<String, dynamic>)
      ..hasCopyright = json['hasCopyright'] as bool?
      ..buytype = json['buytype'] as int?
      ..sizetype = json['sizetype'] as int?
      ..superscript = json['superscript'] as String?
      ..currency = json['currency'] as int?
      ..contentType = json['contentType'] as String?
      ..le = json['_le'] as bool?
      ..allowMonthly = json['allowMonthly'] as bool?
      ..allowVoucher = json['allowVoucher'] as bool?
      ..allowBeanVoucher = json['allowBeanVoucher'] as bool?
      ..hasCp = json['hasCp'] as bool?
      ..banned = json['banned'] as int?
      ..postCount = json['postCount'] as int?
      ..totalFollower = json['totalFollower'] as int?
      ..latelyFollower = json['latelyFollower'] as int?
      ..followerCount = json['followerCount'] as int?
      ..wordCount = json['wordCount'] as int?
      ..serializeWordCount = json['serializeWordCount'] as int?
      ..retentionRatio = json['retentionRatio'] as String?
      ..updated = json['updated'] as String?
      ..isSerial = json['isSerial'] as bool?
      ..chaptersCount = json['chaptersCount'] as int?
      ..lastChapter = json['lastChapter'] as String?
      ..gender =
          (json['gender'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..tags =
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..advertRead = json['advertRead'] as bool?
      ..cat = json['cat'] as String?
      ..donate = json['donate'] as bool?
      ..copyright = json['copyright'] as String?
      ..gg = json['_gg'] as bool?
      ..isForbidForFreeApp = json['isForbidForFreeApp'] as bool?
      ..isAllowNetSearch = json['isAllowNetSearch'] as bool?
      ..limit = json['limit'] as bool?
      ..copyrightInfo = json['copyrightInfo'] as String?
      ..copyrightDesc = json['copyrightDesc'] as String?;

Map<String, dynamic> _$NovelDetailInfoToJson(NovelDetailInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'cover': instance.cover,
      'longIntro': instance.longIntro,
      'majorCate': instance.majorCate,
      'minorCate': instance.minorCate,
      'majorCateV2': instance.majorCateV2,
      'minorCateV2': instance.minorCateV2,
      'creater': instance.creater,
      'starRatingCount': instance.starRatingCount,
      'starRatings': instance.starRatings?.map((e) => e.toJson()).toList(),
      'isMakeMoneyLimit': instance.isMakeMoneyLimit,
      'contentLevel': instance.contentLevel,
      'isFineBook': instance.isFineBook,
      'safelevel': instance.safelevel,
      'allowFree': instance.allowFree,
      'originalAuthor': instance.originalAuthor,
      'anchors': instance.anchors,
      'authorDesc': instance.authorDesc,
      'rating': instance.rating?.toJson(),
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
      'cat': instance.cat,
      'donate': instance.donate,
      'copyright': instance.copyright,
      '_gg': instance.gg,
      'isForbidForFreeApp': instance.isForbidForFreeApp,
      'isAllowNetSearch': instance.isAllowNetSearch,
      'limit': instance.limit,
      'copyrightInfo': instance.copyrightInfo,
      'copyrightDesc': instance.copyrightDesc,
    };

StarRatings _$StarRatingsFromJson(Map<String, dynamic> json) => StarRatings()
  ..star = json['star'] as int?
  ..count = json['count'] as int?;

Map<String, dynamic> _$StarRatingsToJson(StarRatings instance) =>
    <String, dynamic>{
      'star': instance.star,
      'count': instance.count,
    };

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating()
  ..count = json['count'] as int?
  ..score = (json['score'] as num?)?.toDouble()
  ..tip = json['tip'] as String?
  ..isEffect = json['isEffect'] as bool?;

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'count': instance.count,
      'score': instance.score,
      'tip': instance.tip,
      'isEffect': instance.isEffect,
    };
