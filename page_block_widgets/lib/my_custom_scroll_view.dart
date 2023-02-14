import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ScrollPosition { top, end }

class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({
    super.key,
    required this.slivers,
    required this.onRefresh,
    this.onScrollPosition,
    this.sliverAppBar,
    this.decoration,
  });
  final List<Widget> slivers;
  final Future<void> Function() onRefresh;
  final void Function(ScrollPosition)? onScrollPosition;
  final Widget? sliverAppBar;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              onScrollPosition?.call(ScrollPosition.end);
            }
          }
          if (scrollNotification is ScrollStartNotification) {
            if (scrollNotification.metrics.pixels == 0) {
              onScrollPosition?.call(ScrollPosition.top);
            }
          }
          return true;
        },
        child: CustomScrollView(
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
            ...slivers
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
