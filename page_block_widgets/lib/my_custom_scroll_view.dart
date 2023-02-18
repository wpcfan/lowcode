import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 自定义的 CustomScrollView
/// 1. 支持下拉刷新
/// 2. 支持上拉加载更多
/// 3. 支持自定义 SliverAppBar
class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({
    super.key,
    required this.slivers,
    required this.onRefresh,
    this.onLoadMore,
    this.sliverAppBar,
    this.decoration,
    this.hasMore = false,
    this.loadMoreWidget = const CupertinoActivityIndicator(),

    /// 要注意，如果我们的 CustomScrollView 的外层不是 Scaffold，那么
    /// 在这个空间如果要使用文本，会发现文本下方有两条黄线，这是因为 Text 默认
    /// 是需要外层有 DefaultTextStyle 的，而 Scaffold 会自动包裹一个
    /// 但如果没有 Scaffold，那么就需要我们自己手动包裹一个
    this.pullToRefreshWidget = const DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Text('下拉刷新'),
    ),
    this.releaseToRefreshWidget = const DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Text('松开刷新'),
    ),
    this.refreshingWidget = const CupertinoActivityIndicator(),
    this.refreshCompleteWidget = const DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Text('刷新完成'),
    ),
  });
  final List<Widget> slivers;
  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final Widget? sliverAppBar;
  final BoxDecoration? decoration;
  final bool hasMore;
  final Widget loadMoreWidget;
  final Widget refreshingWidget;
  final Widget pullToRefreshWidget;
  final Widget releaseToRefreshWidget;
  final Widget refreshCompleteWidget;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: NotificationListener(
        onNotification: hasMore
            ? (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  /// 如果滑动到了最底部，那么就触发加载更多
                  if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                    onLoadMore?.call();
                  }
                }
                return true;
              }
            : null,
        child: CustomScrollView(
          /// 这个属性是用来控制下拉刷新的，如果不设置，是无法下拉出一段距离的
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            /// AppBar 一般位于最顶部，所以这里放在最前面
            sliverAppBar,

            /// 自定义在刷新的不同状态下的显示内容
            /// 这里面我们使用了 CupertinoSliverRefreshControl，这个控件是 iOS 风格的
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 100,
              refreshIndicatorExtent: 60,
              onRefresh: onRefresh,
              builder: (context, refreshState, pulledExtent,
                      refreshTriggerPullDistance, refreshIndicatorExtent) =>
                  Container(
                decoration: decoration,
                height: pulledExtent,
                alignment: Alignment.center,
                child: _buildRefreshIndicator(
                  refreshState,
                ),
              ),
            ),

            /// 把其他传入的 slivers 放在这里
            ...slivers,

            /// 在页面底部显示加载更多的 Widget
            if (hasMore)
              SliverToBoxAdapter(
                child: loadMoreWidget,
              ),
          ]
              // 用于过滤掉空的 Widget
              .whereType<Widget>()
              .toList(),
        ),
      ),
    );
  }

  _buildRefreshIndicator(
    RefreshIndicatorMode refreshState,
  ) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        return pullToRefreshWidget;
      case RefreshIndicatorMode.armed:
        return releaseToRefreshWidget;
      case RefreshIndicatorMode.refresh:
        return refreshingWidget;
      case RefreshIndicatorMode.done:
        return refreshCompleteWidget;
      default:
        return Container();
    }
  }
}
