import 'package:dio/dio.dart';
import 'package:models/models.dart';

class CustomExceptionInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final problem = Problem.fromJson(err.response?.data);
      throw CustomException(problem.title ?? err.message ?? '未知错误');
      // Add more status codes and custom exceptions as needed
    }
    super.onError(err, handler);
  }
}
