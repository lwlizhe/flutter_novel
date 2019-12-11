import 'package:flutter/material.dart';
import 'package:flutter_novel/base/structure/provider/state_provider.dart';
import 'package:provider/provider.dart';

import 'base_provider.dart';

class APPInfoProvider with ChangeNotifier {

  List<BaseProvider> _currentProviders = [PageStateProvider()];

  static APPInfoProvider get instance => _getInstance();

  // 单例公开访问点
  factory APPInfoProvider() => _getInstance();

  // 静态私有成员，没有初始化
  static APPInfoProvider _instance = APPInfoProvider._();

  // 私有构造函数
  APPInfoProvider._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static APPInfoProvider _getInstance() {
    _instance ??= APPInfoProvider._();
    return _instance;
  }

  /// 如果需要全局的监听，或者跨页面的消息传递，需要在这里注册
  /// 注意一点，添加之后会触发整个APP的刷新，所以会触发initData，注意不要在initData中改变全局属性配置，否则又会触发APP刷新，进而导致无限循环。
  /// 推荐还是直接在代码中写到这里，这里是备选方案。
  void addGlobalProvider(BaseProvider provider) {
    _currentProviders.add(provider);
    notifyListeners();
  }

  List<SingleChildCloneableWidget> getProvidersList(BuildContext context) {
    List<SingleChildCloneableWidget> providers = [];

    for (BaseProvider currentProvider in _currentProviders) {
      providers.add(currentProvider.getProviderContainer());
    }

    providers.add(ChangeNotifierProvider.value(value: APPInfoProvider()));
    providers.add(Provider.value(value: 50));

    return providers;
  }
}
