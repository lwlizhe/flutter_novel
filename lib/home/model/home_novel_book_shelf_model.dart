import 'dart:convert';

import 'package:flutter_novel/base/db/common_db.dart';
import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/entity/novel/entity_book_shelf_info.dart';
import 'package:get/get.dart';

const CACHE_KEY_BOOK_SHELF = 'cache_key_book_shelf';

class HomeNovelBookShelfModel extends BaseModel {
  CommonDB? db;

  @override
  void init() {
    db = Get.find<CommonDB>();
  }

  Future<NovelBookShelfInfo?> getBookShelfInfo() async {
    var bookShelfJson = await db?.getCacheString(CACHE_KEY_BOOK_SHELF);
    if (bookShelfJson != null && bookShelfJson.isNotEmpty) {
      return NovelBookShelfInfo.fromJson(jsonDecode(bookShelfJson));
    } else {
      return null;
    }
  }

  void cacheBookShelfInfo(NovelBookShelfInfo info) {
    db?.cacheValue(CACHE_KEY_BOOK_SHELF, jsonEncode(info.toJson()));
  }
}
