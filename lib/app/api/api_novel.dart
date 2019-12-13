import 'package:flutter_novel/app/novel/entity/entity_book_detail.dart';
import 'package:flutter_novel/base/http/manager_net_request.dart';

class NovelApi {
  static const String BASE_URL = "http://api.zhuishushenqi.com/";

  static const String QUERY_AUTO_COMPLETE_QUERY_KEYWORD =
      BASE_URL + "book/auto-complete?query=";
  static const String QUERY_HOT_QUERY_KEYWORD = BASE_URL + "book/hot-word";
  static const String QUERY_BOOK_DETAIL_INFO = BASE_URL + "book/";

  var client = NetRequestManager.instance;

  Future<BaseResponse<List<String>>> getSearchWord(String keyWord) async {
    var response;
    BaseResponse<List<String>> result = BaseResponse();
    List<String> resultData = [];
    try {
      response =
          await client.getRequest(QUERY_AUTO_COMPLETE_QUERY_KEYWORD + keyWord);
      bool isOk = response?.data["ok"];
      if (isOk) {
        for (var data in response.data["keywords"]) {
          resultData.add(data);
        }
      }
      result.isSuccess = isOk;
      result.data = resultData;
    } catch (e) {
      print("$e");
      result.isSuccess = false;
    }
    return result;
  }

  Future<BaseResponse<List<String>>> getHotSearchWord() async {
    var response;
    BaseResponse<List<String>> result = BaseResponse();

    List<String> resultData = [];
    try {
      response = await client.getRequest(QUERY_HOT_QUERY_KEYWORD);
      for (var data in response.data["hotWords"]) {
        resultData.add(data);
      }
      result.isSuccess = true;
      result.data = resultData;
    } catch (e) {
      print("$e");
    }
    return result;
  }

  Future<BaseResponse<NovelDetailInfo>> getNovelDetailInfo(
      String bookId) async {
    BaseResponse<NovelDetailInfo> result = BaseResponse()..isSuccess = false;
    try {
      var response = await client.getRequest(QUERY_BOOK_DETAIL_INFO + bookId);
      result.isSuccess = true;
      result.data = NovelDetailInfo.fromJson(response.data);
    } catch (e) {
      print("$e");
    }
    return result;
  }
}

class BaseResponse<T> {
  bool isSuccess;
  T data;
}
