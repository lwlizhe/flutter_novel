import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_net.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelBookSearchViewModel extends BaseViewModel {
  final NovelBookNetModel _netBookModel;

  SearchContentEntity contentEntity = SearchContentEntity();

  NovelBookSearchViewModel(this._netBookModel);

  void getSearchWord(String keyWord) async {
    contentEntity.searchHotWord.clear();
    contentEntity.searchHotWord.addAll(await _netBookModel.getSearchWord(keyWord));
    notifyListeners();
  }

  @override
  Widget getProviderContainer() {
    return null;
  }
}

class SearchContentEntity {
  List<String> searchHotWord = [];
}
