/// 这个文件定义了关于页面布局和区块相关的枚举类型

/// 页面类型
/// - home: 首页
/// - category: 分类页
/// - about: 关于页
enum PageType {
  home('home'),
  category('category'),
  about('about');

  final String value;

  const PageType(this.value);
}

/// 平台类型
/// - app: App 包括 iOS 和 Android
/// - web: Web 包括移动网页，暂时不包括 PC 端网页
enum Platform {
  app('App'),
  web('Web');

  final String value;

  const Platform(this.value);
}

/// 页面状态
/// - draft: 草稿
/// - published: 已发布
/// - archived: 已归档，过期后会自动归档
enum PageStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived');

  final String value;

  const PageStatus(this.value);
}

/// 页面区块类型
/// - pinnedHeader: 固定头部
/// - slider: 轮播图
/// - imageRow: 图片行
/// - productRow: 商品行
/// - waterfall: 瀑布流
enum PageBlockType {
  pinnedHeader('pinned_header'),
  slider('slider'),
  imageRow('image_row'),
  productRow('product_row'),
  waterfall('waterfall'),
  ranking('ranking'),
  unknown('unknown');

  final String value;
  const PageBlockType(this.value);
}

/// 链接类型
/// - url: 网页链接
/// - deepLink: 深度链接
enum LinkType {
  url('url'),
  route('route'),
  deepLink('deep_link'),
  ;

  final String value;
  const LinkType(this.value);
}
