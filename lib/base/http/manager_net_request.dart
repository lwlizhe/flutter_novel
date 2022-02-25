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
    _dio?.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      // Do something with response error
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));
  }

  Future<Response<T>> getRequest<T>(
    String url, {
    Map<String, String>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    Uri uri = Uri();
    Uri tempUri = Uri.parse(url);
    var parameters = <String, String>{}
      ..addAll(tempUri.queryParameters)
      ..addAll(queryParameters ?? {});
    if (tempUri.scheme == 'https') {
      uri = Uri.https(tempUri.authority, tempUri.path, parameters);
    } else if (tempUri.scheme == 'http') {
      uri = Uri.http(tempUri.authority, tempUri.path, parameters);
    }

    var response = await _dio!.getUri<T>(uri,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
    return response;
  }

  Dio? get client => _dio;
}

abstract class RequestCallback<T> {
  void onSuccess(T requestData);

  void onFailed(Exception e);
}
