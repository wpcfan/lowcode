import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            print('end');
          }
        }
        if (scrollNotification is ScrollStartNotification) {
          if (scrollNotification.metrics.pixels == 0) {
            print('top');
          }
        }
        return true;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              return Container(
                height: index % 2 == 0 ? 100 : 200,
                color: Colors.primaries[index % Colors.primaries.length],
                child: Center(
                  child: Text('$index'),
                ),
              );
            },
            childCount: 100,
          )
        ],
      ),
    );
    //   return SafeArea(
    //     child: SingleChildScrollView(
    //       primary: false,
    //       padding: const EdgeInsets.all(defaultPadding),
    //       child: Column(
    //         children: [
    //           const SizedBox(height: defaultPadding),
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Expanded(
    //                 flex: 5,
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       color: Colors.red,
    //                       height: 300,
    //                     ),
    //                     const SizedBox(height: defaultPadding),
    //                     Container(
    //                       color: Colors.purple,
    //                       height: 300,
    //                     ),
    //                     const SizedBox(height: defaultPadding),
    //                     BannerWidget(
    //                       data: const [
    //                         ImageData(
    //                             image:
    //                                 'https://via.placeholder.com/300x150/FF0000/FFFFFF?text=1',
    //                             link: MyLink(
    //                               type: LinkType.url,
    //                               value: '/draggable',
    //                             )),
    //                         ImageData(
    //                             image:
    //                                 'https://via.placeholder.com/300x150/00FF00/FFFFFF?text=2',
    //                             link: MyLink(
    //                               type: LinkType.url,
    //                               value: '/draggable',
    //                             )),
    //                         ImageData(
    //                             image:
    //                                 'https://via.placeholder.com/300x150/0000FF/FFFFFF?text=3',
    //                             link: MyLink(
    //                               type: LinkType.url,
    //                               value: '/draggable',
    //                             )),
    //                       ],
    //                       height: 150,
    //                       errorImage: 'assets/images/error_400_120.png',
    //                       // 如果提示 Invalid constant value，可以尝试去掉 BannerWidget 前面的 const 关键字。
    //                       onImageSelected: (link) {
    //                         print(link);
    //                       },
    //                     ).constrained(width: 400),
    //                     if (Responsive.isMobile(context))
    //                       const SizedBox(height: defaultPadding),
    //                     if (Responsive.isMobile(context))
    //                       Container(
    //                         color: Colors.green,
    //                         height: 616,
    //                       ),
    //                     // 如果需要在某一条件下显示多个组件，可以使用 ...[] 这种方式。
    //                     // 这样可以避免多个 if 判断，使代码更加简洁。
    //                     if (Responsive.isMobile(context)) ...[
    //                       const SizedBox(height: defaultPadding),
    //                       Container(
    //                         color: Colors.green,
    //                         height: 616,
    //                       ),
    //                     ],
    //                   ],
    //                 ),
    //               ),
    //               // On Mobile means if the screen is less than 850 we dont want to show it
    //               if (!Responsive.isMobile(context)) ...[
    //                 const SizedBox(width: defaultPadding),
    //                 Expanded(
    //                   flex: 2,
    //                   child: Container(
    //                     color: Colors.green,
    //                     height: 616,
    //                   ),
    //                 ),
    //               ]
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   )
  }
}
