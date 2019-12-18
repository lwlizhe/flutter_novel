import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_net.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelBookSearchViewModel extends BaseViewModel {
  final NovelBookNetModel _netBookModel;

  SearchContentEntity contentEntity = SearchContentEntity();

  NovelBookSearchViewModel(this._netBookModel);

  void getSearchWord(String keyWord) async {
    var result=await _netBookModel.getSearchWord(keyWord);
    if(result.isSuccess&&result?.data!=null&&result.data.length>0) {
      contentEntity.autoCompleteSearchWord.clear();
      contentEntity.autoCompleteSearchWord.addAll(result.data);
      notifyListeners();
    }
  }
  void getHotSearchWord() async {
    var result=await _netBookModel.getHotSearchWord();
    if(result.isSuccess&&result?.data!=null&&result.data.length>0) {
      contentEntity.searchHotWord.clear();
      contentEntity.searchHotWord.addAll(result.data);
      notifyListeners();
    }
  }

  void searchTargetKeyWord(String keyword) async {
    var searchResult= await _netBookModel.searchTargetKeyWord(keyword);
    if(searchResult.isSuccess&&searchResult?.data!=null) {
      contentEntity.keyWordSearchResult=searchResult.data;
      notifyListeners();
    }
  }

  @override
  Widget getProviderContainer() {
    return null;
  }
}


