import 'package:flutter_novel/base/structure/provider/config_provider.dart';
import 'package:provider/provider.dart';

import 'api/api_novel.dart';

List<SingleChildCloneableWidget> providers = []
  ..addAll(independentServices)
  ..addAll(dependentServices)
  ..addAll(uiConsumableProviders);

/// 静态资源
List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: NovelApi()),
];

List<SingleChildCloneableWidget> dependentServices = [
//  ProxyProvider<NovelApi, NovelModel>(
//    update: (context, api, authenticationService) => NovelModel(api: api),
//  ),这里放用户信息用的，非全局的model不放这
  ConfigProvider().getProviderContainer(),
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
  ProxyProvider<ConfigProvider, AppNightState>(
    update: (context, configProvider, nightModeConfig) =>
        Provider.of<ConfigProvider>(context, listen: false).nightState,
  ),

];
