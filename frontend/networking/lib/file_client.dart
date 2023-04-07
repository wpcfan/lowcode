import 'package:dio/dio.dart';
import 'package:networking/networking.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
