import 'package:flutter/material.dart';

/// 右侧抽屉
class RightDrawer extends StatelessWidget {
  const RightDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages 1'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Messages 2'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Messages 3'),
            ),
          ],
        ),
      ),
    );
  }
}
