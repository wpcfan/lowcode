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
