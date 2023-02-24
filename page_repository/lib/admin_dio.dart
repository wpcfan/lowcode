import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AdminDio with DioMixin implements Dio {
  AdminDio._([BaseOptions? options]) {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/admin',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );

    this.options = options;
    interceptors.add(PrettyDioLogger());
    interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        if (e.statusCode != 200 && e.data != null) {
          final problem = Problem.fromJson(e.data);
          return handler.reject(DioError(
            requestOptions: e.requestOptions,
            error: problem,
            type: DioErrorType.badResponse,
            message: problem.title,
          ));
        }
        return handler.next(e);
      },
    ));
    httpClientAdapter = BrowserHttpClientAdapter();
  }

  static Dio getInstance() => AdminDio._();
}
