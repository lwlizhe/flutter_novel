import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_detail.g.dart';

@JsonSerializable()
class NovelDetailInfo extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'majorCate')
  String majorCate;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'longIntro')
  String longIntro;

  @JsonKey(name: 'starRatingCount')
  int starRatingCount;

  @JsonKey(name: 'starRatings')
  List<StarRatings> starRatings;

  @JsonKey(name: 'isMakeMoneyLimit')
  bool isMakeMoneyLimit;

  @JsonKey(name: 'contentLevel')
  int contentLevel;

  @JsonKey(name: 'isFineBook')
  bool isFineBook;

  @JsonKey(name: 'safelevel')
  int safelevel;

  @JsonKey(name: 'allowFree')
  bool allowFree;

  @JsonKey(name: 'originalAuthor')
  String originalAuthor;

  @JsonKey(name: 'anchors')
  List<dynamic> anchors;

  @JsonKey(name: 'authorDesc')
  String authorDesc;

  @JsonKey(name: 'rating')
  Rating rating;

  @JsonKey(name: 'hasCopyright')
  bool hasCopyright;

  @JsonKey(name: 'buytype')
  int buytype;

  @JsonKey(name: 'sizetype')
  int sizetype;

  @JsonKey(name: 'superscript')
  String superscript;

  @JsonKey(name: 'currency')
  int currency;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: '_le')
  bool le;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'allowVoucher')
  bool allowVoucher;

  @JsonKey(name: 'allowBeanVoucher')
  bool allowBeanVoucher;

  @JsonKey(name: 'hasCp')
  bool hasCp;

  @JsonKey(name: 'banned')
  int banned;

  @JsonKey(name: 'postCount')
  int postCount;

  @JsonKey(name: 'totalFollower')
  int totalFollower;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'followerCount')
  int followerCount;

  @JsonKey(name: 'wordCount')
  int wordCount;

  @JsonKey(name: 'serializeWordCount')
  int serializeWordCount;

  @JsonKey(name: 'retentionRatio')
  String retentionRatio;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'isSerial')
  bool isSerial;

  @JsonKey(name: 'chaptersCount')
  int chaptersCount;

  @JsonKey(name: 'lastChapter')
  String lastChapter;

  @JsonKey(name: 'gender')
  List<dynamic> gender;

  @JsonKey(name: 'tags')
  List<dynamic> tags;

  @JsonKey(name: 'advertRead')
  bool advertRead;

  @JsonKey(name: 'donate')
  bool donate;

  @JsonKey(name: 'copyright')
  String copyright;

  @JsonKey(name: '_gg')
  bool gg;

  @JsonKey(name: 'isForbidForFreeApp')
  bool isForbidForFreeApp;

  @JsonKey(name: 'isAllowNetSearch')
  bool isAllowNetSearch;

  @JsonKey(name: 'limit')
  bool limit;

  @JsonKey(name: 'copyrightInfo')
  String copyrightInfo;

  @JsonKey(name: 'copyrightDesc')
  String copyrightDesc;

  NovelDetailInfo(this.id,this.title,this.author,this.majorCate,this.cover,this.longIntro,this.starRatingCount,this.starRatings,this.isMakeMoneyLimit,this.contentLevel,this.isFineBook,this.safelevel,this.allowFree,this.originalAuthor,this.anchors,this.authorDesc,this.rating,this.hasCopyright,this.buytype,this.sizetype,this.superscript,this.currency,this.contentType,this.le,this.allowMonthly,this.allowVoucher,this.allowBeanVoucher,this.hasCp,this.banned,this.postCount,this.totalFollower,this.latelyFollower,this.followerCount,this.wordCount,this.serializeWordCount,this.retentionRatio,this.updated,this.isSerial,this.chaptersCount,this.lastChapter,this.gender,this.tags,this.advertRead,this.donate,this.copyright,this.gg,this.isForbidForFreeApp,this.isAllowNetSearch,this.limit,this.copyrightInfo,this.copyrightDesc,);

  factory NovelDetailInfo.fromJson(Map<String, dynamic> srcJson) => _$NovelDetailInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelDetailInfoToJson(this);

}


@JsonSerializable()
class StarRatings extends Object {

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'star')
  int star;

  StarRatings(this.count,this.star,);

  factory StarRatings.fromJson(Map<String, dynamic> srcJson) => _$StarRatingsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StarRatingsToJson(this);

}


@JsonSerializable()
class Rating extends Object {

  @JsonKey(name: 'score')
  double score;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'tip')
  String tip;

  @JsonKey(name: 'isEffect')
  bool isEffect;

  Rating(this.score,this.count,this.tip,this.isEffect,);

  factory Rating.fromJson(Map<String, dynamic> srcJson) => _$RatingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RatingToJson(this);

}


