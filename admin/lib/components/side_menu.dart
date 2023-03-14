import 'package:admin/constants.dart';
import 'package:canvas/canvas.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      backgroundColor: bgColor,
      child:
          // 左侧组件列表面板
          LeftPane(widgets: [
        WidgetData(
          icon: Icons.photo_library,
          label: '轮播图',
          type: PageBlockType.banner,
        ),
        WidgetData(
          icon: Icons.imagesearch_roller,
          label: '图片行',
          type: PageBlockType.imageRow,
        ),
        WidgetData(
          icon: Icons.production_quantity_limits,
          label: '产品行',
          type: PageBlockType.productRow,
        ),
        WidgetData(
          icon: Icons.category,
          label: '瀑布流',
          type: PageBlockType.waterfall,
        ),
      ]),
    );
  }
}
