import 'package:flutter_novel/app/api/api_novel.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_review.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_detail.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_short_comment.dart';
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

  Future<BaseResponse<NovelShortComment>> getNovelShortReview(String bookId,{String sort: 'updated', int start: 0, int limit: 20}) async{
    return _api.getNovelShortReview(bookId,sort: sort,start: start,limit: limit);
  }

  Future<BaseResponse<NovelBookReview>> getNovelBookReview(String bookId,{String sort: 'updated', int start: 0, int limit: 20}) async{
    return _api.getNovelBookReview(bookId,sort: sort,start: start,limit: limit);
  }

  Future<String> getChapterContent() async{
    return null;
  }

}