import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_novel/app/novel/entity/entity_book_detail.dart';
import 'package:flutter_novel/app/novel/view/widget/novel_book_intro_appbar_header_view.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_intro.dart';
import 'package:flutter_novel/app/widget/widget_expand_text_view.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;

class NovelBookIntroView extends BaseStatefulView<NovelBookIntroViewModel> {
  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>,
      NovelBookIntroViewModel> buildState() {
    return _NovelBookIntroViewState();
  }
}

class _NovelBookIntroViewState
    extends BaseStatefulViewState<NovelBookIntroView, NovelBookIntroViewModel> {

   Color bgStartColor;
   Color bgNormalColor;
   Color bgEndColor;

  @override
  Widget buildView(BuildContext context, NovelBookIntroViewModel viewModel) {

    var pinnedHeaderHeight =
        MediaQuery.of(context).padding.top + kToolbarHeight;
    NovelDetailInfo detailInfo = viewModel?.contentEntity?.detailInfo;

    if((bgEndColor==null||bgEndColor==null)&&detailInfo?.cover!=null){
      initPageTopColor(Uri.decodeComponent(detailInfo.cover
          .split("/agent/")
          .last)).then((data){
            setState(() {
              bgStartColor = data?.lightVibrantColor?.color ?? Colors.white;
              bgNormalColor = data?.dominantColor?.color ?? Colors.white;
              bgEndColor = data?.darkMutedColor?.color ?? Colors.grey[300];
            });
      });
    }

    return Scaffold(
      body: NestedScrollView(pinnedHeaderSliverHeightBuilder: () {
        return pinnedHeaderHeight;
      }, headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return _headerSliverBuilder(context, detailInfo);
      }, body: Builder(builder: (context) {
        return Container();
      })),
    );
  }

  @override
  NovelBookIntroViewModel buildViewModel(BuildContext context) {
    return NovelBookIntroViewModel(Provider.of(context));
  }

  @override
  void initData() {}

  @override
  void loadData(BuildContext context, NovelBookIntroViewModel viewModel) {
    viewModel.getDetailInfo("592fe687c60e3c4926b040ca");
  }

  List<Widget> _headerSliverBuilder(
      BuildContext context, NovelDetailInfo detailInfo) {
    List<Widget> headerContentList = [];
    headerContentList.add(SliverAppBar(
      //1.在标题左侧显示的一个控件，在首页通常显示应用的 logo；在其他界面通常显示为返回按钮
      leading: Icon(Icons.arrow_back),
      title: Text(detailInfo?.title ?? "正在查询"),
      backgroundColor: bgStartColor??Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: NovelIntroAppBarHeaderView(detailInfo,bgStartColor,bgEndColor),
      ),
      expandedHeight: 240,
      centerTitle: true,
      pinned: true,
      floating: true,
      snap: false,
    ));

    headerContentList.add(SliverToBoxAdapter(
      child: ExpandText(
        "777777777777777777777777777777777777777777777777777777777777777777777777777777" *
            5,
        maxLength: 2,
      ),
    ));

    return headerContentList;
  }

  Future<PaletteGenerator> initPageTopColor(String imgPath) async {
    PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(imgPath));
    return paletteGenerator;
  }

}
