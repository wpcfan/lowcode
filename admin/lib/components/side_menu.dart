import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'drawer_list_tile.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            press: () {
              context.go('/');
            },
          ),
          DrawerListTile(
            title: "Transaction",
            icon: Icons.track_changes,
            press: () {
              context.go('/search');
            },
          ),
          DrawerListTile(
            title: "Draggable",
            icon: Icons.drag_handle,
            press: () {
              context.go('/draggable');
            },
          ),
          DrawerListTile(
            title: "DragDrop",
            icon: Icons.drag_indicator,
            press: () {
              context.go('/dragdrop');
            },
          ),
          DrawerListTile(
            title: "Store",
            icon: Icons.store,
            press: () {},
          ),
          DrawerListTile(
            title: "Notification",
            icon: Icons.notifications,
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            icon: Icons.person,
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            icon: Icons.settings,
            press: () {},
          ),
        ],
      ),
    );
  }
}
