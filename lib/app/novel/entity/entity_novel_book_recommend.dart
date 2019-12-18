import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_book_recommend.g.dart';

@JsonSerializable()
class NovelBookRecommend extends Object {

  @JsonKey(name: 'books')
  List<Books> books;

  @JsonKey(name: 'ok')
  bool ok;

  NovelBookRecommend(this.books,this.ok,);

  factory NovelBookRecommend.fromJson(Map<String, dynamic> srcJson) => _$NovelBookRecommendFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelBookRecommendToJson(this);

}


@JsonSerializable()
class Books extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'site')
  String site;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'shortIntro')
  String shortIntro;

  @JsonKey(name: 'lastChapter')
  String lastChapter;

  @JsonKey(name: 'retentionRatio')
  double retentionRatio;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'majorCate')
  String majorCate;

  @JsonKey(name: 'minorCate')
  String minorCate;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'isSerial')
  bool isSerial;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: 'allowFree')
  bool allowFree;

  @JsonKey(name: 'otherReadRatio')
  double otherReadRatio;

  Books(this.id,this.title,this.author,this.site,this.cover,this.shortIntro,this.lastChapter,this.retentionRatio,this.latelyFollower,this.majorCate,this.minorCate,this.allowMonthly,this.isSerial,this.contentType,this.allowFree,this.otherReadRatio,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BooksToJson(this);

}

  
