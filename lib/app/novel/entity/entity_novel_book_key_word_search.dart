import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_book_key_word_search.g.dart';

@JsonSerializable()
class NovelKeyWordSearch extends Object {

  @JsonKey(name: 'books')
  List<Books> books;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'ok')
  bool ok;

  NovelKeyWordSearch(this.books,this.total,this.ok,);

  factory NovelKeyWordSearch.fromJson(Map<String, dynamic> srcJson) => _$NovelKeyWordSearchFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelKeyWordSearchToJson(this);

}


@JsonSerializable()
class Books extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'hasCp')
  bool hasCp;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'aliases')
  String aliases;

  @JsonKey(name: 'cat')
  String cat;

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

  @JsonKey(name: 'banned')
  int banned;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'wordCount')
  int wordCount;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: 'superscript')
  String superscript;

  @JsonKey(name: 'sizetype')
  int sizetype;

  @JsonKey(name: 'highlight')
  Highlight highlight;

  Books(this.id,this.hasCp,this.title,this.aliases,this.cat,this.author,this.site,this.cover,this.shortIntro,this.lastChapter,this.retentionRatio,this.banned,this.allowMonthly,this.latelyFollower,this.wordCount,this.contentType,this.superscript,this.sizetype,this.highlight,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BooksToJson(this);

}


@JsonSerializable()
class Highlight extends Object {

  @JsonKey(name: 'title')
  List<String> title;

  Highlight(this.title,);

  factory Highlight.fromJson(Map<String, dynamic> srcJson) => _$HighlightFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HighlightToJson(this);

}

  
