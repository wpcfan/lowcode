import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'problem.dart';

/// 自定义的 Dio 实例，用于访问后台管理接口
/// 该实例会自动添加日志拦截器和错误拦截器
/// 该实例会自动添加 Content-Type 和 Accept 头
/// 该实例会自动将后台返回的 Problem 对象转换为 DioError
///
/// DioMixin 是一个 Mixin，它会自动实现 Dio 的所有方法
/// Mixin 的好处是可以在不改变原有类的情况下，为类添加新的功能
/// 具体的实现原理可以参考：https://dart.dev/guides/language/language-tour#mixins
class AdminClient with DioMixin implements Dio {
  /// 单例模式，禁止外部创建实例
  static final AdminClient _instance = AdminClient._();

  /// 工厂构造函数，返回单例
  factory AdminClient() => _instance;

  /// 私有构造函数，禁止外部创建实例
  AdminClient._() {
    /// 配置参数
    options = BaseOptions(
      /// 后台管理接口的基础 URL
      baseUrl: 'http://localhost:8080/api/v1/admin',

      /// 添加 Content-Type 和 Accept 头
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );

    /// 添加 HttpClientAdapter, 用于发送 HTTP 请求
    httpClientAdapter = HttpClientAdapter();

    /// 添加日志拦截器
    interceptors.add(PrettyDioLogger());

    /// 添加错误拦截器
    /// InterceptorsWrapper 是一个拦截器包装器，它可以包装多个拦截器
    /// 可以处理 onError, onRequest, onResponse 事件
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
