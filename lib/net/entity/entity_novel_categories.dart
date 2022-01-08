import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_categories.g.dart';

@JsonSerializable()
class NovelCategories extends Object {
  @JsonKey(name: 'male')
  List<Male> male;

  @JsonKey(name: 'female')
  List<Female> female;

  @JsonKey(name: 'picture')
  List<Picture> picture;

  @JsonKey(name: 'press')
  List<Press> press;

  @JsonKey(name: 'ok')
  bool ok;

  NovelCategories(
    this.male,
    this.female,
    this.picture,
    this.press,
    this.ok,
  );

  factory NovelCategories.fromJson(Map<String, dynamic> srcJson) =>
      _$NovelCategoriesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelCategoriesToJson(this);
}

@JsonSerializable()
class Male extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Male(
    this.name,
    this.bookCount,
    this.monthlyCount,
    this.icon,
    this.bookCover,
  );

  factory Male.fromJson(Map<String, dynamic> srcJson) =>
      _$MaleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MaleToJson(this);
}

@JsonSerializable()
class Female extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Female(
    this.name,
    this.bookCount,
    this.monthlyCount,
    this.icon,
    this.bookCover,
  );

  factory Female.fromJson(Map<String, dynamic> srcJson) =>
      _$FemaleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FemaleToJson(this);
}

@JsonSerializable()
class Picture extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Picture(
    this.name,
    this.bookCount,
    this.monthlyCount,
    this.icon,
    this.bookCover,
  );

  factory Picture.fromJson(Map<String, dynamic> srcJson) =>
      _$PictureFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}

@JsonSerializable()
class Press extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Press(
    this.name,
    this.bookCount,
    this.monthlyCount,
    this.icon,
    this.bookCover,
  );

  factory Press.fromJson(Map<String, dynamic> srcJson) =>
      _$PressFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PressToJson(this);
}
