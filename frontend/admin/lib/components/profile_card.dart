import 'package:admin/constants.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

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
        // // flutter 2.0 写法改进
        // child: Container(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: defaultPadding,
        //     vertical: defaultPadding / 2,
        //   ),
        //   decoration: BoxDecoration(
        //     color: secondaryColor,
        //     borderRadius: const BorderRadius.all(Radius.circular(10)),
        //     border: Border.all(color: Colors.white10),
        //   ),
        //   child: Row(
        //     children: [
        //       const Icon(Icons.account_circle, color: Colors.white),
        //       if (!Responsive.isMobile(context))
        //         const Padding(
        //           padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        //           child: Text("First Last"),
        //         ),
        //       const Icon(Icons.keyboard_arrow_down),
        //     ],
        //   ),
        // ),
        // // 完全嵌套式写法
        // child: DecoratedBox(
        //   decoration: BoxDecoration(
        //     color: secondaryColor,
        //     borderRadius: const BorderRadius.all(Radius.circular(10)),
        //     border: Border.all(color: Colors.white10),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(
        //       horizontal: defaultPadding,
        //       vertical: defaultPadding / 2,
        //     ),
        //     child: Row(
        //       children: [
        //         const Icon(Icons.account_circle, color: Colors.white),
        //         if (!Responsive.isMobile(context))
        //           const Padding(
        //             padding:
        //                 EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        //             child: Text("First Last"),
        //           ),
        //         const Icon(Icons.keyboard_arrow_down),
        //       ],
        //     ),
        //   ),
        // ),
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
