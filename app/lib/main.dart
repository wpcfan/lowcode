import 'package:app/blocs/waterfall_bloc.dart';
import 'package:app/controllers/scaffold_controller.dart';
import 'package:app/widgets/home_error.dart';
import 'package:app/widgets/home_initial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:page_repository/page_repository.dart';
import 'package:provider/provider.dart';

import 'blocs/page_bloc.dart';
import 'blocs/page_state.dart';
import 'blocs/waterfall_state.dart';

void main() {
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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ScaffoldController())
        ],
        child: const HomeView(),
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
  int _selectedIndex = 0;
  late PageLayoutBloc _layoutBloc;
  late WaterfallBloc _waterfallBloc;

  @override
  void initState() {
    super.initState();
    _layoutBloc = PageLayoutBloc(PageRepository(enableCache: false));
    _waterfallBloc = WaterfallBloc(ProductRepository());
  }

  @override
  void dispose() {
    _waterfallBloc.dispose();
    _layoutBloc.dispose();
    super.dispose();
  }

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

    const searchField = CupertinoSearchTextField(
      placeholder: 'Search',
      placeholderStyle: TextStyle(color: Colors.white30),
      prefixIcon: Icon(Icons.search, color: Colors.white),
      backgroundColor: Colors.black12,
      style: TextStyle(color: Colors.white),
    );

    final endDrawerButton = IconButton(
      icon: const Icon(Icons.notification_important),
      onPressed: () {
        context.read<ScaffoldController>().openEndDrawer();
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

    final bottomBar = MyBottomBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        });

    final scaffoldKey = context.read<ScaffoldController>().scaffoldKey;

    return StreamBuilder<PageLayoutState>(
        stream: _layoutBloc.state,
        initialData: PageLayoutInitial(),
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null || state is PageLayoutInitial) {
            return Scaffold(
              key: scaffoldKey,
              appBar: appBar,
              body: const HomeInitial(isLoading: true),
              bottomNavigationBar: bottomBar,
              drawer: const LeftDrawer(),
              endDrawer: const RightDrawer(),
            );
          }

          if (state is PageLayoutError) {
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
            body: _buildBody(context, decoration, searchField, state),
            bottomNavigationBar: bottomBar,
            drawer: const LeftDrawer(),
            endDrawer: const RightDrawer(),
          );
        });
  }

  Widget _buildBody(BuildContext context, BoxDecoration decoration,
      CupertinoSearchTextField searchField, PageLayoutState state) {
    final sliverAppBar = SliverAppBar(
      floating: true,
      pinned: false,
      title: searchField,
      actions: [
        IconButton(
          icon: const Icon(Icons.notification_important),
          onPressed: () {
            context.read<ScaffoldController>().openEndDrawer();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final ratio = screenWidth / (layout?.config.baselineScreenWidth ?? 1);
    final waterfallBlocks = blocks
        .where((element) => element.type == PageBlockType.waterfall)
        .map((e) => e as WaterfallPageBlock);
    if (waterfallBlocks.isNotEmpty &&
        waterfallBlocks.first.data.isNotEmpty &&
        waterfallBlocks.first.data.first.content.id != null) {
      _waterfallBloc.onCategoryChanged
          .add(waterfallBlocks.first.data.first.content.id!);
    }

    return StreamBuilder<WaterfallState>(
        stream: _waterfallBloc.state,
        initialData: WaterfallInitial(),
        builder: (context, snapshot) {
          final state = snapshot.data;
          final slivers = _buildBlocks(
              blocks, errorImage, screenWidth, layout, ratio, state);
          return MyCustomScrollView(
            hasMore: state != null && state.hasNext,
            loadMoreWidget: loadMoreWidget,
            decoration: decoration,
            sliverAppBar: sliverAppBar,
            slivers: slivers,
            onRefresh: () async {
              _layoutBloc.onPageTypeChanged.add(PageType.home);
              _waterfallBloc.onLoadMore.add(0);
              await _layoutBloc.state
                  .where((event) =>
                      event is PageLayoutPopulated || event is PageLayoutError)
                  .first;
              await _waterfallBloc.state
                  .where((event) =>
                      event is WaterfallPopulated || event is WaterfallError)
                  .first;
            },
            onLoadMore: () async {
              _waterfallBloc.onLoadMore.add((state?.page ?? 0) + 1);
              await _waterfallBloc.state
                  .where((event) =>
                      event is WaterfallPopulated || event is WaterfallError)
                  .first;
            },
          );
        });
  }

  List<Widget> _buildBlocks(
      List<PageBlock> blocks,
      String errorImage,
      double screenWidth,
      PageLayout? layout,
      double ratio,
      WaterfallState? state) {
    return blocks.map((block) {
      switch (block.type) {
        case PageBlockType.imageRow:
          final it = block as ImageRowPageBlock;
          return SliverToBoxAdapter(
            child: ImageRowWidget(
              items: it.data.map((di) => di.content).toList(),
              config: it.config,
              ratio: ratio,
              errorImage: errorImage,
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
            products: state?.products ?? [],
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
