import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.isLoading = false,
    this.loadMoreWidget = const Center(child: CircularProgressIndicator()),
  });
  final List<List<dynamic>> items;
  final void Function(int)? onLoadMore;
  final IndexedWidgetBuilder itemBuilder;
  final bool isLoading;
  final Widget loadMoreWidget;

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  late final List<ScrollController> _scrollControllers;
  late final List<double> _scrollPositions;

  @override
  void initState() {
    super.initState();
    _scrollPositions = List.generate(widget.items.length, (_) => 0.0);
    _scrollControllers =
        List.generate(widget.items.length, (_) => ScrollController());
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Material(
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                _saveScrollOffset(index);
                if (notification.metrics.extentAfter == 0) {
                  widget.onLoadMore?.call(index);
                  return true;
                }
              }
              return false;
            },
            child: CustomScrollView(
              controller: _scrollControllers[index],
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      if (i < widget.items[index].length) {
                        return widget.itemBuilder(context, i);
                      } else {
                        return widget.loadMoreWidget;
                      }
                    },
                    childCount:
                        widget.items[index].length + (widget.isLoading ? 1 : 0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onPageChanged: (index) {
        _restoreScrollOffset(index);
      },
    );
  }

  void _saveScrollOffset(int index) {
    _scrollPositions[index] = _scrollControllers[index].position.pixels;
  }

  void _restoreScrollOffset(int index) {
    if (_scrollControllers[index].hasClients) {
      _scrollControllers[index]
          .jumpTo(_scrollPositions[index].clamp(0.0, double.infinity));
    }
  }
}

class ScrollableTab extends StatelessWidget {
  const ScrollableTab(
      {super.key,
      required this.tabs,
      this.onTap,
      this.color = Colors.grey,
      this.selectedColor = Colors.red});
  final List<String> tabs;
  final void Function(int)? onTap;
  final Color color;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final text = tabs[index];
        return ListTile(
          title: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: index == 0 ? selectedColor : color,
                ),
              ),
              Container(
                height: 2,
                color: index == 0 ? selectedColor : Colors.transparent,
              ),
            ],
          ),
          onTap: () => onTap?.call(index),
        );
      },
      itemCount: tabs.length,
    );
  }
}

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _pinned = false;
  final List<String> _tabs = ['Tab1', 'Tab2', 'Tab3', 'Tab4'];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: _pinned,
        expandedHeight: 200.0,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                ),
              ),
              Image.network(
                'https://picsum.photos/200',
                fit: BoxFit.cover,
              ),
              Image.network(
                'https://picsum.photos/200',
                fit: BoxFit.cover,
              ),
              Image.network(
                'https://picsum.photos/200',
                fit: BoxFit.cover,
              ),
              const Card(
                child: Text('Card'),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0) {
                setState(() {
                  _pinned = false;
                });
              }
            },
            child: SizedBox(
              height: 48.0,
              child: TabBar(
                tabs: _tabs.map((e) => Tab(text: e)).toList(),
                isScrollable: true,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter == 0) {
        debugPrint('load more');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: const Text("Title"),
              pinned: false,
              floating: true,
              snap: true,
              flexibleSpace: const FlexibleSpaceBar(
                background: Image(
                  image: NetworkImage("https://picsum.photos/200"),
                  fit: BoxFit.cover,
                ),
              ),
              forceElevated: innerBoxIsScrolled,
            ),
          ),
        ],
        body: Builder(builder: (context) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Injects the overlapped amount into the scrollable area
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              MultiSliver(
                children: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: const [
                        Image(
                          image: NetworkImage("https://picsum.photos/200"),
                          fit: BoxFit.cover,
                        ),
                        Card(
                          child: Text('Card'),
                        ),
                        Image(
                          image: NetworkImage("https://picsum.photos/200"),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SliverPersistentHeader(
                delegate: MyHeaderDelegate(_tabController, [
                  const Tab(text: 'Tab1'),
                  const Tab(text: 'Tab2'),
                  const Tab(text: 'Tab3'),
                  const Tab(text: 'Tab4'),
                ]),
                pinned: true,
              ),
              SliverCrossAxisConstrained(
                maxCrossAxisExtent: 1800,
                alignment: 0, // between
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    GridView.count(crossAxisCount: 2, children: const [
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                    ]),
                    const Center(child: Text('Tab2')),
                    const Center(child: Text('Tab3')),
                    const Center(child: Text('Tab4')),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<Tab> tabs;
  final TabController tabController;

  MyHeaderDelegate(this.tabController, this.tabs);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return TabBar(controller: tabController, tabs: tabs);
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
