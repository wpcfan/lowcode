<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# 公用类库包

在 flutter 工程中，随着工程规模的增大，会出现大量的重复代码，这些重复代码会导致工程的可维护性降低，为了解决这个问题，我们将一些常用的工具类抽离出来，形成一个公用类库包，方便在工程中使用。

划分包的方式一般分为两种：

1. 按照功能划分，比如网络请求、图片加载、本地存储等
2. 按照业务划分，比如登录、首页、个人中心等

第一种方式的优点是功能模块化，方便维护，缺点是业务没有模块化，不利于业务的扩展。第二种方式的优点是业务模块化，方便业务的扩展，缺点是功能没有模块化，不利于功能的维护。

所以在实际项目中，我们往往会采用两种方式的结合，比如网络请求、图片加载、本地存储等功能模块，按照功能划分；登录、首页、个人中心等业务模块，按照业务划分。

## 项目结构

我们的项目中从大的方面分为管理后台和 app 两个部分，所以我们的项目结构也是按照这两个部分来划分的。但由于两个项目共享了一些公用的类库，所以我们将这些公用的类库抽离出来，形成一个公用类库包，方便在工程中使用。

```
├── worksapce
│   ├── common
│   │   ├── lib
│   │   │   ├── models
│   │   │   ├── extensions
│   │   │   ├── widgets
│   │   ├── test
│   ├── admin
│   ├── app
```

在 `common` 目录下，我们将两个工程都要使用的一些类抽离出来，形成一个公用类库包，方便在工程中使用。

- `models` 目录下存放一些公用的数据模型，在我们项目中我们会把各类组件的数据模型都放在这个目录下，方便在工程中使用。
- `extensions` 目录下存放一些公用的扩展方法，比如我们扩展了 `Widget` 、 `Icon` 、 `List<Widget>` 等类来减少不必要的代码嵌套，形成类似 `SwiftUI`画 的写法。同时我们把 `String` 也进行了扩展，对于划线价格、价格、折扣等的展示，我们都封装在这个类中。
- `widgets` 目录下存放一些公用的组件，在我们项目中我们会把各类组件都放在这个目录下，比如要在客户端展现的图片类或商品类组件，在后台运营人员也需要使用我们的可视化工具拖拽到页面上形成一个完整的页面，编辑之后，这个页面数据会保存到数据库，前端的 App 就会调用来真正渲染出结果。

## 扩展

### SwiftUI 风格的写法

和传统的 UI 编写风格不同， `flutter` 采用的是声明式的方式来编写 UI，这种方式的是代码的可读性更高，但是由于 `Widget` 的嵌套层级比较深，所以我们在编写的时候会比较繁琐，在 flutter 之后出现的框架中，比如 SwiftUI，它吸收了 `flutter` 的优点，同时也解决了 `flutter` 的一些缺点。

SwiftUI 和 flutter 类似，但 SwiftUI 的写法上更简洁，因为有一些从 UI 角度看应该是属性设置的，但是在 `flutter` 中却是一个 `Widget`，比如 `padding`、`margin`、`alignment` 等，这些属性在 `flutter` 中都是一个 `Widget`，所以在 `flutter` 中我们需要这样写：

```dart
Container(
  padding: EdgeInsets.all(10),
  child: Text('Hello World'),
)
```

但如果使用 `SwiftUI` 的写法，我们可以这样写：

```dart
Text('Hello World').padding(EdgeInsets.all(10))
```

从代码的可读性上来看，第二种显然更好一些。

我们在 `icon_widget_extensions.dart` , `list_widget_extensions.dart` , `text_widget_extensions.dart` , `widget_extensions.dart` 中进行了扩展，大部分的扩展方法非常简单，比如 `padding`、`margin`、`alignment` 等，我们都是直接返回一个 `Widget`，然后在 `Widget` 的 `build` 方法中进行处理，这样就可以实现 `SwiftUI` 的写法。

下面是一个简单的例子，我们创建了一个自定义的 `RoundIcon` 组件，它是一个圆形的 `Icon`，我们可以通过 `RoundIcon` 来创建一个圆形的 `Icon` 。这个组件可以方便的实现点击的水波纹效果，同时也可以设置阴影的颜色和大小。其具体实现在 `build` 方法中。你可以尝试一下如果不采用我们的扩展方法，写同样功能的代码会是什么样子，自己比较一下。

```dart
class RoundIcon extends StatefulWidget {
  const RoundIcon({
    super.key,
    this.color = const Color(0xFF42526F),
    this.backgroundColor = const Color(0xfff6f5f8),
    required this.icon,
    this.shadowColor = const Color(0x30000000),
    this.size = 50,
    this.iconSize = 20,
  });
  final Color color;
  final Color backgroundColor;
  final Color shadowColor;
  final IconData icon;
  final double iconSize;
  final double size;

  @override
  State<RoundIcon> createState() => _RoundIconState();
}

class _RoundIconState extends State<RoundIcon> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Icon(widget.icon, size: widget.iconSize, color: widget.color)
        .alignment(Alignment.center)
        .ripple()
        .constrained(width: widget.size, height: widget.size)
        .backgroundColor(widget.backgroundColor)
        .elevation(
          pressed ? 0 : widget.size,
          borderRadius: BorderRadius.circular(widget.size / 2),
          shadowColor: widget.shadowColor,
        )
        .clipOval()
        .gestures(
            onTapChange: (tapState) => setState(() => pressed = tapState));
  }
}
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
