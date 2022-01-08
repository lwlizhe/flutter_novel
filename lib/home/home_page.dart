import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_project/base/model/base_model.dart';
import 'package:test_project/base/util/safety_widget.dart';
import 'package:test_project/base/view/base_view.dart';
import 'package:test_project/base/viewmodel/base_view_model.dart';
import 'package:test_project/home/viewmodel/home_recommend_view_model.dart';
import 'package:test_project/widget/planet/planet_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, SafetyState {
  TabController? _tabController;
  List<BaseView> tabList = [
    _HomePageRecommendPage(),
    _HomePagePostPage(),
    _HomePageBookCasePage(),
    _HomePageMyPage()
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: tabList.length, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: TabBarView(
                      controller: _tabController, children: tabList)),
              Container(
                color: Colors.black26,
                child: TabBar(
                  tabs: tabList
                      .map((e) => Text(
                            e.title,
                            style: TextStyle(color: Colors.blue),
                          ))
                      .toList(),
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePageRecommendPage extends BaseView<HomeRecommendViewModel> {
  const _HomePageRecommendPage({Key? key}) : super(key: key);

  @override
  String get title => '推荐';

  @override
  Widget buildContent(BuildContext context, HomeRecommendViewModel viewModel) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            'img/bg_home_recommend.webp',
            fit: BoxFit.fitHeight,
          )),
          Center(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Obx(() {
                if (viewModel.recommendNovels.isEmpty) {
                  return Text('loading');
                } else {
                  return PlanetWidget(
                    children: viewModel.recommendNovels
                        .map((element) => GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: 'Item $element clicked');
                              },
                              child: Text(
                                element.title ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  );
                }
              }),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState(BaseViewState<HomeRecommendViewModel> state) {
    super.initState(state);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      state.viewModel?.getNovelByCategoriesTag();
    });
  }

  @override
  void dispose(BaseViewState<HomeRecommendViewModel> state) {
    super.dispose(state);
  }

  @override
  void didChangeDependencies(BaseViewState<HomeRecommendViewModel> state) {
    super.didChangeDependencies(state);
  }

  @override
  void didUpdateWidget(BaseView<BaseViewModel<BaseModel>> oldWidget,
      BaseViewState<HomeRecommendViewModel> state) {
    super.didUpdateWidget(oldWidget, state);
  }

  @override
  HomeRecommendViewModel buildViewModel() {
    return HomeRecommendViewModel();
  }
}

class _HomePagePostPage extends BaseView {
  const _HomePagePostPage({Key? key}) : super(key: key);

  @override
  String get title => '帖子';

  @override
  BaseViewModel buildViewModel() {
    return BaseViewModel();
  }

  @override
  Widget buildContent(
      BuildContext context, BaseViewModel<BaseModel> viewModel) {
    return Container(
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}

class _HomePageBookCasePage extends BaseView {
  const _HomePageBookCasePage({Key? key}) : super(key: key);

  @override
  String get title => '书架';

  @override
  BaseViewModel buildViewModel() {
    return BaseViewModel();
  }

  @override
  Widget buildContent(
      BuildContext context, BaseViewModel<BaseModel> viewModel) {
    return Container(
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}

class _HomePageMyPage extends BaseView {
  const _HomePageMyPage({Key? key}) : super(key: key);

  @override
  String get title => '我的';

  @override
  BaseViewModel buildViewModel() {
    return BaseViewModel();
  }

  @override
  Widget buildContent(
      BuildContext context, BaseViewModel<BaseModel> viewModel) {
    return Container(
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
