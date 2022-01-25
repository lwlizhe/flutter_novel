import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_detail_info.g.dart';

@JsonSerializable(explicitToJson: true)
class NovelDetailInfo {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'author')
  String? author;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'longIntro')
  String? longIntro;

  @JsonKey(name: 'majorCate')
  String? majorCate;

  @JsonKey(name: 'minorCate')
  String? minorCate;

  @JsonKey(name: 'majorCateV2')
  String? majorCateV2;

  @JsonKey(name: 'minorCateV2')
  String? minorCateV2;

  @JsonKey(name: 'creater')
  String? creater;

  @JsonKey(name: 'starRatingCount')
  int? starRatingCount;

  @JsonKey(name: 'starRatings')
  List<StarRatings>? starRatings;

  @JsonKey(name: 'isMakeMoneyLimit')
  bool? isMakeMoneyLimit;

  @JsonKey(name: 'contentLevel')
  int? contentLevel;

  @JsonKey(name: 'isFineBook')
  bool? isFineBook;

  @JsonKey(name: 'safelevel')
  int? safelevel;

  @JsonKey(name: 'allowFree')
  bool? allowFree;

  @JsonKey(name: 'originalAuthor')
  String? originalAuthor;

  @JsonKey(name: 'anchors')
  List<dynamic>? anchors;

  @JsonKey(name: 'authorDesc')
  String? authorDesc;

  @JsonKey(name: 'rating')
  Rating? rating;

  @JsonKey(name: 'hasCopyright')
  bool? hasCopyright;

  @JsonKey(name: 'buytype')
  int? buytype;

  @JsonKey(name: 'sizetype')
  int? sizetype;

  @JsonKey(name: 'superscript')
  String? superscript;

  @JsonKey(name: 'currency')
  int? currency;

  @JsonKey(name: 'contentType')
  String? contentType;

  @JsonKey(name: '_le')
  bool? le;

  @JsonKey(name: 'allowMonthly')
  bool? allowMonthly;

  @JsonKey(name: 'allowVoucher')
  bool? allowVoucher;

  @JsonKey(name: 'allowBeanVoucher')
  bool? allowBeanVoucher;

  @JsonKey(name: 'hasCp')
  bool? hasCp;

  @JsonKey(name: 'banned')
  int? banned;

  @JsonKey(name: 'postCount')
  int? postCount;

  @JsonKey(name: 'totalFollower')
  int? totalFollower;

  @JsonKey(name: 'latelyFollower')
  int? latelyFollower;

  @JsonKey(name: 'followerCount')
  int? followerCount;

  @JsonKey(name: 'wordCount')
  int? wordCount;

  @JsonKey(name: 'serializeWordCount')
  int? serializeWordCount;

  @JsonKey(name: 'retentionRatio')
  String? retentionRatio;

  @JsonKey(name: 'updated')
  String? updated;

  @JsonKey(name: 'isSerial')
  bool? isSerial;

  @JsonKey(name: 'chaptersCount')
  int? chaptersCount;

  @JsonKey(name: 'lastChapter')
  String? lastChapter;

  @JsonKey(name: 'gender')
  List<String>? gender;

  @JsonKey(name: 'tags')
  List<String>? tags;

  @JsonKey(name: 'advertRead')
  bool? advertRead;

  @JsonKey(name: 'cat')
  String? cat;

  @JsonKey(name: 'donate')
  bool? donate;

  @JsonKey(name: 'copyright')
  String? copyright;

  @JsonKey(name: '_gg')
  bool? gg;

  @JsonKey(name: 'isForbidForFreeApp')
  bool? isForbidForFreeApp;

  @JsonKey(name: 'isAllowNetSearch')
  bool? isAllowNetSearch;

  @JsonKey(name: 'limit')
  bool? limit;

  @JsonKey(name: 'copyrightInfo')
  String? copyrightInfo;

  @JsonKey(name: 'copyrightDesc')
  String? copyrightDesc;

  NovelDetailInfo();

  static NovelDetailInfo fromJson(Map<String, dynamic> srcJson) =>
      _$NovelDetailInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelDetailInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StarRatings {
  @JsonKey(name: 'star')
  int? star;

  @JsonKey(name: 'count')
  int? count;

  StarRatings();

  static StarRatings fromJson(Map<String, dynamic> srcJson) =>
      _$StarRatingsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StarRatingsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Rating {
  @JsonKey(name: 'count')
  int? count;

  @JsonKey(name: 'score')
  double? score;

  @JsonKey(name: 'tip')
  String? tip;

  @JsonKey(name: 'isEffect')
  bool? isEffect;

  Rating();

  static Rating fromJson(Map<String, dynamic> srcJson) =>
      _$RatingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
