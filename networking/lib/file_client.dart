import 'package:dio/dio.dart';
import 'package:networking/networking.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class FileClient {
  static Dio getInstance() {
    final options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/admin',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: Map.from({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      }),
    );
    final dio = Dio(options);
    dio.interceptors.add(PrettyDioLogger());
    dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        if (e.response?.data != null) {
          final problem = Problem.fromJson(e.response?.data);
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
    return dio;
  }
}
