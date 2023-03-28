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

### 3.1 安装 Flutter SDK

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

其中 `Android Studio` 如果无法安装，可以使用 [Android Studio 中国镜像](https://developer.android.google.cn/studio/index.html) 进行安装，如果还不行，只能大家在学习的 QQ 群中互助一下了。

安装完 `Android Studio` 后，还需要安装 `Android SDK` ，同样的，我们需要设置 `Android SDK` 中国镜像，否则会很慢。

![图 1](images/dacb9c5c3164ed9fc95404dee812c9641c3895adbff0048be42e25705709b40f.png)

如图红框标注位置，填入国内源地址 [阿里云镜像](https://mirrors.aliyun.com/android.googlesource.com/) 后点 `Apply` 或 `OK` 键。

使用 `mac` 的同学，如果想使用 `iPhone` 模拟器，需要安装 `Xcode` ， 这个就直接使用官方的 App Store 进行安装就可以，速度可能比较慢，但目前没有可靠的镜像源。
