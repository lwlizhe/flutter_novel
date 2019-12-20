import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class NovelPersistentCacheManager extends BaseCacheManager {
  static const key = "libCacheNovelData";

  static NovelPersistentCacheManager _instance;

  factory NovelPersistentCacheManager() {
    if (_instance == null) {
      _instance = new NovelPersistentCacheManager._();
    }
    return _instance;
  }

  NovelPersistentCacheManager._() : super(key);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  Future<File> getNovelPersistentCacheFile(String url, {Map<String, String> headers}) async {
    var cacheFile = await getFileFromCache(url);
    if (cacheFile != null) {
      return cacheFile.file;
    }
    try {
      var download = await webHelper.downloadFile(url, authHeaders: headers);
      return download.file;
    } catch (e) {
      return null;
    }
  }
}