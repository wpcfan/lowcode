import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

/// AppDio
/// 为 App 定制的 Dio 实例
/// 用于访问 App 的后端接口
/// 该类继承自 DioMixin，而不是直接继承自 Dio
/// 这是因为 DioMixin 中已经实现了 Dio 的大部分方法
/// 所以，我们只需要实现 DioMixin 中没有实现的方法即可
/// 这样做的好处是，如果 Dio 中新增了方法，那么我们只需要实现 DioMixin 中的方法即可
/// 而不需要修改 AppDio 类
///
/// options 是 Dio 的配置项
/// 通过 options 可以配置 Dio 的 baseUrl、超时时间等
///
/// interceptors 是拦截器列表
/// 通过 interceptors 可以添加拦截器
/// 我们这里添加了两个拦截器
/// 一个是 PrettyDioLogger，用于打印请求日志
/// 一个是 InterceptorsWrapper，用于添加请求头，我们这里添加了 User-Agent Client Hints
/// 这是因为默认情况下，dart 的 `User-Agent` 是 `Dart/2.xx (dart:io)` 这样的
/// 但我们需要平台和版本信息，所以我们需要添加 User-Agent Client Hints
///
/// httpClientAdapter 是 HttpClient 适配器
/// 通过 httpClientAdapter 可以配置 HttpClient 的实现
///
/// `AppDio._([BaseOptions? options])` 是一个命名构造函数
/// 通过命名构造函数，我们可以为构造函数指定参数名。而 `_` 表示该构造函数是私有的
/// 外部无法直接调用该构造函数，只能通过 `AppDio.getInstance()` 来调用
/// 这样的工厂方法，可以让我们在调用时，不需要传入任何参数
class AppDio with DioMixin implements Dio {
  AppDio._([BaseOptions? options]) {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/app',
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
      onRequest: (options, handler) async {
        debugPrint('AppDio.onRequest(${options.uri})');
        options.headers.addAll(await userAgentClientHintsHeader());
        return handler.next(options);
      },
    ));
    httpClientAdapter = IOHttpClientAdapter();
  }

  static Dio getInstance() => AppDio._();
}
