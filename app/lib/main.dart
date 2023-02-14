import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

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
    return Scaffold(
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
      body: MyCustomScrollView(
        decoration: decoration,
        slivers: [
          SliverAppBar(
            floating: true,
            title: const CupertinoSearchTextField(
              placeholder: 'Search',
              placeholderStyle: TextStyle(color: Colors.white30),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              backgroundColor: Colors.black12,
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(Icons.branding_watermark_outlined),
            actions: [
              IconButton(
                icon: const Icon(Icons.notification_important),
                onPressed: () {},
              ),
            ],

            /// 如果没有使用 SliverAppBar，那么这个属性起到的作用其实相当于 AppBar 的背景
            flexibleSpace: Container(
              decoration: decoration,
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
              10,
              (index) => Container(
                color: Colors.primaries[index % Colors.primaries.length],
              ),
            ),
          )
        ],
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        onScrollPosition: (position) {
          print(position);
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
