import 'package:flutter_novel/app/api/api_novel.dart';
import 'package:flutter_novel/base/structure/base_model.dart';

class NovelBookNetModel extends BaseModel{

  final NovelApi _api;

  NovelBookNetModel(this._api);

  void getBookIntroduction(){

  }

  void getCatalog(){

  }

  Future<List<String>> getSearchWord(String keyWord) async{
    return _api.getSearchWord(keyWord);
  }

  Future<String> getChapterContent() async{
    return null;
  }

}