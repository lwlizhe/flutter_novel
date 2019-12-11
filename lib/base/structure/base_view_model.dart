import 'package:flutter/material.dart';
import 'package:flutter_novel/base/http/manager_net_request.dart';
import 'package:flutter_novel/base/sp/manager_sp.dart';
import 'package:flutter_novel/base/structure/provider/base_provider.dart';
import 'package:meta/meta.dart';

/// Todo:通用性的开关数据都弄过来？我想想都有哪些：(1)网络状态;(2)APP状态，像夜间模式这种;(3)用户信息;(4)全局广播？
abstract class BaseViewModel extends BaseProvider{

  LoadingStateEnum isLoading=LoadingStateEnum.IDLE;

  bool isDisposed=false;

  @protected
  void refreshRequestState(LoadingStateEnum state){
    isLoading=state;
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed=true;
  }
}

enum LoadingStateEnum { LOADING, IDLE, ERROR }