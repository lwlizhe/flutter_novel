import 'package:flutter_novel/app/api/api_novel.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_chapter.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_key_word_search.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_recommend.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_review.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_source.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_detail.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_short_comment.dart';
import 'package:flutter_novel/base/structure/base_model.dart';


class NovelBookNetModel extends BaseModel{

  final NovelApi _api;

  NovelBookIntroContentEntity bookIntroContentEntity = NovelBookIntroContentEntity();

  NovelBookNetModel(this._api);

  void getBookIntroduction(){

  }

  Future<BaseResponse<List<String>>> getSearchWord(String keyWord) async{
    return _api.getSearchWord(keyWord);
  }
  Future<BaseResponse<List<String>>> getHotSearchWord() async{
    return _api.getHotSearchWord();
  }
  Future<BaseResponse<NovelKeyWordSearch>> searchTargetKeyWord(String keyword) async{
    return _api.searchTargetKeyWord(keyword);
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
  Future<BaseResponse<NovelBookRecommend>> getNovelBookRecommend(String bookId) async{
    return _api.getNovelBookRecommend(bookId);
  }

  Future<BaseResponse<NovelBookChapter>> getNovelBookCatalog(String sourceId) async{
    return await _api.getNovelCatalog(sourceId);
  }

  Future<BaseResponse<List<NovelBookSource>>> getNovelBookSource(String bookId) async{
    return await _api.getNovelSource(bookId);
  }
}

class NovelBookIntroContentEntity {
  NovelDetailInfo detailInfo;
  NovelShortComment shortComment;
  NovelBookReview bookReviewInfo;
  NovelBookRecommend bookRecommendInfo;
}

class SearchContentEntity {

  List<String> searchHotWord = [];
  List<String> autoCompleteSearchWord = [];
  NovelKeyWordSearch keyWordSearchResult;

}