import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_review.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_detail.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_short_comment.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_net.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelBookIntroViewModel extends BaseViewModel {
  NovelBookNetModel _netBookModel;

  NovelBookIntroContentEntity contentEntity = NovelBookIntroContentEntity();

  NovelBookIntroViewModel(this._netBookModel);

  void getNovelInfo(String bookId) {
    getDetailInfo(bookId);
    getNovelShortReview(bookId);
    getNovelBookReview(bookId);
  }

  void getDetailInfo(String bookId) async {
    var result = await _netBookModel.getNovelDetailInfo(bookId);
    if (result.isSuccess && result?.data != null) {
      contentEntity.detailInfo = result.data;
      notifyListeners();
    }
  }

  void getNovelShortReview(String bookId) async {
    var result = await _netBookModel.getNovelShortReview(bookId,limit: 2);
    if (result.isSuccess && result?.data != null) {
      contentEntity.shortComment = result.data;
      notifyListeners();
    }
  }

  void getNovelBookReview(String bookId) async {
    var result = await _netBookModel.getNovelBookReview(bookId,limit: 2);
    if (result.isSuccess && result?.data != null) {
      contentEntity.bookReviewInfo = result.data;
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
  NovelShortComment shortComment;
  NovelBookReview bookReviewInfo;
}
