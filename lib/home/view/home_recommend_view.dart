import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/home/viewmodel/home_recommend_view_model.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:flutter_novel/net/entity/entity_novel_info_by_tag.dart';
import 'package:flutter_novel/net/entity/entity_novel_rank_tag_info.dart';
import 'package:flutter_novel/widget/planet/planet_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

/// ------------------------------- 推荐页整体 -----------------------------------
class HomePageRecommendPage extends BaseView<HomeRecommendViewModel> {
  HomePageRecommendPage({Key? key}) : super(key: key);

  @override
  String get title => '推荐';

  @override
  Widget buildContent(BuildContext context, HomeRecommendViewModel viewModel) {
    return Container(
      color: Color(0xFF333333),
      alignment: Alignment.center,
      child: NestedScrollView(
        // child: ExtendedNestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [_HomeRecommendAppBarView()];
        },
        // pinnedHeaderSliverHeightBuilder: () {
        //   return kToolbarHeight;
        // },
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ObxValue<RxList<NovelRankTag>>((value) {
            if (value.isEmpty) {
              return SizedBox.shrink();
            } else {
              return _HomeRecommendRankView(value);
            }
          }, viewModel.rankTagList),
        ),
      ),
    );
  }

  @override
  HomeRecommendViewModel buildViewModel() {
    return HomeRecommendViewModel();
  }
}

/// ------------------------------- 推荐页AppBar --------------------------------

class _HomeRecommendAppBarView extends StatelessWidget {
  const _HomeRecommendAppBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 500,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Color(0xFF333333),
      foregroundColor: Colors.transparent,
      flexibleSpace: RepaintBoundary(
        child: _buildPlanetWidget(Get.find()),
      ),
    );
  }

  Widget _buildPlanetWidget(HomeRecommendViewModel viewModel) {
    return ObxValue<RxList<Books>>((value) {
      if (value.isNotEmpty) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: PlanetWidget(
            children: viewModel.recommendNovels
                .take(min(20, viewModel.recommendNovels.length))
                .map((element) => GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: 'Item ${element.title} clicked');
                      },
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 40,
                              child: Image.network(
                                READER_IMAGE_URL + (element.cover ?? ''),
                                height: 40,
                                width: 30,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Text(
                              element.title ?? '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        );
      } else {
        return Center(
          child: Text(
            'loading...',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    }, viewModel.recommendNovels);
  }
}

/// ------------------------------- 推荐页排行榜 ---------------------------------
class _HomeRecommendRankView extends StatefulWidget {
  const _HomeRecommendRankView(this.tagList, {Key? key}) : super(key: key);

  final List<NovelRankTag> tagList;

  @override
  _HomeRecommendRankViewState createState() => _HomeRecommendRankViewState();
}

class _HomeRecommendRankViewState extends State<_HomeRecommendRankView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late HomeRecommendViewModel viewModel;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: widget.tagList.length);
    viewModel = Get.find();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TabBar(
              controller: tabController,
              isScrollable: true,
              tabs: widget.tagList
                  .map((e) => Tab(
                        text: e.title ?? '',
                      ))
                  .toList()),
          Expanded(
              child: TabBarView(
                  controller: tabController,
                  children: widget.tagList
                      .map(
                        (e) => _HomeRecommendRankContentView(),
                      )
                      .toList()))
        ],
      ),
    );
  }
}

/// ------------------------------- 推荐页排行榜内容页 ----------------------------
class _HomeRecommendRankContentView extends StatelessWidget {
  _HomeRecommendRankContentView({Key? key}) : super(key: key);

  final List<MaterialColor> colorList = [
    Colors.red,
    Colors.green,
    Colors.yellow
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 300,
              color: colorList[index],
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
}
