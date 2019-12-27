import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_book_chapter.g.dart';


@JsonSerializable()
class NovelBookChapter extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'book')
  String book;

  @JsonKey(name: 'link')
  String link;

  @JsonKey(name: 'chapters')
  List<Chapters> chapters;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'host')
  String host;

  NovelBookChapter(this.id,this.name,this.source,this.book,this.link,this.chapters,this.updated,this.host,);

  factory NovelBookChapter.fromJson(Map<String, dynamic> srcJson) => _$NovelBookChapterFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelBookChapterToJson(this);

}


@JsonSerializable()
class Chapters extends Object {

  @JsonKey(name: '_id')
  String bookId;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'link')
  String link;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'time')
  int time;

  @JsonKey(name: 'chapterCover')
  String chapterCover;

  @JsonKey(name: 'totalpage')
  int totalpage;

  @JsonKey(name: 'partsize')
  int partsize;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'currency')
  int currency;

  @JsonKey(name: 'unreadble')
  bool unreadble;

  @JsonKey(name: 'isVip')
  bool isVip;

  String novelId;

  Chapters(this.bookId,this.title,this.link,this.id,this.time,this.chapterCover,this.totalpage,this.partsize,this.order,this.currency,this.unreadble,this.isVip,);

  factory Chapters.fromJson(Map<String, dynamic> srcJson) => _$ChaptersFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ChaptersToJson(this);

}

  
