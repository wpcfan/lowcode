import 'package:dio/dio.dart';
import 'package:networking/custom_exception_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
    interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));

    /// 添加错误拦截器
    interceptors.add(CustomExceptionInterceptor());
  }
}
