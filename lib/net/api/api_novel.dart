abstract class BaseNovelApi {
  dynamic getNovelInfo();
  List getChapterList();
  dynamic getChapterInfo();
  String getChapterContent();
}

/// 追书神器API
@Deprecated('找不到可用源，我放弃了')
class ZSSQNovelApi extends BaseNovelApi {
  @override
  String getChapterContent() {
    // TODO: implement getChapterContent
    throw UnimplementedError();
  }

  @override
  getChapterInfo() {
    // TODO: implement getChapterInfo
    throw UnimplementedError();
  }

  @override
  List getChapterList() {
    // TODO: implement getChapterList
    throw UnimplementedError();
  }

  @override
  getNovelInfo() {
    // TODO: implement getNovelInfo
    throw UnimplementedError();
  }
}

/// 笔趣阁API
class BQGNovelApi extends BaseNovelApi {
  @override
  String getChapterContent() {
    // TODO: implement getChapterContent
    throw UnimplementedError();
  }

  @override
  getChapterInfo() {
    // TODO: implement getChapterInfo
    throw UnimplementedError();
  }

  @override
  List getChapterList() {
    // TODO: implement getChapterList
    throw UnimplementedError();
  }

  @override
  getNovelInfo() {
    // TODO: implement getNovelInfo
    throw UnimplementedError();
  }
}
