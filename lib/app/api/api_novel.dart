import 'package:flutter_novel/base/http/manager_net_request.dart';

class NovelApi {
  static const String DMZJ_REFERER_URL = "http://images.dmzj.com/";

  static const String BASE_URL = "https://v3api.dmzj.com/novel/";

  static const String HOME_RECOMMEND = BASE_URL + "recommend.json";

  var client = NetRequestManager.instance;

}
