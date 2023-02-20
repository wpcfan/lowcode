import 'package:app/blocs/home_bloc.dart';
import 'package:app/blocs/home_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:page_repository/page_repository.dart';
import 'package:skeletons/skeletons.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blocs/home_state.dart';
import 'blocs/simple_observer.dart';

void main() {
  /// 初始化 Bloc 的观察者，用于监听 Bloc 的生命周期
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<PageRepository>(
              create: (context) => PageRepository()),
          RepositoryProvider<ProductRepository>(
              create: (context) => ProductRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(
                pageRepo: context.read<PageRepository>(),
                productRepo: context.read<ProductRepository>(),
              )..add(const HomeEventFetch(PageType.home)),
            ),
          ],
          child: const HomeView(),
        ),
      ),
    );
  }
}

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
          onTap: (link) => onTapImage(link, context),
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
  }

  void onTapImage(MyLink? link, BuildContext context) {
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

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CupertinoSearchTextField(
      placeholder: 'Search',
      placeholderStyle: TextStyle(color: Colors.white30),
      prefixIcon: Icon(Icons.search, color: Colors.white),
      backgroundColor: Colors.black12,
      style: TextStyle(color: Colors.white),
    );
  }
}

class MyBottomBar extends StatelessWidget {
  const MyBottomBar({
    super.key,
    this.onTap,
  });
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.selectedIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'About',
            ),
          ],
        );
      },
    );
  }
}

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}

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

class SliverBodyWidget extends StatelessWidget {
  const SliverBodyWidget({
    super.key,
    required this.errorImage,
    this.onTap,
    this.addToCart,
    this.onTapProduct,
  });
  final String errorImage;
  final void Function(MyLink?)? onTap;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTapProduct;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.isError) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('Error'),
            ),
          );
        }
        if (state.isInitial) {
          return SliverToBoxAdapter(child: SkeletonListView());
        }

        /// 屏幕的宽度
        final screenWidth = MediaQuery.of(context).size.width;

        /// 最终的比例
        final ratio =
            (state.layout?.config.baselineScreenWidth ?? 1) / screenWidth;
        final blocks = state.layout?.blocks ?? [];
        final products = state.waterfallList;
        return MultiSliver(
            children: blocks.map((block) {
          switch (block.type) {
            case PageBlockType.banner:
              final it = block as BannerPageBlock;
              return SliverToBoxAdapter(
                child: BannerWidget(
                  items: it.data.map((di) => di.content).toList(),
                  config: it.config,
                  ratio: ratio,
                  errorImage: errorImage,
                  onTap: onTap,
                ),
              );
            case PageBlockType.imageRow:
              final it = block as ImageRowPageBlock;
              return SliverToBoxAdapter(
                child: ImageRowWidget(
                  items: it.data.map((di) => di.content).toList(),
                  config: it.config,
                  ratio: ratio,
                  errorImage: errorImage,
                  onTap: onTap,
                ),
              );
            case PageBlockType.productRow:
              final it = block as ProductRowPageBlock;
              return SliverToBoxAdapter(
                child: ProductRowWidget(
                  items: it.data.map((di) => di.content).toList(),
                  config: it.config,
                  ratio: ratio,
                  errorImage: errorImage,
                  onTap: onTapProduct,
                  addToCart: addToCart,
                ),
              );
            case PageBlockType.waterfall:
              final it = block as WaterfallPageBlock;
              return WaterfallWidget(
                products: products,
                config: it.config,
                ratio: ratio,
                errorImage: errorImage,
                onTap: onTapProduct,
                addToCart: addToCart,
              );
            default:
              return SliverToBoxAdapter(
                child: Container(),
              );
          }
        }).toList());
      },
    );
  }
}

class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.waterfallList != current.waterfallList &&
          !current.hasReachedMax,
      builder: (context, state) {
        return state.waterfallList.isEmpty
            ? Container()
            : const SizedBox(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({
    super.key,
    required this.decoration,
    this.onTap,
  });
  final BoxDecoration decoration;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const searchField = SearchFieldWidget();

    return SliverAppBar(
      floating: true,
      pinned: false,
      title: searchField,
      actions: [
        IconButton(
          icon: const Icon(Icons.notification_important),
          onPressed: onTap,
        ),
      ],

      /// 如果没有使用 SliverAppBar，那么这个属性起到的作用其实相当于 AppBar 的背景
      /// 如果使用了 SliverAppBar，那么这个属性起到的作用不仅是 AppBar 的背景，而且
      /// 下拉的时候，会有一段距离是这个背景，这个 Flexible 就是用来控制这个距离的
      flexibleSpace: Container(
        decoration: decoration,
      ),
    );
  }
}
