import 'package:flutter/material.dart';
import 'package:flutter_novel/app/router/manager_router.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelLeaderBoardView extends BaseStatelessView {
  static NovelLeaderBoardView getPageView(APPRouterRequestOption option) {
    return NovelLeaderBoardView();
  }

  @override
  Widget buildView(BuildContext context, BaseViewModel viewModel) {
    return null;
  }

  @override
  BaseViewModel buildViewModel(BuildContext context) {
    return null;
  }

  @override
  void loadData(BuildContext context, BaseViewModel viewModel) {}
}
