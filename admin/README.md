# 后台管理界面

## 创建工程

通过指定 `plaforms` 为 `web` 来创建一个只包含 `web` 平台的工程。

```bash
flutter create admin --platforms=web
```

## 项目配置

如果直接运行 `flutter run -d chrome` ，没有科学上网的话，会发现启动后网页白屏，控制台报错：

```bash
Failed to load resource: net::ERR_NAME_NOT_RESOLVED
```

这是由于项目需要加载 Google Fonts 的字体，而 Google Fonts 被墙了，所以需要科学上网或者通过本地加载字体来规避。
本地加载字体的方法可以参考 [Flutter 中文网](https://flutter.cn/docs/cookbook/design/fonts)。

## 本地加载字体

### 下载字体

首先需要下载字体文件，这里使用的是 [Google Fonts](https://fonts.google.com/) 上的字体，下载后放到 `assets/fonts` 目录下。对于无法科学上网的同学，我们准备了 `Roboto` 字体，在 `assets/fonts` 目录下。

### 配置字体

在 `pubspec.yaml` 中配置字体：

```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto/Roboto-Medium.ttf
          weight: 500
        - asset: assets/fonts/Roboto/Roboto-Bold.ttf
          weight: 700
```

## 响应式和适应式设计

响应式和适应式设计是两个不同的概念，响应式设计是指页面的布局会随着屏幕的大小而变化，适应式设计是指页面的内容会随着屏幕的大小而变化。一般我们设计多屏幕的应用时，会同时使用响应式和适应式设计。

我们需要使用 `MediaQuery` 来获取屏幕的宽度，然后根据屏幕的宽度来设置页面的布局和内容。一般来说不同的屏幕宽度代表着不同的设备，比如：

- 小于 600px 的屏幕宽度代表着手机
- 大于等于 600px 小于 960px 的屏幕宽度代表着平板
- 大于等于 960px 的屏幕宽度代表着桌面

我们在 `responsive.dart` 中定义了一个 `Responsive` 类，用来获取屏幕的宽度和高度，以及根据屏幕的宽度来设置页面的布局和内容。

```dart
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  static const smallScreen = 600;
  static const mediumScreen = 960;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < smallScreen;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < mediumScreen &&
      MediaQuery.of(context).size.width >= smallScreen;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreen;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= mediumScreen) {
      return desktop;
    }
    else if (size.width >= smallScreen && tablet != null) {
      return tablet!;
    }
    else {
      return mobile;
    }
  }
}
```

### 响应式的 AppBar

Flutter 的 `AppBar` 是一个 Material Design 的组件，它是一个 Material Design 应用程序的顶部工具栏。一个标准的 `AppBar` 是由一个 `Toolbar` 和一个 `Action` 组成的。`Toolbar` 通常包含一个 `AppBar` 的标题栏（注意这个标题栏不一定是文字，可以是一个定制化的组件）和一个 `AppBar` 的 `Action`，也就是右侧的按钮数组。

由于 Material Design 是一个重度面向移动端的设计语言，所以 `AppBar` 的布局是固定的，它的高度是 56dp，它的左侧一般会给留一个按钮的位置，左侧的按钮一般是返回按钮或菜单按钮，右侧的按钮一般是一些操作按钮。

如果我们定义了 `drawer` 属性，那么左侧的按钮就会变成一个菜单按钮，点击这个按钮会弹出一个抽屉菜单。

如果我们不希望使用其左侧默认的按钮，我们可以通过 `leading` 属性来设置一个自定义的按钮，如果我们不希望使用其右侧默认的按钮，我们可以通过 `actions` 属性来设置一个自定义的按钮数组。

如果不显示左侧按钮，可以设置 `automaticallyImplyLeading` 为 `false`，这样就不会显示默认的返回按钮或菜单按钮。

## 状态管理

### Provider

`Provider` 是一个状态管理的库，可以方便的管理应用的状态，这里我们使用 `Provider` 来管理应用的状态。这个库的使用方法可以参考 [Provider](https://pub.dev/packages/provider)。它是目前最简单的状态管理库，但是它也有一些缺点，比如：

- 无法跨页面共享状态
- 无法跨组件共享状态

这些缺点可以通过 `Provider` 的 `MultiProvider` 和 `Consumer` 来解决。

最简单的情况，我们可以定义一个 `Counter` 类，用来管理计数器的状态：

```dart
class Counter with ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
    notifyListeners();
  }
}
```

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  provider: ^6.0.5
```

在 `lib/main.dart` 中使用，我们一般通过注册 `ChangeNotifierProvider` 来注册状态：

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: MyApp(),
    ),
  );
}
```

在 `lib/pages/home.dart` 中，可以通过 `Consumer` 来读取状态：

```dart
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        // 如果要访问状态，需要使用 Consumer
        child: Consumer<Counter>(
          builder: (context, counter, child) {
            return Text(
              // 在 builder 中的第二个参数就是状态
              '${counter.value}',
              style: Theme.of(context).textTheme.headline4,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 如果要修改状态，需要使用 Provider.of
          Provider.of<Counter>(context, listen: false).increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

#### 依赖注入

依赖注入是一种设计模式，它可以让我们在需要使用依赖的地方直接获取依赖，而不需要在每个需要使用依赖的地方都去获取依赖。`Provider` 也支持依赖注入，我们可以通过 `Provider` 来注册一个依赖，然后在需要使用的地方通过 `Provider.of` 来获取依赖：

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        Provider(create: (_) => Api()),
      ],
      child: MyApp(),
    ),
  );
}
```

那么为什么要使用依赖注入呢？我们可以通过 `Provider.of` 来获取依赖，那么为什么不直接在需要使用依赖的地方通过 `Provider.of` 来获取依赖呢？这样做的好处是，我们可以在需要使用依赖的地方直接获取依赖，而不需要在每个需要使用依赖的地方都去获取依赖。这样做的好处是，如果我们需要修改依赖的实现，那么我们只需要修改依赖的注册位置，而不需要修改依赖的使用位置。

比如我们有一个类的构造函数需要依赖 `Api`，那么我们可以通过 `Provider.of` 来获取依赖：

```dart
class Counter {
  final Api api;

  Counter(this.api);
}
```

当前的 `Api` 是需要一个 `HttpClient` 的实现

```dart
class Api {
  final HttpClient httpClient;

  Api(this.httpClient);
}
```

如果我们需要修改 `Api` 的实现，比如 `Api` 的构造函数从需要一个 `HttpClient` 转换为需要一个 `Dio`

```dart
class Api {
  final Dio dio;

  Api(this.dio);
}
```

那么我们只需要修改 `Provider` 的注册位置：

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Api>(create: (_) => Api(Dio())), // 只需要修改这里
        ChangeNotifierProvider(create: (context) => Counter(Provider.of<Api>(context))), // 所有使用的地方都不需要修改
      ],
      child: MyApp(),
    ),
  );
}
```

使用依赖注入可以让大工程的代码更加清晰，依赖的使用位置不需要关心依赖的实现，只需要关心依赖的接口，这样可以让我们更加专注于业务逻辑的实现。也可以让团队合作更加高效，如果我们需要修改依赖的实现，那么我们只需要修改依赖的注册位置，而不需要修改依赖的使用位置。

依赖注入的原理是什么？它的本质其实是一个 `Map`，`Map` 的 key 是依赖的类型，value 是依赖的实现，当我们需要使用依赖的时候，我们通过依赖的类型来获取依赖的实现。

通过 `Provider` 注册的类默认都是单例的，如果我们需要多例，那么我们可以通过 `Provider.value` 来注册：

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: Api(Dio())),
      ],
      child: MyApp(),
    ),
  );
}
```

依赖注入的范围是什么？`Provider` 只会在当前的 `Widget` 树中查找依赖，如果当前的 `Widget` 树中没有找到依赖，那么它会向上查找，直到找到为止，如果一直没有找到，那么它会抛出异常。

所以如果希望全局使用的依赖，那么我们可以在 `main` 函数中注册：

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Api>(create: (_) => Api(Dio())),
      ],
      child: MyApp(),
    ),
  );
}
```

如果只是希望在某个 `Widget` 树中使用的依赖，那么我们可以在 `Widget` 树中注册：

```dart
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(),
      );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 只在这个 MyHomePage 树中使用
        Provider<Api>(create: (_) => Api(Dio())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

上面的代码中，我们在 `MyHomePage` 中注册了 `Api`，那么在 `MyHomePage` 中的所有 `Widget` 都可以使用 `Api`，但是在 `MyHomePage` 之外的 `Widget` 就不能使用 `Api` 了。

### Bloc

`Bloc` 是一个官方推荐的设计模式，Bloc 是 Business Logic Component 的缩写，实现这样的设计模式可以采用第三方库，比如 [bloc](https://pub.dev/packages/bloc)。也可以自己实现。

自己实现的话，我们会使用 `StreamController` 来实现，`StreamController` 是一个 `Stream` 的控制器，可以通过 `StreamController` 来控制 `Stream` 的行为，比如添加数据、关闭 `Stream` 等。

`StreamController` 有两个属性，一个是 `Stream`，一个是 `Sink`，`Stream` 是用来读取数据的，`Sink` 是用来写入数据的。`Stream` 和 `Sink` 都是 `StreamController` 的泛型，比如 `StreamController<int>`，那么 `Stream` 的泛型就是 `int`，`Sink` 的泛型也是 `int`。

对于 `Counter` 的例子，我们可以这样实现

```dart
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// 事件
class CounterEvent {}

// 增加事件
class IncrementEvent extends CounterEvent {}

// 减少事件
class DecrementEvent extends CounterEvent {}

// 状态
class CounterState {
  final int value;

  CounterState(this.value);
}

class CounterBloc {

  // 初始状态
  CounterState _state = CounterState(0);

  // 状态流
  final _stateStreamController = StreamController<CounterState>();

  // 状态 Sink，用于写入
  Sink<CounterState> get _stateSink => _stateStreamController.sink;

  // 状态 Stream，用于读取
  Stream<CounterState> get stateStream => _stateStreamController.stream;

  // 事件流，用于读取
  final _eventStreamController = StreamController<CounterEvent>();

  // 事件 Sink，用于写入
  Sink<CounterEvent> get eventSink => _eventStreamController.sink;

  CounterBloc() {
    // 监听事件
    _eventStreamController.stream.listen((event) {
      if (event is IncrementEvent) {
        _state = CounterState(_state.value + 1);
      } else if (event is DecrementEvent) {
        _state = CounterState(_state.value - 1);
      }
      // 通过 Sink 添加数据
      _stateSink.add(_state);
    });
  }

  // 关闭流
  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: Center(
        child: CounterWidget(),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  CounterBloc _bloc;

  @override
  void initState() {
    super.initState();
    // 初始化 bloc
    _bloc = CounterBloc();
  }

  @override
  void dispose() {
    // 关闭 bloc
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用 StreamBuilder 监听状态
    return StreamBuilder<CounterState>(
      // 状态
      stream: _bloc.stateStream,
      // 初始状态
      initialData: CounterState(0),
      // context 和 snapshot 是 StreamBuilder 的参数
      // 其中 snapshot.data 就是状态
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // 显示状态
              '${snapshot.data.value}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    // 通过 Sink 添加事件
                    _bloc.eventSink.add(IncrementEvent());
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    // 通过 Sink 添加事件
                    _bloc.eventSink.add(DecrementEvent());
                  },
                  tooltip: 'Decrement',
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
```

需要注意的是，我们通过 flutter 的 `StreamBuilder` 来实现了状态的监听，当状态发生变化时，`StreamBuilder` 会自动调用 `builder` 方法，重新构建页面。

### rxdart

`rxdart` 是一个响应式编程的库，可以方便的实现响应式编程，它的使用方法可以参考 [rxdart](https://pub.dev/packages/rxdart)。

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  rxdart: ^0.27.1
```

使用 `rxdart` 实现上面的计数器：

```dart
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterPage(),
    );
  }
}

class CounterState {
  final int value;

  CounterState(this.value);
}

class IncrementEvent {}

class DecrementEvent {}

class CounterBloc {
  final Sink<Int> onCounterChanged;
  final Stream<Int> state;

  CounterBloc() {
    onCounterChanged = PublishSubject<Int>();
    state = onCounterChanged.startWith(0).scan((acc, curr, i) => acc + curr);
  }

  void dispose() {
    onCounterChanged.close();
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: Center(
        child: CounterWidget(),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  CounterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CounterBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Int>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${snapshot.data}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    _bloc.onCounterChanged.add(1);
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    _bloc.onCounterChanged.add(-1);
                  },
                  tooltip: 'Decrement',
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
```

上面的代码中，我们通过 `PublishSubject` 来创建了一个 `Sink`，通过 `startWith` 和 `scan` 来创建了一个 `Stream` ，通过 `StreamBuilder` 来监听状态的变化。

`rxdart` 中的 `Subject` 其实是 `StreamController` 的一个子类，它可以同时作为 `Stream` 和 `Sink` 来使用，通过 `Subject` 可以很方便的实现事件的发送和状态的监听。

`Subject` 有几种类型：

- `BehaviorSubject`：可以在订阅时发送最新的数据
- `PublishSubject`：只发送订阅之后的数据
- `ReplaySubject`：可以在订阅时发送指定数量的数据
- `AsyncSubject`：只发送最后一个数据

从上面代码中我们可以看到，通过使用 `Subject` ，我们减少了很多代码，使得代码更加简洁。

但 `rxdart` 的优势不止如此，它还提供了很多有用的操作符，比如 `map`、`where`、`debounce`、`distinct`、`throttle` 等等，这些操作符可以让我们更方便的处理数据流。

为了更好的理解 `rxdart`，我们来看一个例子：

```dart
import 'package:rxdart/rxdart.dart';

void main() {
  final subject = PublishSubject<int>();

  subject
      .where((i) => i % 2 == 0)
      .map((i) => i * 2)
      .debounce(Duration(milliseconds: 500))
      .listen((i) => print(i));

  subject.add(1);
  subject.add(2);
  subject.add(3);
  subject.add(4);
  subject.add(5);
  subject.add(6);
  subject.add(7);
  subject.add(8);
  subject.add(9);
  subject.add(10);
}
```

上面的代码中，我们通过 `where` 过滤了奇数，通过 `map` 将偶数乘以 2，通过 `debounce` 过滤了 500 毫秒内的连续事件，最后打印出了 8 和 20。

## 路由

### Navigator

`Navigator` 是一个路由管理的组件，它可以管理应用的路由栈，我们可以通过 `Navigator.push` 来打开一个新的页面，通过 `Navigator.pop` 来关闭当前页面。

```dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text(
          'Home',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondPage()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second'),
      ),
      body: Center(
        child: Text(
          'Second',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Navigator 2.0

`Navigator 2.0` 是 Flutter 2.0 中新增的路由管理方式，它的使用方法可以参考 [Navigator 2.0](https://flutter.dev/docs/development/ui/navigation)。它的优点是：

但由于内置的这个路由支持需要较多的自定义代码，我们一般还是使用第三方的路由库。这些路由库建构在 `Navigator 2.0` 的基础上，提供了更加方便的使用方式。常用的路由库有：

- [auto_route](https://pub.dev/packages/auto_route)
- [go_router](https://pub.dev/packages/go_router)

我个人倾向于 `auto_route` ，因为它和 `angular` 的路由特别类似，但是 `auto_route` 是需要代码生成的，所以在使用之前需要先配置代码生成器。所以我们在课程中还是使用 `go_router` 。

### go_router

`go_router` 是一个路由库，它的使用方法可以参考 [go_router](https://pub.dev/packages/go_router)。它的优点是：

- 无需代码生成
- 支持嵌套路由
- 支持路由守卫

而且它是官方推荐和官方维护的路由库，在稳定性和性能上都有保障。

添加 `go_router` 依赖，课程中的版本是 `6.0.x`，建议大家在课程学习时使用同样的版本，避免出现一些兼容性问题：

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^6.0.1
```

我们可以通过 `GoRouter` 来管理路由：

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text(
          'Home',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/second');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second'),
      ),
      body: Center(
        child: Text(
          'Second',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: GoRouteInformationParser(),
      routerDelegate: GoRouterDelegate(
        routes: GoRouter.routes(
          routes: {
            '/': (_) => HomePage(),
            '/second': (_) => SecondPage(),
          },
        ),
      ),
    );
  }
}
```

注意到上面代码中， `go_router` 是使用 `context.go` 来进行路由跳转的，而不是使用 `Navigator.push` 。这是因为 `go_router` 是建构在 `Navigator 2.0` 的基础上的，所以它的路由跳转方式也是使用 `context.go` 。

上面代码中是一个简单路由，我们通过 `MaterialApp.router` 来创建一个路由应用，它的 `routeInformationParser` 和 `routerDelegate` 都是 `go_router` 提供的，它们的作用是：

- `routeInformationParser`：解析路由信息
- `routerDelegate`：根据路由信息来构建路由

我们可以通过 `GoRouter.routes` 来创建一个路由，它的 `routes` 参数是一个 `Map<String, GoRouteBuilder>` ，它的键是路由路径，值是一个 `GoRouteBuilder` ，它是一个函数，它的参数是 `RouteData` ，返回值是一个 `Widget` 。我们可以通过 `RouteData` 来获取路由参数，比如上面代码中的 `RouteData` ，它的 `path` 是 `/second` ，它的 `params` 是一个空的 `Map` ，它的 `query` 是一个空的 `Map` 。我们可以通过 `RouteData` 来获取路由参数，比如上面代码中的 `RouteData` ，它的 `path` 是 `/second` ，它的 `params` 是一个空的 `Map` ，它的 `query` 是一个空的 `Map` 。

我们可以通过 `context.go` 来进行路由跳转，它的参数是一个 `String` ，表示路由路径，比如上面代码中的 `context.go('/second')` ，它表示跳转到 `/second` 路由。

#### 路由参数

路由的参数分为两种，一种是路径参数，一种是查询参数，它们的区别是：

- 路径参数：在路径中，比如上面代码中的 `'/second/:name'` ，它的值是 `RouteData.params` ，它是一个 `Map<String, String>` ，它的键是参数名，值是参数值
- 查询参数：在路径后面，比如上面代码中的 `'/second?name=flutter'` ，它的值是 `RouteData.query` ，它是一个 `Map<String, String>` ，它的键是参数名，值是参数值

下面的例子展示了如何传递这两种参数：

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: GoRouter.routeInformationParser(),
      routerDelegate: GoRouter.routerDelegate(
        routes: GoRouter.routes(
          routes: {
            '/': (_) => HomePage(),
            '/second/:name': (_) => SecondPage(),
            '/third': (_) => ThirdPage(),
            '/fourth': (_) => FourthPage(),
          },
        ),
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text(
          'Home',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/second/flutter');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.routeData.params['name'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Second'),
      ),
      body: Center(
        child: Text(
          'Second $name',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/third?name=third');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.routeData.query['name'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Third'),
      ),
      body: Center(
        child: Text(
          'Third $name',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/fourth?name=third&age=18');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.routeData.query['name'];
    final age = context.routeData.query['age'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Fourth'),
      ),
      body: Center(
        child: Text(
          'Fourth $name $age',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
```

#### 嵌套路由

嵌套路由是指在一个路由中，再嵌套一个路由，也就是，嵌套路由指的是变化的部分是整个页面的一部分，而不是整个页面。我们的例子中，可以固定头部 `AppBar` ，然后在 `body` 中嵌套一个路由，这样就可以实现嵌套路由。

`ShellRoute` 一般使用 `builder` 来构建，它的参数是一个 `Widget Function(BuildContext, GoRouterState, Widget)?` ，它的第一个参数是 `BuildContext` ，第二个参数是 `GoRouterState` ，第三个参数是 `child` ，它是一个 `Widget` ，它是一个 `GoRouter` 的子路由，就是导航到子路由后要显示的组件。

而 `ShellRoute` 的第二个参数 `routes` 是用于定义路由表的结构，最外层就是父路由，然后在父路由中定义子路由，也就是在 `GoRoute` 的 `routes` 中定义子路由。

下面的例子展示了如何使用 `ShellRoute` 来实现嵌套路由，我们通过自定义一个 `GoRouter` 来实现：

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

final _router = GoRouter(
  initialRoute: '/',
  routes: [
    // 路由表的第一个路由，这里由于我们要嵌套路由，所以我们使用 ShellRoute
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          // AppBar 在这个路由下的所有子路由中都是固定的，我们在这里定义
          appBar: AppBar(
            title: Text('Home'),
          ),
          // child 是一个子路由，就是导航到子路由后要显示的组件
          // 也就是每次切换路由后，要刷新的区域就是 body
          body: child,
        );
      },
      routes: [
        GoRoute(
          // 父路由的定义
          path: '/',
          builder: (_) => HomePage(),
          // 子路由的定义，注意路径最左侧不能有 /，否则会被认为是根路径
          // 所有路径的定义是相对于父路由的路径
          // 如果父路由不是 '/'， 比如父路由是 '/home'，那么子路由的路径就是 '/home/second'
          routes: [
            GoRoute(
              path: 'second/:name',
              builder: (_) => SecondPage(),
            ),
            GoRoute(
              path: 'third',
              builder: (_) => ThirdPage(),
            ),
            GoRoute(
              path: 'fourth',
              builder: (_) => FourthPage(),
            ),
          ],
        ),
      ],
    ),
  ]
)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      // 通过 MultiProvider 来管理多个 Provider
      routerConfig: _router,
    );
  }
}
```

## Flutter 中的拖放支持

Flutter 中的拖放支持是通过 `Draggable` 和 `DragTarget` 来实现的，`Draggable` 是一个可拖动的组件，`DragTarget` 是一个可接受拖动的组件。

### Draggable

`Draggable` 是一个可拖动的组件，它的参数是 `Widget Function(BuildContext, DragTargetDetails)` ，它的第一个参数是 `BuildContext` ，第二个参数是 `DragTargetDetails` ，它是一个 `DragTarget` 的子组件，它的 `onAccept` 方法会在 `DragTarget` 接受拖动后调用。

```dart
Draggable(
  // 这里的 child 就是我们要拖动的组件
  child: Container(
    width: 100,
    height: 100,
    color: Colors.red,
  ),
  // feedback 是拖动时显示的组件
  feedback: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
  // childWhenDragging 是拖动结束后显示的组件
  childWhenDragging: Container(
    width: 100,
    height: 100,
    color: Colors.green,
  ),
  // data 是拖动时传递的数据
  data: 'data',
  // onDragStarted 是拖动开始时调用的方法
  onDragStarted: () {
    print('onDragStarted');
  },
  // onDraggableCanceled 是拖动取消时调用的方法
  onDraggableCanceled: (velocity, offset) {
    print('onDraggableCanceled');
  },
  // onDragCompleted 是拖动完成时调用的方法
  onDragCompleted: () {
    print('onDragCompleted');
  },
  // onDragEnd 是拖动结束时调用的方法
  onDragEnd: (details) {
    print('onDragEnd');
  },
  // onDraggableCanceled 是拖动取消时调用的方法
  onDraggableCanceled: (velocity, offset) {
    print('onDraggableCanceled');
  },
)
```

### DragTarget

`DragTarget` 是一个可接受拖动的组件，它的参数是 `Widget Function(BuildContext, List<T>, List<dynamic>)` ，它的第一个参数是 `BuildContext` ，第二个参数是 `List<T>` ，第三个参数是 `List<dynamic>` ，它的第二个参数是 `Draggable` 的 `data` ，第三个参数是 `Draggable` 的 `onDraggableCanceled` 方法的第一个参数。

```dart
DragTarget(
  // builder 是构建方法，它的第一个参数是 BuildContext
  // 第二个参数是 List<T>，它是 Draggable 的 data
  // 第三个参数是 List<dynamic>，它是 Draggable 的 onDraggableCanceled 方法的第一个参数
  builder: (context, candidateData, rejectedData) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
    );
  },
  // onWillAccept 是当 Draggable 进入 DragTarget 时调用的方法
  // 它的参数是 Draggable 的 data
  onWillAccept: (data) {
    print('onWillAccept');
    return true;
  },
  // onAccept 是当 Draggable 进入 DragTarget 并且 onWillAccept 返回 true 时调用的方法
  // 它的参数是 Draggable 的 data
  onAccept: (data) {
    print('onAccept');
  },
  // onLeave 是当 Draggable 离开 DragTarget 时调用的方法
  // 它的参数是 Draggable 的 data
  onLeave: (data) {
    print('onLeave');
  },
)
```

### 拖放调整顺序

在 flutter 中实现对一个列表的元素进行拖放调整顺序，我们可以通过 `Draggable` 和 `DragTarget` 来实现。这个例子里面每个元素都同时是一个 `Draggable` 和 `DragTarget` ，当拖动一个元素时，它会在列表中寻找一个 `DragTarget` ，当找到一个 `DragTarget` 时，它会将自己的数据和 `DragTarget` 的数据进行交换。

```dart
class DragDropListPage extends StatefulWidget {
  const DragDropListPage({super.key});

  @override
  State<DragDropListPage> createState() => _DragDropListPageState();
}

class _DragDropListPageState extends State<DragDropListPage> {
  final List<int> _items = List<int>.generate(20, (int index) => index);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final String item = "${_items[index]}";
        return DragTarget(
          builder: (context, candidateData, rejectedData) {
            return Draggable(
              data: item,
              feedback: SizedBox(
                width: 200,
                height: 50,
                child: ListTile(
                  tileColor: Colors.blue,
                  title: Text('Item $item'),
                ),
              ),
              child: ListTile(
                key: Key(item),
                title: Text('Item $item'),
              ),
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (String data) {
            final int dragIndex = _items.indexOf(int.parse(data));
            final int dropIndex = _items.indexOf(int.parse(item));

            setState(() {
              // swap 是一个我们自己实现的扩展方法，用于交换列表中两个元素的位置
              _items.swap(dragIndex, dropIndex);
            });
          },
        );
      },
      itemCount: _items.length,
    );
  }
}
```

注意上面代码中的 `swap` 方法并不是内建的方法，我们使用了一个 `extension` 去扩展了 `List` 类型，这个 `extension` 的作用是交换列表中两个元素的位置。

```dart
extension ListExtension<T> on List<T> {
  void swap(int index1, int index2) {
    RangeError.checkValidIndex(index1, this, 'index1');
    RangeError.checkValidIndex(index2, this, 'index2');
    final T temp = this[index1];
    this[index1] = this[index2];
    this[index2] = temp;
  }
}
```
