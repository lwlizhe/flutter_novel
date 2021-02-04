import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_novel/app/api/api_novel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class NovelBookCacheModel extends CacheManager {
  static const key = "libCacheNovelData";

  static NovelBookCacheModel _instance;

  factory NovelBookCacheModel() {
    if (_instance == null) {
      _instance = new NovelBookCacheModel._();
    }
    return _instance;
  }

  NovelBookCacheModel._() : super(Config(key));

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  Future<String> getCacheChapterContent(String chapterLink) async {
    File targetFile;
    try{
      targetFile = await getSingleFile(
          NovelApi.QUERY_BOOK_CHAPTER_CONTENT.replaceAll("{link}", chapterLink));
    }catch( ignored){

    }


    if (targetFile == null) {
      return null;
    } else {
      Uint8List bytes = await targetFile.readAsBytes();
      return utf8.decode(bytes, allowMalformed: true);
    }
  }
}
