import 'package:app/controllers/scaffold_controller.dart';
import 'package:app/widgets/home_error.dart';
import 'package:app/widgets/home_initial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:page_repository/page_repository.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blocs/page_bloc.dart';
import 'blocs/page_state.dart';

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
          Provider(
            create: (context) => PageRepository(),
          ),
          ChangeNotifierProvider(create: (context) => ScaffoldController()),
          Provider(
              create: (context) =>
                  PageLayoutBloc(context.read<PageRepository>()))
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
  int page = 0;
  int _selectedIndex = 0;

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
        stream: Provider.of<PageLayoutBloc>(context).state,
        initialData: PageLayoutInitial(),
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state is PageLayoutInitial) {
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
            body: _buildBody(context, decoration),
            bottomNavigationBar: bottomBar,
            drawer: const LeftDrawer(),
            endDrawer: const RightDrawer(),
          );
        });
  }

  Widget _buildBody(BuildContext context, BoxDecoration decoration) {
    final sliverAppBar = SliverAppBar(
      floating: true,
      pinned: false,
      title: const CupertinoSearchTextField(
        placeholder: 'Search',
        placeholderStyle: TextStyle(color: Colors.white30),
        prefixIcon: Icon(Icons.search, color: Colors.white),
        backgroundColor: Colors.black12,
        style: TextStyle(color: Colors.white),
      ),
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

    final slivers = [
      SliverToBoxAdapter(
        child: ImageRowWidget(
          items: const [
            ImageData(
              image: 'https://picsum.photos/200/300',
              link: MyLink(type: LinkType.url, value: 'https://www.baidu.com'),
              title: 'title1',
            ),
            ImageData(
              image: 'https://picsum.photos/200/300',
              link: MyLink(type: LinkType.url, value: 'https://www.baidu.com'),
              title: 'title2',
            ),
            ImageData(
              image: 'https://picsum.photos/200/300',
              link: MyLink(type: LinkType.url, value: 'https://www.baidu.com'),
              title: 'title2',
            ),
          ],
          itemWidth: 100,
          itemHeight: 160,
          verticalPadding: 10,
          horizontalPadding: 10,
          spaceBetweenItems: 10,
          errorImage: 'assets/images/error.png',
          onTap: (link) {
            if (link != null) {
              switch (link.type) {
                case LinkType.route:
                  Navigator.of(context).pushNamed(
                    link.value,
                  );
                  break;
                case LinkType.url:
                case LinkType.deepLink:
                  launchUrl(Uri.parse(link.value));
                  break;
                default:
              }
            }
          },
        ),
      ),
      SliverGrid.count(
        crossAxisCount: 3,
        children: List.generate(
          10,
          (index) => Container(
            color: Colors.primaries[index % Colors.primaries.length],
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              height: 100,
              color: Colors.primaries[index % Colors.primaries.length],
            );
          },
          childCount: 30,
        ),
      ),
      SliverGrid.count(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(
          (page + 1) * 10,
          (index) => Container(
            color: Colors.primaries[index % Colors.primaries.length],
          ),
        ),
      )
    ];

    return MyCustomScrollView(
      hasMore: true,
      loadMoreWidget: loadMoreWidget,
      decoration: decoration,
      sliverAppBar: sliverAppBar,
      slivers: slivers,
      onRefresh: () async {
        Provider.of<PageLayoutBloc>(context)
            .onPageTypeChanged
            .add(PageType.home);
      },
      onLoadMore: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          page++;
        });
      },
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
