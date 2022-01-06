import 'package:dio/dio.dart';

class NetRequestManager {
  static final NetRequestManager _instance = NetRequestManager._internal();

  NetRequestManager._internal() {
    _init();
  }

  factory NetRequestManager() => _instance;

  Dio? _dio;

  void _init() {
    _dio = Dio(new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 100000,
    ));
  }

  Future<Response<T>> getRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio!.get<T>(url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
    return response;
  }
}

abstract class RequestCallback<T> {
  void onSuccess(T requestData);

  void onFailed(Exception e);
}
