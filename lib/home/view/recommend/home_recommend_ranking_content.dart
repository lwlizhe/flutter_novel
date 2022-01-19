import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/common/constant.dart';
import 'package:flutter_novel/common/util.dart';
import 'package:flutter_novel/home/viewmodel/home_recommend_view_model.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:flutter_novel/net/entity/entity_novel_rank_info_of_tag.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// ------------------------------- 推荐页排行榜内容页 ----------------------------
class HomeRecommendRankContentView
    extends BaseView<HomeRecommendRankingContentViewModel> {
  final String rankTagId;

  HomeRecommendRankContentView({required this.rankTagId, Key? key})
      : super(key: key);

  @override
  void initState(BaseViewState<HomeRecommendRankingContentViewModel> state) {
    super.initState(state);

    state.viewModel?.getRankingNovelList(rankTagId);
  }

  @override
  Widget buildContent(
      BuildContext context, HomeRecommendRankingContentViewModel viewModel) {
    var bookList = viewModel.info?.ranking?.books ?? [];

    return Container(
      child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              var bookInfo = bookList[index];

              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 210,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: buildButton(
                      context: context,
                      onPressCallback: () {},
                      childWidgetBuilder: (context) {
                        return DefaultTextStyle(
                            style: CommonStyle.common_item_text_style,
                            child: _buildItemContent(bookInfo));
                      }),
                ),
              );
            },
          )),
    );
  }

  @override
  HomeRecommendRankingContentViewModel buildViewModel() {
    return HomeRecommendRankingContentViewModel();
  }

  @override
  String? get tag => rankTagId;

  Widget _buildItemContent(RankBooks bookInfo) {
    return Container(
      color: ColorsExt.bg_item_black,
      alignment: AlignmentDirectional.topCenter,
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            READER_IMAGE_URL + (bookInfo.cover ?? ''),
            height: 185,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookInfo.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '作者:${bookInfo.author}',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
