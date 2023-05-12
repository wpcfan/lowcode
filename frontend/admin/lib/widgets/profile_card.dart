import 'package:common/common.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: PopupMenuButton(
        offset: const Offset(-10, 42),
        // SwiftUI 写法
        child: [
          const Icon(Icons.account_circle, color: Colors.white),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("First Last"),
            ),
          const Icon(Icons.keyboard_arrow_down),
        ]
            .toRow()
            .padding(horizontal: defaultPadding, vertical: defaultPadding / 2)
            .decorated(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10)),
        itemBuilder: (context) => [
          const PopupMenuItem(
            child: Text("Profile"),
          ),
          const PopupMenuItem(
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
