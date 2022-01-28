import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/common/constant.dart';
import 'package:flutter_novel/common/util.dart';
import 'package:flutter_novel/entity/net/entity_novel_rank_info_of_tag.dart';
import 'package:flutter_novel/home/viewmodel/home_recommend_view_model.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:flutter_novel/novel/view/novel_detail_page.dart';
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
                  minHeight: 200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: buildButton(
                      context: context,
                      onPressCallback: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            //动画时间为500毫秒
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                //使用渐隐渐入过渡,
                                opacity: animation,
                                child: NovelDetailPage(bookInfo.id ?? ''),
                              );
                            },
                          ),
                        );
                      },
                      childWidgetBuilder: (context) {
                        return _buildItemContent(bookInfo);
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
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Positioned.fill(
                    child: CachedNetworkImage(
                  imageUrl: READER_IMAGE_URL + (bookInfo.cover ?? ''),
                  fit: BoxFit.fitWidth,
                )),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withAlpha(180),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 40,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        bookInfo.shortIntro ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    )),
              ],
            ),
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
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
