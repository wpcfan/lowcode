import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.red,
                        height: 300,
                      ),
                      const SizedBox(height: defaultPadding),
                      Container(
                        color: Colors.purple,
                        height: 300,
                      ),
                      // if (Responsive.isMobile(context))
                      //   const SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context))
                      //   Container(
                      //     color: Colors.green,
                      //     height: 616,
                      //   ),
                      // 如果需要在某一条件下显示多个组件，可以使用 ...[] 这种方式。
                      // 这样可以避免多个 if 判断，使代码更加简洁。
                      if (Responsive.isMobile(context)) ...[
                        const SizedBox(height: defaultPadding),
                        Container(
                          color: Colors.green,
                          height: 616,
                        ),
                      ],
                    ],
                  ),
                ),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context)) ...[
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.green,
                      height: 616,
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
