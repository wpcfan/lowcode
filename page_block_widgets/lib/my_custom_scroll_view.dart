import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  });
  final List<Widget> slivers;
  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final Widget? sliverAppBar;
  final BoxDecoration? decoration;
  final bool hasMore;
  final Widget loadMoreWidget;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener(
        onNotification: hasMore
            ? (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                    onLoadMore?.call();
                  }
                }
                return true;
              }
            : null,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            sliverAppBar,
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
            ...slivers,
            if (hasMore)
              SliverToBoxAdapter(
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: loadMoreWidget,
                ),
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
        return const DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text('下拉刷新'),
        );
      case RefreshIndicatorMode.armed:
        return const DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text('松开手指'),
        );
      case RefreshIndicatorMode.refresh:
        return const CupertinoActivityIndicator();
      case RefreshIndicatorMode.done:
        return const DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text('刷新完成'),
        );
      default:
        return Container();
    }
  }
}
