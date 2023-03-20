import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'problem.dart';

class AdminClient {
  static Dio getInstance() {
    final options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/admin',
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );
    final dio = Dio(options);
    _setupInterceptors(dio);
    return dio;
  }

  static void _setupInterceptors(Dio dio) {
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
  }

  AdminClient._();
}
