import 'package:json_annotation/json_annotation.dart';

part 'entity_novel_book_source.g.dart';


List<NovelBookSource> getNovelBookSourceList(List<dynamic> list){
  List<NovelBookSource> result = [];
  list.forEach((item){
    result.add(NovelBookSource.fromJson(item));
  });
  return result;
}
@JsonSerializable()
class NovelBookSource extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'isCharge')
  bool isCharge;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'lastChapter')
  String lastChapter;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'link')
  String link;

  @JsonKey(name: 'starting')
  bool starting;

  @JsonKey(name: 'chaptersCount')
  int chaptersCount;

  @JsonKey(name: 'host')
  String host;

  NovelBookSource(this.id,this.isCharge,this.name,this.lastChapter,this.updated,this.source,this.link,this.starting,this.chaptersCount,this.host,);

  factory NovelBookSource.fromJson(Map<String, dynamic> srcJson) => _$NovelBookSourceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NovelBookSourceToJson(this);

}


