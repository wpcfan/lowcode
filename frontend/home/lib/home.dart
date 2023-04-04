library home;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blocs/blocs.dart';
import 'popups/popups.dart';
import 'widgets/widgets.dart';

export 'blocs/blocs.dart';

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
    const errorImage = 'assets/images/error_150_150.png';
    final bloc = context.read<HomeBloc>();

    return Scaffold(
      key: key,
      body: MyCustomScrollView(
        loadMoreWidget: const LoadMoreWidget(),
        decoration: decoration,
        sliverAppBar: MySliverAppBar(
          decoration: decoration,
          onTap: () => bloc.add(HomeEventOpenDrawer(key)),
        ),
        sliver: SliverBodyWidget(
          errorImage: errorImage,
          onTap: (link) => _onTapImage(link, context),
          onTapProduct: (product) => _onTapProduct(product, context),
          addToCart: (product) => _addToCart(product, context),
        ),
        onRefresh: () => _refresh(bloc),
        onLoadMore: () => _loadMore(bloc),
      ),
      bottomNavigationBar: MyBottomBar(
          onTap: (index) => bloc.add(HomeEventSwitchBottomNavigation(index))),
      drawer: const LeftDrawer(),
      endDrawer: const RightDrawer(),
    );
  }

  Future<void> _refresh(HomeBloc bloc) async {
    bloc.add(const HomeEventFetch(PageType.home));
    await bloc.stream
        .firstWhere((element) => element.isPopulated || element.isError);
    // 加载速度太快，容易看不到加载动画
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _loadMore(HomeBloc bloc) async {
    bloc.add(const HomeEventLoadMore());
    await bloc.stream
        .firstWhere((element) => element.isPopulated || element.isError);
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
      case LinkType.url:
        launchUrl(
          Uri.parse(link.value),
        );
        break;
    }
  }
}
