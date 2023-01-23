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
