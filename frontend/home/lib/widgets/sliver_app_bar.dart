import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'search_field.dart';

/// 顶部 AppBar
class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({
    super.key,
    required this.decoration,
    this.onTap,
  });
  final BoxDecoration decoration;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const searchField = SearchFieldWidget();

    return SliverAppBar(
      /// 是否随着滑动隐藏标题
      floating: true,

      /// 是否在滑动到顶部的时候显示标题
      snap: false,

      /// 是否固定在顶部
      pinned: false,

      /// 状态栏的样式，这里使用的是白色
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: searchField,
      actions: [
        IconButton(
          icon: const Icon(Icons.notification_important),
          onPressed: onTap,
        ),
      ],

      /// 如果没有使用 SliverAppBar，那么这个属性起到的作用其实相当于 AppBar 的背景
      /// 如果使用了 SliverAppBar，那么这个属性起到的作用不仅是 AppBar 的背景，而且
      /// 下拉的时候，会有一段距离是这个背景，这个 Flexible 就是用来控制这个距离的
      flexibleSpace: Container(
        decoration: decoration,
      ),
    );
  }
}
