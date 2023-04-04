# App 的图片类组件

我们在第一章介绍了大概的需求，现在我们再来专注于图片类组件的需求和实现。

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [App 的图片类组件](#app-的图片类组件)
  - [在“做”中理解需求](#在做中理解需求)
  - [Flutter 布局原则](#flutter-布局原则)
  - [挖掘隐性需求](#挖掘隐性需求)
  - [组件的比例放缩](#组件的比例放缩)
  - [适配边距](#适配边距)
  - [使用 Dart 的扩展方法改写](#使用-dart-的扩展方法改写)
  - [链接和点击](#链接和点击)
  - [实现一行两张图片的布局](#实现一行两张图片的布局)
    - [优化](#优化)
  - [实现大于 3 张图片的情况](#实现大于-3-张图片的情况)
    - [重构：怎样减少重复的代码](#重构怎样减少重复的代码)
    - [隐性需求：图片的加载与异常处理](#隐性需求图片的加载与异常处理)
    - [Flutter 中的 Assets 简介](#flutter-中的-assets-简介)

<!-- /code_chunk_output -->

## 在“做”中理解需求

由于图片类组件支持的图片数量不是固定的，每一种类型可能需要咨询 UI 设计师，因为一般来说一行一张图片的长宽比和一行两张图片的长宽比是不一样的。一行 3 张和一行多张可滚动也是应该分别有不同考虑的。

那么为了让大家在学习 `flutter` 的同时，实现一个比较完整的图片类组件，我们这里就以一行一张为例开始从简单到复杂的实现。

一个最简单的图片组件，只需要一个 `Image` 组件就可以了。我们先来看一下

```dart
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {

  const ImageRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://picsum.photos/600/300',
      /// 图片宽度
      width: 400,
      /// 图片高度
      height: 200,
      /// 图片填充方式
      /// BoxFit.fill: 全图显示，显示可能拉伸
      /// BoxFit.contain: 全图显示，显示原比例，不充满
      /// BoxFit.cover: 显示可能拉伸，充满，但不一定显示全部
      /// BoxFit.fitWidth: 宽度充满，显示可能拉伸
      /// BoxFit.fitHeight: 高度充满，显示可能拉伸
      /// BoxFit.scaleDown: 效果和 contain 差不多，但是此属性不允许显示超过源图片大小，可小不可大
      /// BoxFit.none: 不缩放
      /// 详情请参考：https://api.flutter.dev/flutter/painting/BoxFit.html
      fit: BoxFit.cover,
    );
  }
}
```

上面的代码比较简单，我们来看一下效果。

```dart
import 'package:flutter/material.dart';
const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        /// 设置主题，这里使用的是 dark 模式
        /// 也可以使用 ThemeData.light() 来设置 light 模式
      theme: ThemeData.dark().copyWith(
        /// 设置主题色
        /// 除了主题色，还有 accentColor、primaryColor、primaryColorDark、primaryColorLight 可以设置
        scaffoldBackgroundColor: darkBlue,
      ),
      /// 关闭 debug 模式的 banner
      debugShowCheckedModeBanner: false,
      /// Scaffold 是 Material 库中提供的页面脚手架，包含导航栏、抽屉、FloatingActionButton 等
      home: const Scaffold(
        body: Center(
          child: ImageRowWidget(),
        ),
      ),
    );
  }
}
```

![图 3](images/6dab707694e73705ea469a222e6f0ec951d49604e8e51e2497302c207bb4215b.png)

如果像上面那样，一张图的显示看起来还是比较简单的，但我们需要深入思考一下，这样的图片组件是否能满足我们的需求呢？

我们先来看一下我们的需求：

- 需求 1.1.1: 区块的定义就是一个包括内边距的矩形区域
- 需求 1.1.3: 图片行可以放一张图片，也可以放多张图片
  - 需求 1.1.3.1: 图片行中的图片是可以配置图片的链接以及点击跳转的链接
  - 需求 1.1.3.2: 一张图片时，图片按 `区块的宽度 - 2*内边距` 等比例缩放
  - 需求 1.1.3.3: 多于 3 张图片时，会形成可横向滑动的列表效果
  - 需求 1.1.3.4: 2-3 张图片时，会形成等宽的效果，也就是说，图片按 `区块的宽度 - 2*内边距 - 间距` 等比例缩放

我们不是单单要实现一个图片组件，而是要实现一个图片行组件，图片行要考虑的东西比较多，我们先来看一下最简单的一张图片的实现。简单来说，对一张图片而言，我们需要在之前的组件外面包裹一层 `Padding` 组件，然后设置 `Padding` 组件的 `padding` 属性，这样就可以实现图片的内边距了。

```dart
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
  const ImageRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.network(
        'https://picsum.photos/600/300',
        width: 400,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
```

为了约束图片的宽高，我们还需要在其外层再包裹一层 `ConstrainedBox` 组件，然后设置 `ConstrainedBox` 组件的 `constraints` 属性，这样就可以实现图片的宽高了。

```dart
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
  const ImageRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 200,
        minWidth: 400,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.network(
          'https://picsum.photos/600/300',
          width: 400,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
```

那么为什么图片一届指定了宽高，还要再包裹一层 `ConstrainedBox` 组件呢？这是因为 Flutter 中组件的大小其实是由其父组件来决定的，我们在 `Image` 组件中设置了 `width` 和 `height` 属性，但是这些属性只是作为 `Image` 组件的建议值，而不是强制值，所以我们需要在其外层再包裹一层 `ConstrainedBox` 组件，然后设置 `ConstrainedBox` 组件的 `constraints` 属性，这样就可以实现图片的宽高了。

## Flutter 布局原则

这里单独提一下 Flutter 布局的原则： `Constraints go down. Sizes go up. Parent sets position.` 。

1. 组件从其父组件处获取约束，一个约束简单讲是 4 个值：最小宽度、最大宽度、最小高度、最大高度。
2. 然后这个组件循环遍历其子组件，将其约束传递给子组件。然后询问子组件想要的大小。
3. 然后，这个组件对其子组件逐个进行位置的排列（横向的 x 坐标和纵向的 y 坐标）。
4. 最后，这个组件将其大小告诉它的父组件。

![图 4](images/88b1ecd47c54c6962745842f276cec3a9eb427cd990d0435b15bd7f1c7dd7d45.png)

以上图为例子，我们拟人一下这个过程，上图的整体是一个组件，我们给它起个名字 `W` ，这个组件 `W` 有两个子组件分别是 `FIRST CHILD` 和 `SECOND CHILD`。

1. 首先 `W` 询问它的父组件 `P` 有什么约束 ？
2. 父组件 `P` 回答 `W` ，你必须保证宽度在 `80px` 到 `300px` 之间，高度在 `30px` 到 `85px` 之间。
3. `W` 自己想要 5 个像素的内边距，这样 `W` 的子组件最多拥有 290px 的宽度和 75px 的高度。
4. 于是 `W` 对第一个子组件 `FIRST CHILD` 说，你的宽度必须在 `0` 到 `290px` 之间，你的高度必须在 `0` 到 `75px` 之间。
5. `FIRST CHILD` 回答 `W` ，我想要 `290px` 的宽度和 `20px` 的高度。
6. `W` 对第二个子组件 `SECOND CHILD` 说，你的宽度必须在 `0` 到 `290px` 之间，你的高度必须在 `0` 到 `55px` 之间。
7. `SECOND CHILD` 回答 `W` ，我想要 `140px` 的宽度和 `30px` 的高度。
8. `W` 知道了所有子组件的大小，于是它开始排列子组件的位置，`FIRST CHILD` 的位置是 `(5, 5)` ，`SECOND CHILD` 的位置是 `(80, 25)` 。
9. `W` 知道了自己的大小，于是它告诉父组件 `P` ，我想要 `300px` 的宽度和 `60px` 的高度。

因此，这时我们可以看出 Flutter 的布局上有自身的限制，当然任何其他的框架都是如此。这些限制有以下几点：

- 一个组件仅在其父组件给其约束的情况下才能决定自身的大小。这意味着组件通常情况下 **不能任意获得其想要的大小**。
- 一个组件 **无法知道，也不需要决定**其在屏幕中的位置。因为它的位置是由其父组件决定的。
- 由于父组件自身也有父组件，因此组件的大小位置是由整个组件树决定的。
- 如果子级想要拥有的大小，但父级没有足够的空间，子级的设置的大小可能会不生效。当定义了对齐方式的时候，尤其需要注意这一点。

之所以单独一节来讲 flutter 布局，一方面是因为这是 flutter 的核心，另一方面是因为在我们的项目中，后端 API 会下发数据给前端 App，App 根据这个数据进行渲染，但这个数据最好是能贴合前端的渲染方式，否则前端会觉得不方便或者很难实现。这也是全栈技能的重要性，你会同时知道前端和后端的需求，然后进行协调。

## 挖掘隐性需求

上面的例子中，我们只是简单的将图片的宽高设置为固定值，但是在实际开发中，我们需要根据屏幕的宽度来动态的设置图片，这里其实就遇到了一个最开始我们没有考虑到的需求：设备适配。

要知道不同的设备屏幕分辨率是不一样的，如果我们不做适配，那么在不同的设备上显示的图片就会不一样，这显然是不合理的。因此，我们需要根据屏幕的宽度来动态的设置图片。

当然，我们考虑到边距的问题，其实边距也应该是根据屏幕的宽度来动态的设置。如果进一步的扣一下细节，字体要不要呢？所以你看，适配是一个相当复杂的问题。

要把需求真正落地，我们还是需要约束需求的范围，否则就是一个设备适配就可以把我们搞崩溃。因此，我们需要把需求的范围缩小到一个合理的范围，这样才能更好的实现需求。

下面我们来考虑一下如何进行适配，还是通过修改之前的代码来实现。

```dart
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
    final String imageUrl;
    final double paddingVertical;
    final double paddingHorizontal;
    final double height;
    final double borderRadius;

    const ImageRowWidget({
        super.key,
        this.imageUrl = 'https://picsum.photos/600/300',
        this.paddingVertical = 8.0,
        this.paddingHorizontal = 16.0,
        this.height = 200.0,
        this.borderRadius = 8.0,
    });

    @override
    Widget build(BuildContext context) {
        /// 1. 获取屏幕宽度
        final screenWidth = MediaQuery.of(context).size.width;
        /// 2. 计算图片宽度
        final imageWidth = screenWidth - 2 * paddingHorizontal;
        /// 3. 计算图片高度
        final imageHeight = height - 2 * paddingVertical;

        return ConstrainedBox(
            /// 4.限定高度
            constraints: BoxConstraints(minWidth: screenWidth, minHeight: height).tighten(height: height),
            child: Padding(
                /// 5. 添加内边距
                padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
                child: ClipRRect(
                    /// 6. 添加圆角
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.network(
                        imageUrl,
                        width: imageWidth,
                        height: imageHeight,
                        /// 7. 图片填充方式
                        fit: BoxFit.cover,
                    ),
                ),
            )
        );
    }
}
```

得到的效果呢，就是这个样子：

![图 1](images/905b4a6cacd13a8ef6b25d840b49ce76f29b702d16e7d8fca38aa4deadb46aac.png)

你可尝试调整模拟器的宽度，看看图片的宽度是否会随着屏幕的宽度而变化。

## 组件的比例放缩

前面的例子中，我们已经实现了图片的宽度随着屏幕的宽度而变化，但是图片的高度还是固定的，这显然是不合理的。因此，我们需要根据屏幕的宽度来动态的设置图片的高度。

当然，有一些组件或者 UI 上设计要求定高的，但大部分情况下，我们都是需要根据屏幕的宽度来动态的设置图片的高度。因为这样最能符合很多公司要求高度还原设计稿的需求。

但是如果要按比例放缩，存在一个问题，比例我们需要 2 个数字，我们现在可以得到屏幕宽度，另一个数字呢？应该就是设计稿给出的宽度了，一般公司的 UI 设计都给出一个设计时使用的屏幕宽度，我们这里把这个数字叫做 `基准屏幕宽度` 。我们这里的比例就是 `屏幕宽度 / 基准屏幕宽度` 。因此修改一下上面的代码，我们再引入一个成员变量 `baseScreenWidth` ，用来表示基准屏幕宽度。

```dart
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
    final String imageUrl;
    final double paddingVertical;
    final double paddingHorizontal;
    final double height;
    final double borderRadius;
    final double baseScreenWidth;

    const ImageRowWidget({
        super.key,
        this.imageUrl = 'https://picsum.photos/600/300',
        this.paddingVertical = 8.0,
        this.paddingHorizontal = 16.0,
        this.height = 200.0,
        this.borderRadius = 8.0,
        this.baseScreenWidth = 375.0,
    });

    @override
    Widget build(BuildContext context) {
        /// 1. 获取屏幕宽度
        final screenWidth = MediaQuery.of(context).size.width;
        /// 2. 计算图片宽度
        final imageWidth = screenWidth - 2 * paddingHorizontal;
        /// 3. 计算比例
        final scale = screenWidth / baseScreenWidth;
        /// 4. 计算区块高度
        final blockHeight = height * scale;
        /// 5. 计算图片高度
        final imageHeight = blockHeight - 2 * paddingVertical;

        return ConstrainedBox(
            /// 6.限定高度
            constraints: BoxConstraints(minWidth: screenWidth, minHeight: blockHeight).tighten(height: blockHeight),
            child: Padding(
                /// 7. 添加内边距
                padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
                child: ClipRRect(
                    /// 8. 添加圆角
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.network(
                        imageUrl,
                        width: imageWidth,
                        height: imageHeight,
                        /// 9. 图片填充方式
                        fit: BoxFit.cover,
                    ),
                ),
            )
        );
    }
}
```

现在你调整模拟器的宽度，看看图片的高度是否会随着屏幕的宽度而变化。

![图 5](images/e3315ae14343554ef4e67749886feffa6070c9c7ad6c36a08887ac2eb3a70129.png)

![图 6](images/e8c748fdad8a1cc10bc68068082fc983332e6174e6c83101aa40f4fa9ec0fcd3.png)

## 适配边距

前面的例子中，我们已经实现了图片的宽度和高度随着屏幕的宽度而变化，但是图片的内边距还是固定的，这个如果是要求较严格的 UI 设计，可能也会需要根据屏幕的宽度来动态的设置图片的内边距。这可以避免在小屏幕上出现过大的内边距，或者在大屏幕上出现过小的内边距。

再修改一下前面的代码

```dart
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
    final String imageUrl;
    final double paddingVertical;
    final double paddingHorizontal;
    final double height;
    final double borderRadius;
    final double baseScreenWidth;

    const ImageRowWidget({
        super.key,
        this.imageUrl = 'https://picsum.photos/600/300',
        this.paddingVertical = 8.0,
        this.paddingHorizontal = 16.0,
        this.height = 200.0,
        this.borderRadius = 8.0,
        this.baseScreenWidth = 375.0,
    });

    @override
    Widget build(BuildContext context) {
        /// 1. 获取屏幕宽度
        final screenWidth = MediaQuery.of(context).size.width;
        /// 2. 计算比例
        final scale = screenWidth / baseScreenWidth;
        /// 3. 计算水平内边距
        final scaledPaddingHorizontal = paddingHorizontal * scale;
        /// 4. 计算垂直内边距
        final scaledPaddingVertical = paddingVertical * scale;
        /// 5. 计算图片宽度
        final imageWidth = screenWidth - 2 * scaledPaddingHorizontal;
        /// 6. 计算区块高度
        final blockHeight = height * scale;
        /// 7. 计算图片高度
        final imageHeight = blockHeight - 2 * scaledPaddingVertical;

        return ConstrainedBox(
            /// 8.限定高度
            constraints: BoxConstraints(minWidth: screenWidth, minHeight: blockHeight).tighten(height: blockHeight),
            child: Padding(
                /// 9. 添加内边距
                padding: EdgeInsets.symmetric(vertical: scaledPaddingVertical, horizontal: scaledPaddingHorizontal),
                child: ClipRRect(
                    /// 10. 添加圆角
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.network(
                        imageUrl,
                        width: imageWidth,
                        height: imageHeight,
                        /// 11. 图片填充方式
                        fit: BoxFit.cover,
                    ),
                ),
            )
        );
    }
}
```

## 使用 Dart 的扩展方法改写

由于 Flutter 的特点是一层层的 `Widget` 嵌套，这导致一个问题，就是如果嵌套多了的情况下会造成几个问题

1. 代码不清晰：嵌套太多会很难找到对应的组件，或者理清楚其中的逻辑。
2. 修改比较繁琐：在开发阶段，我们经常可能会改变这个树的层次或者内部结构，这种嵌套结构改起来比较费力。

当然一般做法可以把一些子组件抽取出来，抽象为单独的组件。另一种方式其实是利用 `dart` 的扩展方法来帮我们把嵌套的写法变为 `builder` 的模式。

那么什么是扩展方法？扩展方法就是在一个类上添加一个方法，这个方法可以直接在类的实例上调用，就好像是这个类的方法一样。这个方法的实现是在另一个类中实现的，这个类就是扩展方法的 `receiver`。

这么说还是有点抽象，我们来看一个例子。下面的代码中，我们创建了 `WidgetExtension` 类，然后在这个类中添加了一个 `padding` 方法，这个方法的 `receiver` 是 `Widget` 类，也就是说这个方法可以在 `Widget` 类的实例上调用。

```dart
extension WidgetExtension on Widget {

  Widget padding({
    Key? key,
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Padding(
        key: key,
        padding: EdgeInsets.only(
          top: top ?? vertical ?? all ?? 0.0,
          bottom: bottom ?? vertical ?? all ?? 0.0,
          left: left ?? horizontal ?? all ?? 0.0,
          right: right ?? horizontal ?? all ?? 0.0,
        ),
        child: this,
      );
}
```

具体来讲，这个 `padding` 方法的作用就是在 `Widget` 的外面包一层 `Padding` 组件，这样就可以在 `Widget` 的外面添加内边距了。

```dart
Padding(
  padding: EdgeInsets.all(16.0),
  child: Text('Hello World'),
)
```

上面的代码可以改写为

```dart
Text('Hello World').padding(all: 16.0)
```

这样就可以非常简洁的添加内边距了，而且易于维护，比如以后我们不想要 padding 了，就直接删掉 `.padding(all: 16.0)` 就行了。

我们再来定义几个扩展方法，`constrained` 用来替代嵌套 `ConstrainedBox` ，而 `clipRRect` 用来替代嵌套 `ClipRRect`

```dart
extension WidgetExtension on Widget {

  Widget constrained({
    Key? key,
    double? width,
    double? height,
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    BoxConstraints constraints = BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
    constraints = (width != null || height != null)
        ? constraints.tighten(width: width, height: height)
        : constraints;
    return ConstrainedBox(
      key: key,
      constraints: constraints,
      child: this,
    );
  }

  Widget clipRRect({
    Key? key,
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) =>
      ClipRRect(
        key: key,
        clipper: clipper,
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? all ?? 0.0),
          topRight: Radius.circular(topRight ?? all ?? 0.0),
          bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
          bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
        ),
        child: this,
      );
}
```

根据之前的扩展方法，我们改写一下 `ImageRowWidget`

```dart
import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
  final String imageUrl;
  final double screenWidth;
  final double blockHeight;
  final double scaledPaddingVertical;
  final double scaledPaddingHorizontal;
  final double borderRadius;

  const ImageRowWidget({
    Key? key,
    required this.imageUrl,
    required this.screenWidth,
    required this.blockHeight,
    required this.scaledPaddingVertical,
    required this.scaledPaddingHorizontal,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 1. 获取屏幕宽度
    final screenWidth = MediaQuery.of(context).size.width;
    /// 2. 计算比例
    final scale = screenWidth / baseScreenWidth;
    /// 3. 计算水平内边距
    final scaledPaddingHorizontal = paddingHorizontal * scale;
    /// 4. 计算垂直内边距
    final scaledPaddingVertical = paddingVertical * scale;
    /// 5. 计算图片宽度
    final imageWidth = screenWidth - 2 * scaledPaddingHorizontal;
    /// 6. 计算区块高度
    final blockHeight = height * scale;
    /// 7. 计算图片高度
    final imageHeight = blockHeight - 2 * scaledPaddingVertical;

    return Image.network(
      imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: BoxFit.cover,
    ).clipRRect(
      all: borderRadius,
    ).padding(
      vertical: scaledPaddingVertical,
      horizontal: scaledPaddingHorizontal,
    ).constrained(
      width: screenWidth,
      height: blockHeight,
    );
  }
}
```

大家可以明显看到这种写法非常简洁，而且易于维护，所以在后面的代码中我们会尽量使用这种写法，但不是所有都这样，遇到新的扩展方法我会提到，但不会逐字敲这个扩展方法了。

我们在 `common/lib/extensions/widget_extensions.dart` 中写了很多这种扩展方法，这个类就留给大家进行阅读和练习，大部分的扩展方法其实就是一个转换器，把嵌套写法转换为了 `builder` 的方式。

## 链接和点击

在 `ImageRowWidget` 中，我们还需要实现点击事件，这个点击事件的实现其实就是在 `ImageRowWidget` 上包一层 `GestureDetector` 组件，然后在 `onTap` 回调中执行点击事件的逻辑。

```dart
GestureDetector(
  onTap: () {
    print('点击了图片');
  },
  child: Image.network(
    imageUrl,
    width: imageWidth,
    height: imageHeight,
    fit: BoxFit.cover,
  ).clipRRect(
    all: borderRadius,
  ).padding(
    vertical: scaledPaddingVertical,
    horizontal: scaledPaddingHorizontal,
  ).constrained(
    width: screenWidth,
    height: blockHeight,
  ),
)
```

这样就可以实现点击事件了，但是这样写的话，代码就会显得很冗余，所以我们可以把 `GestureDetector` 也封装成一个扩展方法，这样就可以非常简洁的实现点击事件了。

```dart
extension WidgetExtension on Widget {
  Widget onTap(VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: this,
      );
}
```

这样可以简化代码为

```dart
Image.network(
  imageUrl,
  width: imageWidth,
  height: imageHeight,
  fit: BoxFit.cover,
).clipRRect(
  all: borderRadius,
).padding(
  vertical: scaledPaddingVertical,
  horizontal: scaledPaddingHorizontal,
).constrained(
  width: screenWidth,
  height: blockHeight,
).onTap(() {
  print('点击了图片');
})
```

当然，这个扩展方法我们只处理了 `onTap` 事件，如果要处理其他的事件，大家可以参考 `common/lib/extensions/widget_extensions.dart` 中的 `gestures` 方法的写法。

所以上面的代码可以改写为

```dart
Image.network(
  imageUrl,
  width: imageWidth,
  height: imageHeight,
  fit: BoxFit.cover,
).clipRRect(
  all: borderRadius,
).padding(
  vertical: scaledPaddingVertical,
  horizontal: scaledPaddingHorizontal,
).constrained(
  width: screenWidth,
  height: blockHeight,
).gestures(
  onTap: () {
    print('点击了图片');
  },
)
```

请注意在 Flutter 中有多个处理点击的组件，比如 `GestureDetector`、`InkWell` 等，而 `GestureDetector` 和 `InkWell` 的区别是，`GestureDetector` 只是一个手势识别器，而 `InkWell` 是一个 `Material` 组件，所以 `InkWell` 会有水波纹的效果，而 `GestureDetector` 没有。在 `common/lib/extensions/widget_extensions.dart` 中，我们也封装了 `InkWell` 的扩展方法 `inkWell`，大家可以参考一下。

在点击事件中，我们当然不能只是打印一下，我们还需要做后续的处理，这里我们来讨论一下，点击事件应该传递给谁来处理，这个问题其实是一个设计问题，我们可以把点击事件传递给 `ImageRowWidget` 的父组件，也可以把点击事件在 `ImageRowWidget` 自己内部处理，这两种方式各有优缺点，我们来分析一下。

- 传递给父组件：这种方式的优点是，点击事件的处理逻辑可以在父组件中统一处理，逻辑更为统一，易于维护；缺点是需要如果一个比较复杂的页面组件的构建中，这种传递可能会有很多层。
- 在自己内部处理：这种方式的优点是，逻辑比较简单，不需要传递；缺点是，由于逻辑分散在各处，不易于维护。

我个人的习惯是采用第一种方式处理，因为我认为在一个比较复杂的页面中，点击事件的处理逻辑应该是比较统一的，所以我会把点击事件传递给父组件，然后在父组件中统一处理。

那么采用第一种方式的话，我们需要在 `ImageRowWidget` 中定义一个点击事件的回调，然后在 `ImageRowWidget` 的父组件中实现这个回调，这样就可以实现点击事件的处理了。请注意 `VoidCallback` 是一个函数类型，它的定义为 `typedef VoidCallback = void Function();`，和 `TypeScript` 类似，函数是一等公民，所以我们可以把函数作为参数传递给其他函数。

```dart
class ImageRowWidget extends StatelessWidget {
    final String imageUrl;
    final double paddingVertical;
    final double paddingHorizontal;
    final double height;
    final double borderRadius;
    final double baseScreenWidth;
    final VoidCallback? onTap;

    const ImageRowWidget({
        super.key,
        this.imageUrl = 'https://picsum.photos/600/300',
        this.paddingVertical = 8.0,
        this.paddingHorizontal = 16.0,
        this.height = 200.0,
        this.borderRadius = 8.0,
        this.baseScreenWidth = 375.0,
        this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      /// 1. 获取屏幕宽度
      final screenWidth = MediaQuery.of(context).size.width;
      /// 2. 计算比例
      final scale = screenWidth / baseScreenWidth;
      /// 3. 计算水平内边距
      final scaledPaddingHorizontal = paddingHorizontal * scale;
      /// 4. 计算垂直内边距
      final scaledPaddingVertical = paddingVertical * scale;
      /// 5. 计算图片宽度
      final imageWidth = screenWidth - 2 * scaledPaddingHorizontal;
      /// 6. 计算区块高度
      final blockHeight = height * scale;
      /// 7. 计算图片高度
      final imageHeight = blockHeight - 2 * scaledPaddingVertical;

      return Image.network(
        imageUrl,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
      ).clipRRect(
        all: borderRadius,
      ).padding(
        vertical: scaledPaddingVertical,
        horizontal: scaledPaddingHorizontal,
      )
      .constrained(
        width: screenWidth,
        height: blockHeight,
      )
      .gestures(
        onTap: onTap
      );
    }
}
```

然后我们在它的父组件中实现这个回调

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ImageRowWidget(onTap: () => debugPrint('clicked')),
        ),
      ),
    );
  }
}
```

对于我们的需求来说，我们需要在点击的时候打开一个新的 `URL` ，或者是一个 HTTP 地址或者是一个路由路径，所以我们需要在回调中传递一个参数，这个参数就是我们要打开的地址，所以我们需要把 `VoidCallback` 改为 `ValueCallback<String>`，这个 `ValueCallback` 的定义为 `typedef ValueCallback<T> = void Function(T value);`，它是一个泛型函数类型，我们可以传递一个参数给它，然后在回调中使用这个参数。但是我们从哪里获得这个跳转的 URL 呢？很显然这也应该是在外部传递进来的，所以此时我们要求外部给的数据不只是一个图片地址，而且还有这个图片地址对应的跳转地址，这要求一个数据结构

```dart
class ImageData {
  final String imageUrl;
  final String link;

  const ImageData({
    required this.image,
    this.link,
  });
}
```

但一个字符串的 `link` 是否可以满足我们的需求呢？我们需要支持两种跳转方式，一种是打开一个 `URL`，一种是打开一个路由，一般这种时候，需要一个枚举类型来体现，我们建立一个 `LinkType` 的枚举类型。然后我们新建一个 `MyLink` 的数据类型，它包含了 `LinkType` 和 `String` 类型的 `value`，这样我们就可以通过 `MyLink` 来表示我们的跳转地址了。

```dart
enum LinkType {
  url('url'),
  route('route'),
  ;

  final String value;
  const LinkType(this.value);
}
class MyLink {
  final LinkType type;
  final String value;

  const MyLink({
    required this.type,
    required this.value,
  });
}
```

我们需要把这样一个跳转地址结构和图片地址结构组合起来，所以我们需要一个新的数据结构

```dart
class ImageData {
  final String imageUrl;
  final MyLink link;

  const ImageData({
    required this.imageUrl,
    required this.link,
  });
}
```

那么我们可以改写 `ImageRowWidget` ，我们需要把 `imageUrl` 改为 `ImageData` 类型，然后在回调中传递 `MyLink` 类型的参数，这样我们就可以在回调中使用这个参数了。

```dart
class ImageRowWidget extends StatelessWidget {
  final ImageData imageData;
  final double paddingVertical;
  final double paddingHorizontal;
  final double height;
  final double borderRadius;
  final double baseScreenWidth;
  final ValueCallback<MyLink>? onTap;

  const ImageRowWidget({
      super.key,
      required this.imageData,
      this.paddingVertical = 8.0,
      this.paddingHorizontal = 16.0,
      this.height = 200.0,
      this.borderRadius = 8.0,
      this.baseScreenWidth = 375.0,
      this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / baseScreenWidth;
    final scaledPaddingHorizontal = paddingHorizontal * scale;
    final scaledPaddingVertical = paddingVertical * scale;
    final imageWidth = screenWidth - 2 * scaledPaddingHorizontal;
    final blockHeight = height * scale;
    final imageHeight = blockHeight - 2 * scaledPaddingVertical;

    return Image.network(
      imageData.imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: BoxFit.cover,
    ).clipRRect(
      all: borderRadius,
    ).padding(
      vertical: scaledPaddingVertical,
      horizontal: scaledPaddingHorizontal,
    )
    .constrained(
      width: screenWidth,
      height: blockHeight,
    )
    .gestures(
      onTap: () => onTap?.call(imageData.link)
    );
  }
}
```

注意， `onTap?.call(imageData.link)` 这里的 `?.` 是空安全运算符，它的作用是如果 `onTap` 为 `null`，则不会调用 `call` 方法，否则会调用 `call` 方法，而函数的 `call` 方法是可以省略的，所以我们可以写成 `onTap?.(imageData.link)`，其实就是执行这个函数。

这样我们就可以在回调中使用这个参数了，我们可以根据这个参数的类型来判断是打开一个 `URL` 还是打开一个路由

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ImageRowWidget(
            imageData: const ImageData(
              imageUrl: 'https://picsum.photos/600/300',
              link: MyLink(
                type: LinkType.url,
                value: 'https://baidu.com'
              )
            ),
            onTap: (link) {
              if (link.type == LinkType.url) {
                /// 处理 URL
                debugPrint('link is ${link.value}');
              } else if (link.type == LinkType.route) {
                /// 处理路由
                Navigator.of(context).pushNamed(link.value);
              }
            }
          ),
        ),
      ),
    );
  }
}
```

## 实现一行两张图片的布局

如果要实现一行两张的布局，首先要明确一点，就是这两张图片的宽度是一样的，并且多了一个图片间距，所以成员变量上需要引入一个 `horizontalSpacing`，这个变量的值就是图片间距的大小。而单个的 `imageData` 也应该是一个数组，所以我们需要把 `imageData` 改为 `List<ImageData>` 类型，然后在 `build` 方法中，我们需要把 `Image.network` 改为 `Row`，然后在 `Row` 中放置两个 `Image.network`，这样就可以实现一行两张图片的布局了。

```dart
class ImageRowWidget extends StatelessWidget {
  final List<ImageData> imageData;
  final double paddingVertical;
  final double paddingHorizontal;
  final double height;
  final double borderRadius;
  final double baseScreenWidth;
  final double horizontalSpacing;
  final ValueCallback<MyLink>? onTap;

  const ImageRowWidget({
      super.key,
      required this.imageData,
      this.paddingVertical = 8.0,
      this.paddingHorizontal = 16.0,
      this.height = 200.0,
      this.borderRadius = 8.0,
      this.baseScreenWidth = 375.0,
      this.horizontalSpacing = 8.0,
      this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / baseScreenWidth;
    final scaledPaddingHorizontal = paddingHorizontal * scale;
    final scaledPaddingVertical = paddingVertical * scale;
    final imageWidth = (screenWidth - 2 * scaledPaddingHorizontal - (imageData.length - 1) * horizontalSpacing) / imageData.length;
    final blockHeight = height * scale;
    final imageHeight = blockHeight - 2 * scaledPaddingVertical;

    return Row(
      children: [
        Image.network(
          imageData[0].imageUrl,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover,
        ).clipRRect(
          all: borderRadius,
        ).gestures(
          onTap: () => onTap?.call(imageData[0].link)
        ),
        SizedBox(width: horizontalSpacing),
        Image.network(
          imageData[1].imageUrl,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover,
        ).clipRRect(
          all: borderRadius,
        ).gestures(
          onTap: () => onTap?.call(imageData[1].link)
        ),
      ],
    ).padding(
      vertical: scaledPaddingVertical,
      horizontal: scaledPaddingHorizontal,
    )
    .constrained(
      width: screenWidth,
      height: blockHeight,
    );
  }
}
```

调用的代码如下：

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ImageRowWidget(
            imageData: const [
              ImageData(
                imageUrl: 'https://picsum.photos/600/300',
                link: MyLink(
                  type: LinkType.url,
                  value: 'https://bing.com'
                )
              ),
              ImageData(
                imageUrl: 'https://picsum.photos/600/300',
                link: MyLink(
                  type: LinkType.url,
                  value: 'https://baidu.com'
                )
              ),
            ],
            onTap: (link) {
              if (link.type == LinkType.url) {
                /// 处理 URL
                debugPrint('link is ${link.value}');
              } else if (link.type == LinkType.route) {
                Navigator.of(context).pushNamed(link.value);
              }
            }
          ),
        ),
      ),
    );
  }
}
```

然后你可以看到下面的效果：

![图 7](images/3a63ab0739f0c4df9c4c71b2533d86f2ca86f14d6714715a852e446183ddd506.png)

### 优化

上面代码的第一个问题在于直接引用了数组的下标，这样会导致数组越界的问题，我们先使用 `for` 循环来遍历数组，然后在 `for` 循环中返回一个 `Image.network`，这样就可以避免数组越界的问题了。

```dart
Row(
  children: [
    for (var i = 0; i < imageData.length; i++) Image.network(
      imageData[i].imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: BoxFit.cover,
    ).clipRRect(
      all: borderRadius,
    ).gestures(
      onTap: () => onTap?.call(imageData[i].link)
    ),
  ],
).padding(
  vertical: scaledPaddingVertical,
  horizontal: scaledPaddingHorizontal,
)
.constrained(
  width: screenWidth,
  height: blockHeight,
)
```

但我个人不是很喜欢在 Widget 的嵌套中直接使用 `for` 循环，好在 `Dart` 对于函数的支持非常好，所以下面我们使用 List 的 `map` 方法来遍历数组，然后在 `map` 方法中返回一个 `Image.network`，这样就可以避免数组越界的问题了。

```dart
Row(
  children: imageData.map((e) => Image.network(
    e.imageUrl,
    width: imageWidth,
    height: imageHeight,
    fit: BoxFit.cover,
  ).clipRRect(
    all: borderRadius,
  ).gestures(
    onTap: () => onTap?.call(e.link)
  )).toList(),
).padding(
  vertical: scaledPaddingVertical,
  horizontal: scaledPaddingHorizontal,
)
.constrained(
  width: screenWidth,
  height: blockHeight,
)
```

但是这样的话，我们漏掉了间距，所以我们需要循环中间插入一个 `SizedBox`，这样就可以实现间距了，但需要注意最后一个 `SizedBox` 不需要插入，所以我们需要在循环中判断一下，如果是最后一个元素，就不需要插入 `SizedBox` 了。

```dart
Row(
  children: imageData.map((e) {
    final isLast = imageData.last == e;
    return [
      Image.network(
        e.imageUrl,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
      ).clipRRect(
        all: borderRadius,
      ).gestures(
        onTap: () => onTap?.call(e.link)
      ),
      if (!isLast) SizedBox(width: horizontalSpacing),
    ];
  }).expand((element) => element).toList(),
).padding(
  vertical: scaledPaddingVertical,
  horizontal: scaledPaddingHorizontal,
)
.constrained(
  width: screenWidth,
  height: blockHeight,
)
```

`expand` 方法可以将一个 `List<List<T>>` 转换为 `List<T>`，所以我们可以使用 `expand` 方法来将 `List<List<Widget>>` 转换为 `List<Widget>`，可以把这个操作符看成一个数组的 `拍扁` 操作。

为了整体风格一致，我们希望可以把 `Row` 这种子组件是一个集合的组件也做一个扩展，下面我们对 `List<Widget>` 进行扩展，然后在扩展中实现 `toRow` 方法。

```dart
extension ListWidget<E> on List<Widget> {

  Widget toRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
  }) =>
      Row(
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: separator != null && isNotEmpty
            ? (expand((child) => [child, separator]).toList()..removeLast())
            : this,
      );

}
```

这样的话上面的代码就可以简化为：

```dart
imageData.map((e) {
  final isLast = imageData.last == e;
  return [
    Image.network(
      e.imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: BoxFit.cover,
    ).clipRRect(
      all: borderRadius,
    ).gestures(
      onTap: () => onTap?.call(e.link)
    ),
    if (!isLast) SizedBox(width: horizontalSpacing),
  ];
})
.expand((element) => element)
.toList()
.toRow()
.padding(
  vertical: scaledPaddingVertical,
  horizontal: scaledPaddingHorizontal,
)
.constrained(
  width: screenWidth,
  height: blockHeight,
)
```

事实上这个组件完美的兼容了多张图片的情况，我们可以在 `imageData` 中添加多张图片的数据，然后你可以看到下面的效果：

![图 8](images/9991fe67e5b51913aeb1291ba175c00cc2aef7588b92028cea2cb0d42f6f6877.png)

除了 `toRow` 方法，我们还可以实现 `toColumn`, `toStack` 和 `toWrap` 几个方法, 详情可以参考 `common/lib/extensions/list_widget_extensions.dart` 。

## 实现大于 3 张图片的情况

大于 3 张图片的情况，需要支持横向滚动，所以我们需要使用 `ListView` 来实现，但是 `ListView` 只能支持一个方向的滚动，所以我们需要使用 `ListView.builder` 来实现，`ListView.builder` 可以根据需要动态创建子组件，这样就可以实现横向滚动了。我们需要做一个判断，如果图片数量大于 3 张，就使用 `ListView.builder` 来实现，否则使用 `Row` 来实现。

```dart
final screenWidth = MediaQuery.of(context).size.width;
final scale = screenWidth / baseScreenWidth;
final scaledPaddingHorizontal = paddingHorizontal * scale;
final scaledPaddingVertical = paddingVertical * scale;
/// 对于大于 3 张图片的情况，只显示 3 张，所以除的时候需要等于 3 其它情况下除的时候需要等于图片数量
final imageWidth = (screenWidth - 2 * scaledPaddingHorizontal - (imageData.length - 1) * horizontalSpacing) / (imageData.length > 3 ? 3 : imageData.length);
final blockHeight = height * scale;
final imageHeight = blockHeight - 2 * scaledPaddingVertical;
if (imageData.length > 3) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: imageData.length,
    itemBuilder: (context, index) => Image.network(
      imageData[index].imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: BoxFit.cover,
    ).clipRRect(
      all: borderRadius,
    ).gestures(
      onTap: () => onTap?.call(imageData[index].link)
    ),
    separatorBuilder: (BuildContext context, int index) => SizedBox(width: horizontalSpacing)
  ).padding(
    vertical: scaledPaddingVertical,
    horizontal: scaledPaddingHorizontal,
  )
  .constrained(
    width: screenWidth,
    height: blockHeight,
  );
} else {
  return Row(
    children: imageData.map((e) {
      final isLast = imageData.last == e;
      return [
        Image.network(
          e.imageUrl,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover,
        ).clipRRect(
          all: borderRadius,
        ).gestures(
          onTap: () => onTap?.call(e.link)
        ),
        if (!isLast) SizedBox(width: horizontalSpacing),
      ];
    })
    .expand((element) => element)
    .toList(),
  ).padding(
    vertical: scaledPaddingVertical,
    horizontal: scaledPaddingHorizontal,
  )
  .constrained(
    width: screenWidth,
    height: blockHeight,
  );
}
```

于是我们可以得到下面的效果：

![图 9](images/0019bc9f9cf8615743707c43aac0467f676015ea46dd3d6446202e4308aacfa3.png)

### 重构：怎样减少重复的代码

我们注意到上面的代码中，有很多重复的代码，首先图片本身的样式是一样的，所以我们可以把图片的样式抽取出来，然后在 `Row` 和 `ListView` 中使用，这样就可以减少重复的代码了。类似的，我们还可以把 `padding` 和 `constrained` 抽取出来，这样就可以减少重复的代码了。

`ListView` 是一个滚动的列表，它可以沿着水平或者垂直方向滚动，它的子组件必须是 `ListTile` 或者 `ListTile.divide`。`ListView` 有两个子类，一个是 `ListView.builder`，一个是 `ListView.separated`，它们的区别是 `ListView.builder` 更为灵活，可以根据需要动态创建子组件，而 `ListView.separated` 则是方便的创建带分隔的列表。

```dart
/// 这是一个函数，用于定义外层组件的样式
/// 也就是我们重构之前的 `padding` 和 `constrained` 方法
page({required Widget child}) => child
    .padding(horizontal: scaledPaddingHorizontal, vertical: scaledPaddingVertical)
    .constrained(width: screenWidth, height: blockHeight);
/// 这是一个函数，用于定义图片的样式
/// 也就是我们重构之前的在 `Row` 和 `ListView` 里面构建图片的代码
Widget buildImageWidget(ImageData imageData) => Image.network(
    imageData.imageUrl,
    width: imageWidth,
    height: imageHeight,
    fit: BoxFit.cover,
  ).clipRRect(
    all: borderRadius,
  ).gestures(
    onTap: () => onTap?.call(imageData.link)
  );
/// 大于 3 张图片的情况，返回横向滚动的 `ListView`
if (imageData.length > 3) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: imageData.length,
    itemBuilder: (context, index) => buildImageWidget(imageData[index]),
    separatorBuilder: (BuildContext context, int index) => SizedBox(width: horizontalSpacing)
  )
  .parent(page);
}
return imageData.map((e) {
  final isLast = imageData.last == e;
  return [
        buildImageWidget(e),
        if (!isLast) SizedBox(width: horizontalSpacing),
      ];
    })
  .expand((element) => element)
  .toList()
  .toRow()
  .parent(page);
```

上面代码中的 `parent` 方法的实现如下，其实已经在 `common/lib/extensions/widget_extensions.dart` 中实现了，我们可以直接使用。

```dart
typedef ParentCallback = Widget Function({required Widget child});
extension WidgetExtension on Widget {
   Widget parent(ParentCallback outer) => outer(child: this);
}
```

可以看出，这个扩展方法的作用就是把 `child` 作为参数传递给 `outer` 方法，然后返回 `outer` 方法的返回值，这样就可以实现把 `child` 作为参数传递给 `outer` 方法的效果了。也就是起到了在子组件上直接添加外层组件的效果。

### 隐性需求：图片的加载与异常处理

我们可以看到，上面的代码中，图片的加载是异步的，所以我们需要在图片加载之前显示一个占位图，图片加载完成之后再显示图片，如果图片加载失败，则显示一个错误图。这个需求是隐性的，我们需要自己去实现。

我们可以使用 `Image.network` 的 `loadingBuilder` 参数来实现图片加载的占位图，使用 `Image.network` 的 `errorBuilder` 参数来实现图片加载失败的错误图。

```dart
/// 这是一个函数，用于定义图片的样式
/// 也就是我们重构之前的在 `Row` 和 `ListView` 里面构建图片的代码
Widget buildImageWidget(ImageData imageData) => Image.network(
    imageData.imageUrl,
    width: imageWidth,
    height: imageHeight,
    fit: BoxFit.cover,
    /// 加载中的占位图
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ).center().constrained(width: width, height: height);
    },
    /// 加载失败的占位图，当然你也可以使用 Image.asset 来加载本地图片作为占位图
    errorBuilder: (context, error, stackTrace) {
      return const Placeholder(
        color: Colors.red,
      );
    },
  ).clipRRect(
    all: borderRadius,
  ).gestures(
    onTap: () => onTap?.call(imageData.link)
  );
```

隐性需求在实际开发中是很常见的，因为没人能够把所有的需求都写出来，所以我们需要自己去发现隐性需求，然后去实现它们。当然如果有时发现隐性需求比较多，那么我们可以把它们写在需求文档中，这样就可以避免遗漏了。

但是我们发现，现在这个函数过于大了，这时我们可以考虑重构了，我们可以把 `loadingBuilder` 和 `errorBuilder` 抽取出来，然后在 `buildImageWidget` 方法中调用它们。但是这里我们想采用另一种方案，我们为什么不封装一个适合我们项目的图片组件呢？这样我们就可以在项目中复用了。

```dart
/// 图片组件
/// 用于展示图片
/// 会根据图片的宽高比来自动计算高度
/// 以适应不同的屏幕
/// 可以通过 [height] 参数来指定高度
/// 可以通过 [width] 参数来指定宽度
/// 可以通过 [fit] 参数来指定图片的填充方式
/// 可以通过 [alignment] 参数来指定图片的对齐方式
/// 可以通过 [onTap] 参数来指定点击事件
class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.errorImage,
    this.link,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.alignment = Alignment.center,
    this.onTap,
  });
  final String imageUrl;
  final String? errorImage;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Alignment alignment;
  final MyLink? link;
  final void Function(MyLink?)? onTap;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,

      /// 加载中的占位图
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ).center().constrained(width: width, height: height);
      },

      /// 加载失败的占位图
      errorBuilder: (context, error, stackTrace) {
        return errorImage != null
            ? Image.asset(
                errorImage!,
                fit: fit,
                alignment: alignment,
                width: width,
                height: height,
              )
            : const Placeholder(
                color: Colors.red,
              );
      },
    ).gestures(onTap: () => onTap?.call(link));
  }
}
```

这样我们就可以在项目中复用了，我们可以在 `buildImageWidget` 方法中直接使用 `ImageWidget` 组件，这样就可以减少代码量了。

```dart
Widget buildImageWidget(ImageData imageData) => ImageWidget(
    imageUrl: imageData.imageUrl,
    errorImage: 'assets/images/error.png',
    width: imageWidth,
    height: imageHeight,
    fit: BoxFit.cover,
    onTap: (link) => onTap?.call(link),
  );
```

### Flutter 中的 Assets 简介

上面的代码中我们使用了 `Image.asset` 来加载本地图片，这里我们来简单介绍一下 Flutter 中的 Assets。在 Flutter 中，我们可以把一些图片、音频、视频等资源放在 `assets` 目录下，然后在 `pubspec.yaml` 文件中配置 `assets`，这样就可以在项目中使用这些资源了。

```yaml
flutter:
  assets:
    - assets/images/
```

在上面的代码中，我们把 `assets/images` 目录下的所有资源都配置到了 `assets` 中，这样我们就可以在项目中使用这些资源了。

```dart
Image.asset(
  'assets/images/error.png',
  fit: fit,
  alignment: alignment,
  width: width,
  height: height,
)
```

类似的，字体文件也可以放在 `assets` 目录下，然后在 `pubspec.yaml` 文件中配置 `fonts`，这样就可以在项目中使用这些字体了。

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
