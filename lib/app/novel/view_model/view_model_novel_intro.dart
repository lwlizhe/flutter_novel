import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_book_detail.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_net.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelBookIntroViewModel extends BaseViewModel{

  NovelBookNetModel _netBookModel;

  NovelBookIntroContentEntity contentEntity=NovelBookIntroContentEntity();

  NovelBookIntroViewModel(this._netBookModel);

  void getDetailInfo(String bookId) async {
    var result=await _netBookModel.getNovelDetailInfo(bookId);
    if(result.isSuccess&&result?.data!=null) {
      contentEntity.detailInfo=result.data;
      notifyListeners();
    }
  }

  @override
  Widget getProviderContainer() {
    return null;
  }

}

class NovelBookIntroContentEntity {
  NovelDetailInfo detailInfo;
}