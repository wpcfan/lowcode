import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'custom_exception_interceptor.dart';

/// 自定义的 Dio 实例，用于访问文件接口
/// 该实例会自动添加日志拦截器和错误拦截器
/// 该实例会自动添加 Content-Type 和 Accept 头
/// 该实例会自动将后台返回的 Problem 对象转换为 DioError
class FileClient with DioMixin implements Dio {
  static final FileClient _instance = FileClient._();
  factory FileClient() => _instance;

  FileClient._() {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/admin',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: Map.from({
        /// 文件上传需要使用 multipart/form-data
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      }),
    );
    httpClientAdapter = HttpClientAdapter();
    interceptors.add(PrettyDioLogger());
    interceptors.add(CustomExceptionInterceptor());
  }
}
