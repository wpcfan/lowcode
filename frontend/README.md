# Flutter 开发

## 1. Flutter 简介

Flutter 是 Google 开源的移动 UI 框架，可以快速在 iOS 和 Android 上构建高质量的原生用户界面。Flutter 可以与现有的代码一起工作。在全世界，Flutter 正在被越来越多的开发者和组织使用，并且 Flutter 是完全免费、开源的。

## 2. Flutter 特性

- 快速开发
- 热重载
- 响应式 UI
- 跨平台
- 原生性能
- 富有表现力和灵活的 UI

## 3. 环境搭建

### 3.1 安装 Flutter SDK 和 IDE

如果有条件，可以遵循 [官方文档](https://flutter.dev/docs/get-started/install) 进行安装，如果没有条件，可以使用 [flutter.cn](https://flutter.cn/docs/get-started/install) 提供的镜像进行安装。

- 下载 Flutter SDK

  - [Flutter SDK](https://docs.flutter.dev/get-started/install)

- 解压到指定目录

  - `D:\flutter` (Windows)
  - `/Users/username/flutter` (MacOS)
  - `/home/username/flutter` (Linux)

- 配置环境变量 PATH

  - 打开系统环境变量配置界面，添加 Flutter SDK 的 bin 目录到 PATH 环境变量中，比如 `D:\flutter\bin` (Windows)
  - 打开 `~/.bash_profile` 文件，添加 Flutter SDK 的 bin 目录到 PATH 环境变量中，比如 `/Users/username/flutter/bin` (MacOS)
  - 打开 `~/.bashrc` 文件，添加 Flutter SDK 的 bin 目录到 PATH 环境变量中，比如 `/home/username/flutter/bin` (Linux)

- 配置国内镜像

  - Linux/MacOS:

    - 打开 `~/.bash_profile` 文件，添加如下内容

      ```bash
      export PUB_HOSTED_URL=https://pub.flutter-io.cn
      export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
      ```

    - 执行 `source ~/.bash_profile` 命令，使配置生效

  - windows 11:

    - 在环境变量中添加 `PUB_HOSTED_URL` 和 `FLUTTER_STORAGE_BASE_URL` 变量，值分别为 `https://pub.flutter-io.cn` 和 `https://storage.flutter-io.cn`

- 安装 Android Studio

  - [Android Studio](https://developer.android.google.cn/studio/index.html)

  - 其中 `Android Studio` 如果无法安装，可以使用 [Android Studio 中国镜像](https://developer.android.google.cn/studio/index.html) 进行安装，如果还不行，只能大家在学习的 QQ 群中互助一下了。

  - 安装完 `Android Studio` 后，还需要安装 `Android SDK` ，同样的，我们需要设置 `Android SDK` 中国镜像，否则会很慢。
    ![图 1](images/dacb9c5c3164ed9fc95404dee812c9641c3895adbff0048be42e25705709b40f.png)

  - 如图红框标注位置，填入国内源地址 [阿里云镜像](https://mirrors.aliyun.com/android.googlesource.com/) 后点 `Apply` 或 `OK` 键。

  - 然后点击 `SDK Tools` 标签，勾选 `Android SDK Build-Tools` 和 `Android SDK Platform-Tools` 两项，然后点击 `Apply` 或 `OK` 键。

  - 选择 `Android SDK` 的版本，点击 `Apply` 或 `OK` 键。

  - 接下来需要创建一个 `Android Virtual Device` ，点击 `AVD Manager` 标签，点击 `Create Virtual Device` 按钮，选择 `Phone` 类型，然后选择 `Pixel 2`，点击 `Next` 按钮，选择一个 Android 版本，点击 `Next` 按钮，选择 `Q`，点击 `Finish` 按钮。

  - 安装插件

    - 打开 `Android Studio`，点击左下角的扩展图标，搜索 `Flutter` 插件，安装即可。

    - 如果安装过程中出现问题，可以参考 [Android Studio 安装 Flutter 插件](https://flutter.cn/docs/get-started/editor?tab=androidstudio#androidstudio) 进行安装。

- 安装 Xcode

  - [Xcode](https://developer.apple.com/xcode/)

  - 使用 `mac` 的同学，如果想使用 `iPhone` 模拟器，需要安装 `Xcode` ， 这个就不用多说了。

- 安装 Chrome

  - [Chrome](https://www.google.cn/chrome/)

- 安装 VSCode

  - [VSCode](https://code.visualstudio.com/)

  - 安装 `VSCode` 后，需要安装 `Dart` 和 `Flutter` 插件，安装方法如下：

    - 打开 `VSCode`，点击左下角的扩展图标，搜索 `Dart` 和 `Flutter` 插件，安装即可。

    - 如果安装过程中出现问题，可以参考 [VSCode 安装 Dart 和 Flutter 插件](https://flutter.cn/docs/get-started/editor?tab=vscode#vscode) 进行安装。

- 验证安装

  - 打开终端，输入 `flutter doctor`，如果出现如下内容，说明安装成功

  ```bash
  Doctor summary (to see all details, run flutter doctor -v):
  [✓] Flutter (Channel stable, 3.7.8, on macOS 13.2.1 22D68 darwin-arm64, locale zh-Hans-CN)
  [✓] Android toolchain - develop for Android devices (Android SDK version 33.0.1)
  [✓] Xcode - develop for iOS and macOS (Xcode 14.2)
  [✓] Chrome - develop for the web
  [✓] Android Studio (version 2022.1)
  [✓] IntelliJ IDEA Ultimate Edition (version 2022.3.3)
  [✓] VS Code (version 1.76.2)
  [✓] Connected device (3 available)
  [✓] HTTP Host Availability

  • No issues found!
  ```
