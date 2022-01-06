import 'package:flutter/material.dart';
import 'package:test_project/base/model/base_model.dart';
import 'package:test_project/base/view/base_view.dart';
import 'package:test_project/base/viewmodel/base_view_model.dart';
import 'package:test_project/home/viewmodel/home_recommend_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<BaseView> tabList = [
    _HomePageRecommendPage(),
    _HomePageCategoryPage(),
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
              Container(
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
              Expanded(
                  child: TabBarView(
                      controller: _tabController, children: tabList)),
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
  HomeRecommendViewModel get viewModel => HomeRecommendViewModel();

  @override
  Widget buildContent(BuildContext context, HomeRecommendViewModel viewModel) {
    return Container(
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}

class _HomePageCategoryPage extends BaseView {
  const _HomePageCategoryPage({Key? key}) : super(key: key);

  @override
  String get title => '类别';

  @override
  BaseViewModel<BaseModel> get viewModel => BaseViewModel();

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
  BaseViewModel<BaseModel> get viewModel => BaseViewModel();

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
  BaseViewModel<BaseModel> get viewModel => BaseViewModel();

  @override
  Widget buildContent(
      BuildContext context, BaseViewModel<BaseModel> viewModel) {
    return Container(
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
