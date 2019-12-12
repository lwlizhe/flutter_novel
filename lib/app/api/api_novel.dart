import 'package:flutter_novel/base/http/manager_net_request.dart';

class NovelApi {
  static const String DMZJ_REFERER_URL = "http://images.dmzj.com/";

  static const String BASE_URL = "https://v3api.dmzj.com/novel/";

  static const String HOME_RECOMMEND = BASE_URL + "recommend.json";

  static const String QUERY_AUTO_COMPLETE_KEYWORD =
      "http://api.zhuishushenqi.com/book/auto-complete?query=";

  var client = NetRequestManager.instance;

  Future<List<String>> getSearchWord(String keyWord) async {
    var response;
    List<String> result = [];
    response =
        await client.getRequest(url: QUERY_AUTO_COMPLETE_KEYWORD + keyWord);
    bool isOk = response.data["ok"];
    if (isOk) {
      for (var data in response.data["keywords"]) {
        result.add(data);
      }
    }
    return result;
  }
}
