import 'package:flutter_novel/base/model/base_model.dart';
import 'package:get/get.dart';

class BaseViewModel<M extends BaseModel> extends GetxController {
  M? model;

  BaseViewModel({required this.model});

  String? get tag => null;

  var _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    model?.init();
    isLoading = true;
  }

  @override
  void onClose() {
    super.onClose();
    model?.dispose();
  }
}
