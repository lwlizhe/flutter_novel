import 'package:flutter_novel/app/novel/helper/helper_db.dart';
import 'package:flutter_novel/app/novel/helper/helper_sp.dart';
import 'package:flutter_novel/app/novel/model/model_novel_cache.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_db.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_net.dart';
import 'package:flutter_novel/base/structure/provider/config_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'api/api_novel.dart';

List<SingleChildWidget> providers = []
  ..addAll(independentServices)
  ..addAll(dependentServices)
  ..addAll(uiConsumableProviders);

/// 静态资源，这样也可以不用写单例了吧
List<SingleChildWidget> independentServices = [
  Provider.value(value: NovelApi()),
  Provider.value(value: DBHelper()),
  Provider.value(value: NovelBookCacheModel()),
  Provider.value(value: SharedPreferenceHelper()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<NovelApi, NovelBookNetModel>(
    update: (context, api, netModel) => NovelBookNetModel(api),
  ),
  ProxyProvider<DBHelper, NovelBookDBModel>(
    update: (context, db, dbModel) => NovelBookDBModel(db),
  ),
  ConfigProvider().getProviderContainer(),
];

List<SingleChildWidget> uiConsumableProviders = [
  ProxyProvider<ConfigProvider, AppNightState>(
    update: (context, configProvider, nightModeConfig) =>
        Provider.of<ConfigProvider>(context, listen: false).nightState,
  ),

];
