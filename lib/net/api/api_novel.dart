import 'package:flutter_novel/base/http/manager_net_request.dart';
import 'package:flutter_novel/entity/novel/entity_novel_book_info.dart';
import 'package:html/parser.dart';

abstract class BaseNovelApi {
  var client = NetRequestManager();

  Future<NovelBookDetailInfo> getNovelInfo(Uri requestUri);

  Future<List<NovelBookDetailInfo>> queryNovel(String keyWord);

  Future<List<NovelChapterInfo>> getChapterList(String chapterSourceUrl);

  Future<String> getChapterContent(Uri requestUri);
}

/// 追书神器API
@Deprecated('找不到可用源，我放弃了')
class ZSSQNovelApi extends BaseNovelApi {
  @override
  Future<String> getChapterContent(Uri requestUri) {
    // TODO: implement getChapterContent
    throw UnimplementedError();
  }

  @override
  Future<List<NovelChapterInfo>> getChapterList(String chapterUrl) {
    // TODO: implement getChapterList
    throw UnimplementedError();
  }

  @override
  Future<NovelBookDetailInfo> getNovelInfo(Uri requestUri) {
    // TODO: implement getNovelInfo
    throw UnimplementedError();
  }

  @override
  Future<List<NovelBookDetailInfo>> queryNovel(String keyWord) {
    // TODO: implement queryNovel
    throw UnimplementedError();
  }
}

/// 笔趣阁API
class BQGNovelApi extends BaseNovelApi {
  @override
  Future<String> getChapterContent(Uri requestUri) {
    // TODO: implement getChapterContent
    throw UnimplementedError();
  }

  @override
  Future<List<NovelChapterInfo>> getChapterList(String chapterUrl) {
    // TODO: implement getChapterList
    throw UnimplementedError();
  }

  @override
  Future<NovelBookDetailInfo> getNovelInfo(Uri requestUri) {
    // TODO: implement getNovelInfo
    throw UnimplementedError();
  }

  @override
  Future<List<NovelBookDetailInfo>> queryNovel(String keyWord) {
    // TODO: implement queryNovel
    throw UnimplementedError();
  }
}

/// wap.xiashucom.com
class XiaShuWangApi extends BaseNovelApi {
  final String hostUrl = 'https://www.xiashucom.com';

  @override
  Future<String> getChapterContent(Uri requestUri) async {
    return "";
  }

  @override
  Future<List<NovelChapterInfo>> getChapterList(String chapterSourceUrl) async {
    var requestResult = await client.getRequest(chapterSourceUrl);

    List<NovelChapterInfo> result = [];

    String getChapterUrl(String detailPageHtmlString) {
      var data = parse(detailPageHtmlString);

      var chapterHrefButtonList = data
          .getElementById('conn')
          ?.querySelector('#newlist')
          ?.getElementsByClassName('newrap')[0]
          .getElementsByTagName('a');

      if (chapterHrefButtonList?.isNotEmpty ?? false) {
        for (var button in chapterHrefButtonList!) {
          if (button.text == '打开完整目录列表') {
            return hostUrl + button.attributes['href'].toString();
          }
        }
      }

      return '';
    }

    if (requestResult.data != null) {
      var chapterUrl = getChapterUrl(requestResult.data.toString());

      if (chapterUrl.isNotEmpty) {
        var chapterData = (await client.getRequest(chapterUrl)).data;

        if (chapterData != null) {
          var chapterPageHtmlString = parse(chapterData.toString());

          var chapterHrefList = chapterPageHtmlString
              .getElementById('main')
              ?.getElementsByClassName('mulu')[0]
              .getElementsByTagName('dl')[0]
              .getElementsByTagName('dd');

          if (chapterHrefList != null && chapterHrefList.isNotEmpty) {
            var index = 0;
            for (var chapterItem in chapterHrefList) {
              var item = chapterItem.getElementsByTagName('a')[0];
              result.add(NovelChapterInfo()
                ..chapterTitle = item.text
                ..chapterUri =
                    Uri.parse(hostUrl + item.attributes['href'].toString())
                ..chapterIndex = index);
              index++;
            }
          }
        }
      }
    }

    return result;
  }

  @override
  Future<NovelBookDetailInfo> getNovelInfo(Uri requestUri) async {
    var queryList = await queryNovel('绝世剑神');

    NovelBookDetailInfo? target;
    if (queryList.isNotEmpty) {
      for (var novel in queryList) {
        if ('黑暗火龙' == novel.bookAuthor) {
          target = novel;
          break;
        }
      }

      if (null != target?.detailUrl) {
        target!.chapterList = await getChapterList(target.detailUrl!);
      }

      return target!;
    }

    return NovelBookDetailInfo();
  }

  @override
  Future<List<NovelBookDetailInfo>> queryNovel(String keyWord) async {
    var result = <NovelBookDetailInfo>[];

    var queryUrl = hostUrl +
        '/search/result.html?searchkey=${Uri.encodeComponent(keyWord)}';

    var requestResult = await client.getRequest(queryUrl);
    if (requestResult.data != null) {
      var data = parse(requestResult.data.toString());
      var bookList = data
          .getElementsByClassName('booklists')[0]
          .getElementsByTagName('tbody')[0]
          .getElementsByTagName('tr');

      if (bookList.isNotEmpty) {
        for (var item in bookList) {
          var td = item.getElementsByTagName('td');
          var itemInfoList = td[1].getElementsByTagName('a');
          result.add(NovelBookDetailInfo()
            ..bookAuthor = td[2].text
            ..bookTitle = itemInfoList[1].text
            ..lastChapterTitle = itemInfoList[2].text
            ..detailUrl =
                hostUrl + itemInfoList[1].attributes['href'].toString());
        }
      }
    }
    return result;
  }
}
