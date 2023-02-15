import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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
      home: const HomeView(),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: const CupertinoSearchTextField(
      //     placeholder: 'Search',
      //     placeholderStyle: TextStyle(color: Colors.white30),
      //     prefixIcon: Icon(Icons.search, color: Colors.white),
      //     backgroundColor: Colors.black12,
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   leading: const Icon(Icons.branding_watermark_outlined),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notification_important),
      //       onPressed: () {},
      //     ),
      //   ],

      //   /// 如果没有使用 SliverAppBar，那么这个属性起到的作用其实相当于 AppBar 的背景
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //         colors: [
      //           Colors.blue,
      //           Colors.green,
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body: _buildBody(decoration),
      bottomNavigationBar: _buildBottomNavigationBar(),
      drawer: const LeftDrawer(),
      endDrawer: const RightDrawer(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
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

  MyCustomScrollView _buildBody(BoxDecoration decoration) {
    return MyCustomScrollView(
      hasMore: true,
      loadMoreWidget: Container(
        height: 60,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
      decoration: decoration,
      sliverAppBar: SliverAppBar(
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
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],

        /// 如果没有使用 SliverAppBar，那么这个属性起到的作用其实相当于 AppBar 的背景
        /// 如果使用了 SliverAppBar，那么这个属性起到的作用不仅是 AppBar 的背景，而且
        /// 下拉的时候，会有一段距离是这个背景，这个 Flexible 就是用来控制这个距离的
        flexibleSpace: Container(
          decoration: decoration,
        ),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: ImageRowWidget(
            items: const [
              ImageData(
                image: 'https://picsum.photos/200/300',
                link:
                    MyLink(type: LinkType.url, value: 'https://www.baidu.com'),
                title: 'title1',
              ),
              ImageData(
                image: 'https://picsum.photos/200/300',
                link:
                    MyLink(type: LinkType.url, value: 'https://www.baidu.com'),
                title: 'title2',
              ),
            ],
            itemWidth: 30,
            itemHeight: 40,
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
      ],
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          page = 0;
        });
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
