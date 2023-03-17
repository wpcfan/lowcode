import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// 全局缓存配置
final cacheOptions = CacheOptions(
  // 必选参数，默认缓存存储器
  store: MemCacheStore(),

  /// 所有下面的参数都是可选的

  /// 缓存策略，默认为 CachePolicy.request
  /// - CachePolicy.request: 如果缓存可用并且未过期，则使用缓存，否则从服务器获取响应并缓存
  /// - CachePolicy.forceCache: 当 Server 没有缓存的响应头时，强制使用缓存，也就是缓存每次成功的 GET 请求
  /// - CachePolicy.refresh: 不论缓存是否可用，都从服务器获取响应并根据响应头缓存
  /// - CachePolicy.refreshForceCache: 无论 Server 是否有缓存响应头，都从服务器获取响应并缓存
  /// - CachePolicy.noCache: 不使用缓存，每次都从服务器获取响应并根据响应头缓存
  policy: CachePolicy.forceCache,

  /// 例外状态码，当请求失败时，如果状态码在此列表中，则不使用缓存
  hitCacheOnErrorExcept: [401, 403],

  /// 覆盖 HTTP 响应头中的 max-age 字段，用于指定缓存的有效期
  /// 默认为 null，表示使用 HTTP 响应头中的 max-age 字段
  maxStale: const Duration(minutes: 10),

  /// 缓存优先级，默认为 CachePriority.normal
  priority: CachePriority.normal,

  /// 加密器，默认为 null，表示不加密
  cipher: null,

  /// 缓存键生成器，默认为 CacheOptions.defaultCacheKeyBuilder
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,

  /// 是否允许缓存 Post 请求，默认为 false
  /// 当设置为 true 时，建议改写 keyBuilder，以避免缓存多个不同的 POST 请求
  allowPostMethod: false,
);
