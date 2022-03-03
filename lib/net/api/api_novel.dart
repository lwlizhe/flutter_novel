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
  final String hostUrl = 'https://wap.xiashucom.com';

  @override
  Future<String> getChapterContent(Uri requestUri) async {
    var requestResult = await client.getRequest(requestUri.toString());

    if (requestResult.data != null) {
      var data = parse(requestResult.data.toString());
      var paragraphList =
          data.getElementById('pt-pop')?.getElementsByTagName('p');
      if (null != paragraphList && (paragraphList.isNotEmpty)) {
        String result = '';

        for (var paragraph in paragraphList) {
          result += paragraph.text + '\n';
        }

        return result;
      }
    }

    return "";
  }

  @override
  Future<List<NovelChapterInfo>> getChapterList(String chapterSourceUrl) async {
    var requestResult = await client.getRequest(chapterSourceUrl);

    List<NovelChapterInfo> result = [];

    String getChapterUrl(String detailPageHtmlString) {
      var data = parse(detailPageHtmlString);

      var targetContainer = data.getElementsByClassName('loading');

      if (targetContainer.isNotEmpty) {
        return hostUrl +
            targetContainer[0].nodes.first.attributes['href'].toString();
      }

      return '';
    }

    if (requestResult.data != null) {
      var chapterUrl = getChapterUrl(requestResult.data.toString());

      if (chapterUrl.isNotEmpty) {
        var chapterData = (await client.getRequest(chapterUrl)).data;

        if (chapterData != null) {
          var chapterPageHtmlString = parse(chapterData.toString());

          var chapterHrefList =
              chapterPageHtmlString.getElementsByClassName('cataloglist');

          if (chapterHrefList.isNotEmpty) {
            var index = 0;
            var chapterList = chapterHrefList[0].nodes;
            for (var chapterItem in chapterList) {
              if (chapterItem.nodes.isNotEmpty) {
                var item = chapterItem.nodes.first;
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
      var bookList = data.getElementById('ulist')?.getElementsByTagName('li');
      // var bookList = data
      //     .getElementsByClassName('content')[0]
      //     .getElementsByTagName('tbody')[0]
      //     .getElementsByTagName('tr');

      if (null != bookList && bookList.isNotEmpty) {
        for (var item in bookList) {
          var href = item.getElementsByTagName('a');
          if (null != href && href.isNotEmpty) {
            var dataList = href[0].getElementsByTagName('p');
            var author = dataList[1].nodes.last.text?.replaceAll('作者：', '');
            result.add(NovelBookDetailInfo()
              ..bookAuthor = author
              ..bookTitle = dataList[0].text
              ..detailUrl = hostUrl + href[0].attributes['href'].toString());
          }
        }
      }
    }
    return result;
  }
}
