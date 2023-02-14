import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ScrollPosition { top, end }

class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({
    super.key,
    required this.slivers,
    required this.onRefresh,
    this.onScrollPosition,
    this.refreshIndicatorIndex = 0,
  });
  final List<Widget> slivers;
  final Future<void> Function() onRefresh;
  final void Function(ScrollPosition)? onScrollPosition;
  final int refreshIndicatorIndex;

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
            ...slivers.sublist(0, refreshIndicatorIndex),
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 100,
              refreshIndicatorExtent: 60,
              onRefresh: onRefresh,
              builder: (context, refreshState, pulledExtent,
                      refreshTriggerPullDistance, refreshIndicatorExtent) =>
                  Container(
                color: Colors.blueAccent,
                height: pulledExtent,
                alignment: Alignment.center,
                child: _buildRefreshIndicator(
                  context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                ),
              ),
            ),
            ...slivers.sublist(refreshIndicatorIndex),
          ],
        ),
      ),
    );
  }

  _buildRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
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
