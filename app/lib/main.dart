import 'package:app/blocs/home_bloc.dart';
import 'package:app/blocs/home_event.dart';
import 'package:app/widgets/home_error.dart';
import 'package:app/widgets/home_initial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:page_repository/page_repository.dart';
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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
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

    const searchField = SearchFieldWidget();

    final endDrawerButton = IconButton(
      icon: const Icon(Icons.notification_important),
      onPressed: () {
        homeBloc.add(const HomeEventOpenDrawer());
      },
    );

    final appBar = AppBar(
      title: searchField,
      actions: [
        endDrawerButton,
      ],

      /// 如果没有使用 SliverAppBar，那么这个属性起到的作用其实相当于 AppBar 的背景
      flexibleSpace: Container(
        decoration: decoration,
      ),
    );

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      final bottomBar = MyBottomBar(
          selectedIndex: state.selectedIndex,
          onTap: (index) {
            homeBloc.add(HomeEventSwitchBottomNavigation(index));
          });

      final scaffoldKey = state.scaffoldKey;
      if (state.isInitial) {
        return Scaffold(
          key: scaffoldKey,
          appBar: appBar,
          body: const HomeInitial(isLoading: true),
          bottomNavigationBar: bottomBar,
          drawer: const LeftDrawer(),
          endDrawer: const RightDrawer(),
        );
      }

      if (state.isError) {
        return Scaffold(
          key: scaffoldKey,
          appBar: appBar,
          body: const HomeError(),
          bottomNavigationBar: bottomBar,
          drawer: const LeftDrawer(),
          endDrawer: const RightDrawer(),
        );
      }

      return Scaffold(
        key: scaffoldKey,
        body: _buildBody(context, decoration, searchField, state, homeBloc),
        bottomNavigationBar: bottomBar,
        drawer: const LeftDrawer(),
        endDrawer: const RightDrawer(),
      );
    });
  }

  Widget _buildBody(BuildContext context, BoxDecoration decoration,
      SearchFieldWidget searchField, HomeState state, HomeBloc homeBloc) {
    final sliverAppBar = SliverAppBar(
      floating: true,
      pinned: false,
      title: searchField,
      actions: [
        IconButton(
          icon: const Icon(Icons.notification_important),
          onPressed: () {
            homeBloc.add(const HomeEventOpenDrawer());
          },
        ),
      ],

      /// 如果没有使用 SliverAppBar，那么这个属性起到的作用其实相当于 AppBar 的背景
      /// 如果使用了 SliverAppBar，那么这个属性起到的作用不仅是 AppBar 的背景，而且
      /// 下拉的时候，会有一段距离是这个背景，这个 Flexible 就是用来控制这个距离的
      flexibleSpace: Container(
        decoration: decoration,
      ),
    );

    final loadMoreWidget = Container(
      height: 60,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );

    const errorImage = '';
    final layout = state.layout;
    final blocks = layout?.blocks ?? [];

    /// 屏幕的宽度
    final screenWidth = MediaQuery.of(context).size.width;

    /// 最终的比例
    final ratio = (layout?.config.baselineScreenWidth ?? 1) / screenWidth;

    final slivers = _buildBlocks(
        blocks, errorImage, screenWidth, layout, ratio, state.waterfallList);
    return MyCustomScrollView(
      hasMore: !state.isEnd,
      loadMoreWidget: loadMoreWidget,
      decoration: decoration,
      sliverAppBar: sliverAppBar,
      slivers: slivers,
      onRefresh: () async {
        homeBloc.add(const HomeEventFetch(PageType.home));
        await homeBloc.stream
            .firstWhere((element) => element.isPopulated || element.isError);
      },
      onLoadMore: () async {
        homeBloc.add(const HomeEventLoadMore());
        await homeBloc.stream
            .firstWhere((element) => element.isPopulated || element.isError);
      },
    );
  }

  void onTapImage(MyLink? link) {
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

  List<Widget> _buildBlocks(
      List<PageBlock> blocks,
      String errorImage,
      double screenWidth,
      PageLayout? layout,
      double ratio,
      List<Product> products) {
    return blocks.map((block) {
      switch (block.type) {
        case PageBlockType.banner:
          final it = block as BannerPageBlock;
          return SliverToBoxAdapter(
            child: BannerWidget(
              items: it.data.map((di) => di.content).toList(),
              config: it.config,
              ratio: ratio,
              errorImage: errorImage,
              onTap: onTapImage,
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
              onTap: onTapImage,
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
            ),
          );
        case PageBlockType.waterfall:
          final it = block as WaterfallPageBlock;
          return WaterfallWidget(
            products: products,
            config: it.config,
            ratio: ratio,
            errorImage: errorImage,
          );
        default:
          return SliverToBoxAdapter(
            child: Container(),
          );
      }
    }).toList();
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
    required this.selectedIndex,
    this.onTap,
  });
  final int selectedIndex;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Person',
        ),
      ],
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
