import 'package:flutter/material.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';
import 'package:provider/provider.dart';

abstract class BaseStatelessView<M extends BaseViewModel>
    extends StatelessWidget {

  const BaseStatelessView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    M viewModel = buildViewModel(context, false);

    Widget resultWidget;

    M viewModel=buildViewModel(context);

    if (viewModel != null) {
      resultWidget = ChangeNotifierProvider<M>(create: (context) {
        loadData(context, viewModel);
        return viewModel;
      }, child: Consumer<M>(
          builder: (BuildContext context, M viewModel, Widget child) {
        return buildView(context, viewModel);
      }));
    } else {
      loadData(context, null);
      resultWidget = buildView(context, null);
    }
    return resultWidget;
  }

  Widget buildView(BuildContext context, M viewModel);

  /// 为什么buildViewModel方法要放以一个抽象自己构建出来？直接让父Widget构建出来传过来不更好么？
  /// 因为我发现像tabLayout会触发viewModel的dispose方法……但是如果以父widget传入，那么viewModel是final的，自然会触发已经dispose的provider不能再次绑定的错误
  M buildViewModel(BuildContext context);

  /// 需要使用viewModel加载数据、或者页面刷新重新配置数据
  void loadData(BuildContext context, M viewModel);

  bool isEnableLoadingView() {
    return false;
  }
}

abstract class BaseStatefulView<M extends BaseViewModel>
    extends StatefulWidget {

  const BaseStatefulView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return buildState();
  }

  BaseStatefulViewState<BaseStatefulView, M> buildState();
}

abstract class BaseStatefulViewState<T extends BaseStatefulView,
    M extends BaseViewModel> extends State<T> {

   M viewModel;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {

    viewModel=buildViewModel(context);

    Widget resultWidget;
    if (viewModel != null&&isBindViewModel()) {
      resultWidget = ChangeNotifierProvider<M>(create: (context) {
        loadData(context, viewModel);
        return viewModel;
      }, child: Consumer<M>(
          builder: (BuildContext context, M viewModel, Widget child) {
        return buildView(context, viewModel);
      }));
    } else {
      loadData(context,viewModel);
      resultWidget = buildView(context, viewModel);
    }

    return resultWidget;
  }

  Widget buildView(BuildContext context, M viewModel);

  /// 初始化数据
  void initData();

   M buildViewModel(BuildContext context);

   /// 需要使用viewModel加载数据、或者页面刷新重新配置数据
  void loadData(BuildContext context, M viewModel);

  bool isBindViewModel(){
    return true;
  }

}