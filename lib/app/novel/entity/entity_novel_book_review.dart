import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_book_review.g.dart';


@JsonSerializable()
class NovelBookReview extends Object {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'today')
  int today;

  @JsonKey(name: 'reviews')
  List<Reviews> reviews;

  @JsonKey(name: 'ok')
  bool ok;

  NovelBookReview(this.total,this.today,this.reviews,this.ok,);

  factory NovelBookReview.fromJson(Map<String, dynamic> srcJson) => _$NovelBookReviewFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelBookReviewToJson(this);

}


@JsonSerializable()
class Reviews extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'rating')
  int rating;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'helpful')
  Helpful helpful;

  @JsonKey(name: 'likeCount')
  int likeCount;

  @JsonKey(name: 'state')
  String state;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'created')
  String created;

  @JsonKey(name: 'commentCount')
  int commentCount;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'title')
  String title;

  Reviews(this.id,this.rating,this.author,this.helpful,this.likeCount,this.state,this.updated,this.created,this.commentCount,this.content,this.title,);

  factory Reviews.fromJson(Map<String, dynamic> srcJson) => _$ReviewsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);

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
class Helpful extends Object {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'yes')
  int yes;

  @JsonKey(name: 'no')
  int no;

  Helpful(this.total,this.yes,this.no,);

  factory Helpful.fromJson(Map<String, dynamic> srcJson) => _$HelpfulFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HelpfulToJson(this);

}

  
