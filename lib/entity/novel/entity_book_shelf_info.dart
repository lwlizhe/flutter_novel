import 'package:json_annotation/json_annotation.dart';

part 'entity_book_shelf_info.g.dart';

@JsonSerializable(explicitToJson: true)
class NovelBookShelfInfo {
  @JsonKey(name: 'bookShelfInfoList')
  List<NovelBookShelfBookInfo> bookShelfInfoList = [];

  NovelBookShelfInfo();

  static NovelBookShelfInfo fromJson(Map<String, dynamic> srcJson) =>
      _$NovelBookShelfInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelBookShelfInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NovelBookShelfBookInfo {
  @JsonKey(name: 'cover')
  String cover = "";
  @JsonKey(name: 'title')
  String title = "";
  @JsonKey(name: 'id')
  String id = "";
  @JsonKey(name: 'lastChapterId')
  String lastChapterId = "";
  @JsonKey(name: 'lastChapterIndex')
  int lastChapterIndex = 0;
  @JsonKey(name: 'lastPageIndex')
  int lastPageIndex = 0;
  @JsonKey(name: 'readProgress')
  int readProgress = 0;
  @JsonKey(name: 'readCostTime')
  int readCostTime = 0;
  @JsonKey(name: 'lastReadTime')
  int lastReadTime = 0;

  NovelBookShelfBookInfo();

  static NovelBookShelfBookInfo fromJson(Map<String, dynamic> srcJson) =>
      _$NovelBookShelfBookInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelBookShelfBookInfoToJson(this);

  @override
  bool operator ==(Object other) {
    return (other is NovelBookShelfBookInfo) && (other.id == this.id);
  }

  @override
  int get hashCode => id.hashCode;
}
