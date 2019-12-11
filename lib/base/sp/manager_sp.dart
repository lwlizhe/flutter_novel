import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  // 工厂模式
  factory SharedPreferenceManager() => _getInstance();

  static SharedPreferenceManager get instance => _getInstance();
  static SharedPreferenceManager _instance;

  SharedPreferences prefs;

  SharedPreferenceManager._internal() {
    // 初始化
    _init();
  }

  static SharedPreferenceManager _getInstance() {
    if (_instance == null) {
      _instance = new SharedPreferenceManager._internal();
    }
    return _instance;
  }

  void _init() {
    SharedPreferences.getInstance().then((data) {
      prefs = data;
    });
  }

  Future<SharedPreferences> getSP() async {
    return prefs ??= await SharedPreferences.getInstance();
  }
}
