import 'package:mmkv/mmkv.dart';

const String DBId = 'flutter_novel';

class CommonDB {
  MMKV? _mmkv;

  Future init() async {
    await MMKV.initialize();
    _mmkv = MMKV(DBId);
  }

  void cacheValue(String key, var value) async {
    if (_mmkv == null) {
      await init();
    }

    if (value is String?) {
      _mmkv!.encodeString(key, value);
    } else if (value is bool) {
      _mmkv!.encodeBool(key, value);
    } else if (value is int) {
      _mmkv!.encodeInt(key, value);
    } else if (value is double) {
      _mmkv!.encodeDouble(key, value);
    }
  }

  Future<String?> getCacheString(String key) async {
    if (_mmkv == null) {
      await init();
    }

    return _mmkv!.decodeString(key);
  }

  Future<bool> getCacheBool(String key) async {
    if (_mmkv == null) {
      await init();
    }

    return _mmkv!.decodeBool(key);
  }

  Future<int> getCacheInt(String key) async {
    if (_mmkv == null) {
      await init();
    }

    return _mmkv!.decodeInt(key);
  }

  Future<double> getCacheDouble(String key) async {
    if (_mmkv == null) {
      await init();
    }

    return _mmkv!.decodeDouble(key);
  }
}
