import 'package:get/get.dart';
import 'package:test_project/base/model/base_model.dart';

class BaseViewModel<M extends BaseModel> extends GetxController {
  M? model;

  BaseViewModel({M? model});

  String? get tag => null;

  @override
  void onReady() {
    super.onReady();
    model?.init();
  }

  @override
  void onClose() {
    super.onClose();
    model?.dispose();
  }
}
