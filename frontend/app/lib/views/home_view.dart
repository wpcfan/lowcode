import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/home_bloc.dart';
import '../blocs/home_event.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/left_drawer.dart';
import '../widgets/load_more.dart';
import '../widgets/product_dialog.dart';
import '../widgets/right_drawer.dart';
import '../widgets/sliver_app_bar.dart';
import '../widgets/sliver_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue,
          Colors.green,
        ],
      ),
    );
    final key = GlobalKey<ScaffoldState>();
    const errorImage = '';

    return Scaffold(
      key: key,
      body: MyCustomScrollView(
        loadMoreWidget: const LoadMoreWidget(),
        decoration: decoration,
        sliverAppBar: MySliverAppBar(
          decoration: decoration,
          onTap: () {
            context.read<HomeBloc>().add(HomeEventOpenDrawer(key));
          },
        ),
        sliver: SliverBodyWidget(
          errorImage: errorImage,
          onTap: (link) => _onTapImage(link, context),
          onTapProduct: (product) => _onTapProduct(product, context),
          addToCart: (product) => _addToCart(product, context),
        ),
        onRefresh: () async {
          context.read<HomeBloc>().add(const HomeEventFetch(PageType.home));
          await context
              .read<HomeBloc>()
              .stream
              .firstWhere((element) => element.isPopulated || element.isError);
          // 加载速度太快，容易看不到加载动画
          await Future.delayed(const Duration(seconds: 2));
        },
        onLoadMore: () async {
          context.read<HomeBloc>().add(const HomeEventLoadMore());
          await context
              .read<HomeBloc>()
              .stream
              .firstWhere((element) => element.isPopulated || element.isError);
        },
      ),
      bottomNavigationBar: MyBottomBar(onTap: (index) {
        context.read<HomeBloc>().add(HomeEventSwitchBottomNavigation(index));
      }),
      drawer: const LeftDrawer(),
      endDrawer: const RightDrawer(),
    );
  }

  void _addToCart(Product product, BuildContext context) {
    debugPrint('Add to cart: ${product.name}');
  }

  void _onTapProduct(Product product, BuildContext context) {
    debugPrint('Tap product: ${product.name}');
    showDialog(
        context: context,
        builder: (context) => ProductDialog(
              product: product,
              errorImage: '',
            ));
  }

  void _onTapImage(MyLink? link, BuildContext context) {
    if (link == null) {
      return;
    }
    switch (link.type) {
      case LinkType.route:
        Navigator.of(context).pushNamed(link.value);
        break;
      case LinkType.deepLink:
      case LinkType.url:
        launchUrl(
          Uri.parse(link.value),
        );
        break;
    }
  }
}
