import 'package:flutter_novel/app/api/api_novel.dart';
import 'package:flutter_novel/app/novel/entity/entity_book_detail.dart';
import 'package:flutter_novel/base/structure/base_model.dart';

class NovelBookNetModel extends BaseModel{

  final NovelApi _api;

  NovelBookNetModel(this._api);

  void getBookIntroduction(){

  }

  void getCatalog(){

  }

  Future<BaseResponse<List<String>>> getSearchWord(String keyWord) async{
    return _api.getSearchWord(keyWord);
  }
  Future<BaseResponse<List<String>>> getHotSearchWord() async{
    return _api.getHotSearchWord();
  }

  Future<BaseResponse<NovelDetailInfo>> getNovelDetailInfo(String bookId) async{
    return _api.getNovelDetailInfo(bookId);
  }

  Future<String> getChapterContent() async{
    return null;
  }

}