import 'package:flutter/material.dart';
import 'package:flutter_novel/base/structure/provider/base_provider.dart';
import 'package:flutter_novel/base/widget/view_common_loading.dart';
import 'package:provider/provider.dart';

enum AppNightState {
  STATE_NIGHT,
  STATE_DAY,
}

class ConfigProvider extends BaseProvider {

  AppNightState nightState = AppNightState.STATE_NIGHT;

  @override
  Widget getProviderContainer() {
    return ChangeNotifierProvider(builder: (BuildContext context) {
      return ConfigProvider();
    });
  }
}
