import 'package:flutter_novel/base/model/base_model.dart';
import 'package:get/get.dart';

class BaseViewModel<M extends BaseModel> extends GetxController {
  M? model;

  BaseViewModel({this.model});

  String? get tag => null;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    model?.init();
  }

  @override
  void onClose() {
    super.onClose();
    model?.dispose();
  }
}
