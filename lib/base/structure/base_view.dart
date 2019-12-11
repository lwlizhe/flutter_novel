import 'package:flutter/material.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';
import 'package:provider/provider.dart';

abstract class BaseStatelessView<M extends BaseViewModel>
    extends StatelessWidget {
  final M viewModel;

  const BaseStatelessView({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    M viewModel = buildViewModel(context, false);

    Widget resultWidget;

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

  /// 需要使用viewModel加载数据、或者页面刷新重新配置数据
  void loadData(BuildContext context, M viewModel);

  bool isEnableLoadingView() {
    return false;
  }
}

abstract class BaseStatefulView<M extends BaseViewModel>
    extends StatefulWidget {
  final M viewModel;

  const BaseStatefulView({Key key, this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return buildState();
  }

  BaseStatefulViewState<BaseStatefulView, M> buildState();
}

abstract class BaseStatefulViewState<T extends BaseStatefulView,
    M extends BaseViewModel> extends State<T> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
//    M viewModel = (M is BaseViewModel) ? buildViewModel(context, false) : null;
//    Widget resultWidget = ChangeNotifierProvider<M>.value(value: viewModel,child: buildView(context, viewModel));
//    loadData(context, viewModel);
    Widget resultWidget;
    if (widget.viewModel != null) {
      resultWidget = ChangeNotifierProvider<M>(create: (context) {
        loadData(context, widget.viewModel);
        return widget.viewModel;
      }, child: Consumer<M>(
          builder: (BuildContext context, M viewModel, Widget child) {
        return buildView(context, viewModel);
      }));
    } else {
      loadData(context,null);
      resultWidget = buildView(context, null);
    }

    return resultWidget;
  }

  Widget buildView(BuildContext context, M viewModel);

  /// 初始化数据
  void initData();

  /// 需要使用viewModel加载数据、或者页面刷新重新配置数据
  void loadData(BuildContext context, M viewModel);
}
