import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/common/util.dart';
import 'package:flutter_novel/entity/net/entity_novel_book_recommend.dart';
import 'package:flutter_novel/entity/net/entity_novel_detail_info.dart';
import 'package:flutter_novel/entity/novel/entity_book_shelf_info.dart';
import 'package:flutter_novel/home/viewmodel/home_book_shelf_view_model.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:flutter_novel/novel/viewmodel/novel_detail_view_model.dart';
import 'package:flutter_novel/reader/novel_reader_list.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

const _tagRoundConnerRadius = 20.0;

/// 介绍页
class NovelDetailPage extends BaseView<NovelDetailViewModel> {
  final String novelId;

  NovelDetailPage(this.novelId);

  @override
  Widget buildContent(BuildContext context, NovelDetailViewModel viewModel) {
    var detailInfo = viewModel.detailInfo;

    if (detailInfo == null) {
      return Scaffold(
        body: Container(
          alignment: AlignmentDirectional.center,
          child: Text('loading'),
        ),
      );
    }

    return _NovelDetailPageWithBg(detailInfo);
  }

  @override
  NovelDetailViewModel buildViewModel() {
    return NovelDetailViewModel()..novelId = novelId;
  }

  @override
  String? get tag => this.novelId;
}

class _NovelDetailPageWithBg extends StatefulWidget {
  final NovelDetailInfo detailInfo;

  const _NovelDetailPageWithBg(this.detailInfo, {Key? key}) : super(key: key);

  @override
  _NovelDetailPageWithBgState createState() => _NovelDetailPageWithBgState();
}

class _NovelDetailPageWithBgState extends State<_NovelDetailPageWithBg> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaletteGenerator>(
        future: PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(
              READER_IMAGE_URL + (widget.detailInfo.cover ?? '')),
          maximumColorCount: 20,
        ),
        builder: (context, snapShot) {
          var themeColor = Colors.black;
          if (snapShot.hasData && snapShot.data?.mutedColor?.color != null) {
            themeColor = snapShot.data!.mutedColor!.color;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeColor,
              title: Text(
                '书籍详情',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Builder(
                builder: (BuildContext context) {
                  List<Widget> childrenList = [
                    _NovelDetailBookIntroHeaderContent(widget.detailInfo),
                    _NovelDetailBookIntroRatingContent(widget.detailInfo),
                    _NovelDetailTagContent(widget.detailInfo),
                    _NovelDetailContent(widget.detailInfo),
                    _NovelSimilarRecommendContent(widget.detailInfo),
                  ];

                  /// 变黑点，防止真有那种白色的背景，字看不清
                  var darkThemeColor = Color.fromARGB(
                      themeColor.alpha,
                      ((themeColor.red) ~/ 8) * 5,
                      ((themeColor.green) ~/ 8) * 5,
                      ((themeColor.blue) ~/ 8) * 5);

                  return DefaultTextStyle(
                    style: TextStyle(color: Colors.white),
                    child: Container(
                      color: darkThemeColor,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return childrenList[index];
                        },
                        itemCount: childrenList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

/// 头部介绍部分
class _NovelDetailBookIntroHeaderContent extends StatelessWidget {
  final NovelDetailInfo detailInfo;

  const _NovelDetailBookIntroHeaderContent(this.detailInfo, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CachedNetworkImage(
            imageUrl: READER_IMAGE_URL + (detailInfo.cover ?? ''),
            height: 140,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 140,
            child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      detailInfo.title ?? '',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        '作者 : ' + (detailInfo.author ?? ''),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '总章节数 ：${(detailInfo.chaptersCount ?? 0)}',
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                      maxLines: 2,
                    ),
                    Text(
                      '最近更新 ：' + (detailInfo.lastChapter ?? ''),
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Builder(builder: (context) {
                      return Expanded(
                          child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: buildButton(
                                  context: context,
                                  onPressCallback: () {
                                    NovelBookShelfBookInfo bookInfo =
                                        NovelBookShelfBookInfo();
                                    bookInfo.id = detailInfo.id!;
                                    bookInfo.cover = detailInfo.cover!;
                                    bookInfo.title = detailInfo.title!;

                                    Get.find<HomeNovelBookShelfViewModel>()
                                        .addBook(bookInfo);
                                  },
                                  childWidgetBuilder: (context) {
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withAlpha((255 * 0.95).toInt()),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: Text(
                                        '加入书架',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  })),
                          SizedBox(
                            width: 16,
                          ),
                          Flexible(
                              child: buildButton(
                                  context: context,
                                  onPressCallback: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        //动画时间为500毫秒
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return FadeTransition(
                                            //使用渐隐渐入过渡,
                                            opacity: animation,
                                            child: NovelReaderListPage(),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  childWidgetBuilder: (context) {
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withAlpha((255 * 0.95).toInt()),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: Text(
                                        '现在阅读',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  })),
                        ],
                      ));
                    }),
                    // Text(),
                  ],
                )),
          )),
        ],
      ),
    );
  }
}

/// 评分部分
class _NovelDetailBookIntroRatingContent extends StatelessWidget {
  final NovelDetailInfo detailInfo;

  const _NovelDetailBookIntroRatingContent(this.detailInfo, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadiusDirectional.all(
              Radius.circular(_tagRoundConnerRadius))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('评分'),
          SizedBox(
            height: 85,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${detailInfo.rating?.score ?? 0.0}',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '来自${detailInfo.rating?.count ?? 0}位书友',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: (8.29 / 10.0) * 5.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemSize: 10,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    )),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      5,
                      (index) => Container(
                            height: 12,
                            margin: EdgeInsets.all(1),
                            alignment: AlignmentDirectional.centerEnd,
                            child: Row(
                              children: List.filled(
                                  5 - index,
                                  Icon(
                                    Icons.star,
                                    color: Colors.white70,
                                    size: 10,
                                  )),
                            ),
                          )),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        var itemPercent =
                            ((detailInfo.starRatings?[5 - index].count ?? 0) /
                                    (detailInfo.starRatingCount!))
                                .toDouble();
                        var itemWidth = itemPercent * 150;
                        return Container(
                          width: itemWidth,
                          height: 8,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(8))),
                        );
                      }),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// 类别部分
class _NovelDetailTagContent extends StatelessWidget {
  final NovelDetailInfo detailInfo;

  const _NovelDetailTagContent(this.detailInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 30,
      alignment: AlignmentDirectional.center,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              alignment: AlignmentDirectional.center,
              child: Text('所属类别'),
            );
          } else {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(_tagRoundConnerRadius))),
              alignment: AlignmentDirectional.center,
              child: Text('${detailInfo.tags?[index - 1] ?? ''}'),
            );
          }
        },
        itemCount: (detailInfo.tags?.length ?? 0) + 1,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 16,
          );
        },
      ),
    );
  }
}

/// 内容介绍
class _NovelDetailContent extends StatelessWidget {
  final NovelDetailInfo detailInfo;

  const _NovelDetailContent(this.detailInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadiusDirectional.all(
              Radius.circular(_tagRoundConnerRadius))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '小说介绍',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 16,
          ),
          Text(detailInfo.longIntro ?? '')
        ],
      ),
    );
  }
}

class _NovelSimilarRecommendContent extends BaseView<NovelDetailViewModel> {
  final NovelDetailInfo detailInfo;

  _NovelSimilarRecommendContent(this.detailInfo);

  @override
  Widget buildContent(BuildContext context, NovelDetailViewModel viewModel) {
    return ObxValue<RxList<RecommendBooks>>((value) {
      if (value.isEmpty) {
        return SizedBox.shrink();
      } else {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('猜你喜欢'),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 200,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var bookInfo = value[index];
                    return buildButton(
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
                          return Container(
                            width: 120,
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      READER_IMAGE_URL + (bookInfo.cover ?? ''),
                                  height: 150,
                                  fit: BoxFit.fitHeight,
                                ),
                                Text(
                                  '${bookInfo.title}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          );
                        });
                  },
                  itemCount: value.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 6,
                    );
                  },
                ),
              )
            ],
          ),
        );
      }
    }, viewModel.recommendBooks);
  }

  @override
  NovelDetailViewModel buildViewModel() {
    return NovelDetailViewModel();
  }

  @override
  void initState(BaseViewState<NovelDetailViewModel> state) {
    super.initState(state);
    state.viewModel?.queryRecommendBook(detailInfo.id!);
  }

  @override
  // TODO: implement tag
  String? get tag => detailInfo.id;
}
