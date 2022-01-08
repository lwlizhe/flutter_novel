import 'package:get/get.dart';
import 'package:test_project/base/model/base_model.dart';

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
