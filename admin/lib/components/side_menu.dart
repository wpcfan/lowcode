import 'package:flutter/material.dart';

import 'drawer_list_tile.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            press: () {},
          ),
          DrawerListTile(
            title: "Transaction",
            icon: Icons.track_changes,
            press: () {},
          ),
          DrawerListTile(
            title: "Task",
            icon: Icons.task,
            press: () {},
          ),
          DrawerListTile(
            title: "Documents",
            icon: Icons.document_scanner,
            press: () {},
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
