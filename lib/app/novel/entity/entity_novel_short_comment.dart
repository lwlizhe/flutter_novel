import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_short_comment.g.dart';

@JsonSerializable()
class NovelShortComment extends Object {

  @JsonKey(name: 'today')
  int today;

  @JsonKey(name: 'docs')
  List<Docs> docs;

  @JsonKey(name: 'ok')
  bool ok;

  NovelShortComment(this.today,this.docs,this.ok,);

  factory NovelShortComment.fromJson(Map<String, dynamic> srcJson) => _$NovelShortCommentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelShortCommentToJson(this);

}


@JsonSerializable()
class Docs extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'rating')
  int rating;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'book')
  Book book;

  @JsonKey(name: 'likeCount')
  int likeCount;

  @JsonKey(name: 'priority')
  double priority;

  @JsonKey(name: 'block')
  String block;

  @JsonKey(name: 'state')
  String state;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'created')
  String created;

  @JsonKey(name: 'content')
  String content;

  Docs(this.id,this.rating,this.type,this.author,this.book,this.likeCount,this.priority,this.block,this.state,this.updated,this.created,this.content,);

  factory Docs.fromJson(Map<String, dynamic> srcJson) => _$DocsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DocsToJson(this);

}


@JsonSerializable()
class Author extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'activityAvatar')
  String activityAvatar;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'lv')
  int lv;

  @JsonKey(name: 'gender')
  String gender;

  Author(this.id,this.avatar,this.nickname,this.activityAvatar,this.type,this.lv,this.gender,);

  factory Author.fromJson(Map<String, dynamic> srcJson) => _$AuthorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);

}


@JsonSerializable()
class Book extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'cover')
  String cover;

  Book(this.id,this.title,this.cover,);

  factory Book.fromJson(Map<String, dynamic> srcJson) => _$BookFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BookToJson(this);

}


