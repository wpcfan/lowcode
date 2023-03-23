import 'package:common/common.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../routes/router_config.dart';
import 'profile_card.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      if (!Responsive.isDesktop(context))
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
            } else {
              scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
      if (!Responsive.isMobile(context)) ...[
        Text(
          '动态页面配置平台',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
      Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
      const SizedBox(width: defaultPadding),
      const ProfileCard(),
      if (!Responsive.isDesktop(context))
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (innerScaffoldKey.currentState!.isEndDrawerOpen) {
              innerScaffoldKey.currentState!.closeEndDrawer();
            } else {
              innerScaffoldKey.currentState!.openEndDrawer();
            }
          },
        ),
    ].toRow();
  }
}
