import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/home/viewmodel/home_recommend_view_model.dart';

/// ------------------------------- 推荐页排行榜内容页 ----------------------------
class HomeRecommendRankContentView
    extends BaseView<HomeRecommendRankingContentViewModel> {
  final String rankTagId;

  HomeRecommendRankContentView({required this.rankTagId, Key? key})
      : super(key: key);

  final List<MaterialColor> colorList = [
    Colors.red,
    Colors.green,
    Colors.yellow
  ];

  @override
  void initState(BaseViewState<HomeRecommendRankingContentViewModel> state) {
    super.initState(state);

    state.viewModel?.getRankingNovelList(rankTagId);
  }

  @override
  Widget buildContent(
      BuildContext context, HomeRecommendRankingContentViewModel viewModel) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: viewModel.info?.ranking?.books?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 300,
              color: colorList[index % 3],
              alignment: AlignmentDirectional.center,
              child: Text(
                'item_$index',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  HomeRecommendRankingContentViewModel buildViewModel() {
    return HomeRecommendRankingContentViewModel();
  }

  @override
  String? get tag => rankTagId;
}
