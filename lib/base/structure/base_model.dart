import 'package:flutter/material.dart';
import 'package:flutter_novel/base/sp/manager_sp.dart';
import 'package:meta/meta.dart';

/// model 处理数据库、网络请求等返回的数据，进行数据转换、存储等
abstract class BaseModel{

  @protected
  SharedPreferenceManager mSPManager = SharedPreferenceManager.instance;

  bool isDisposed=false;

}