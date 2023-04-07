import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'problem.dart';

class AdminClient with DioMixin implements Dio {
  static final AdminClient _instance = AdminClient._();
  factory AdminClient() => _instance;

  AdminClient._() {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/admin',
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );
    httpClientAdapter = HttpClientAdapter();
    interceptors.add(PrettyDioLogger());
    interceptors.add(InterceptorsWrapper(
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
}
