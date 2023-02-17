# Flutter App 开发

## 环境搭建

### 安装 VSCode

请访问 [VSCode 官网](https://code.visualstudio.com/) 下载安装。

### 安装 Flutter SDK

请访问 [Flutter 官网](https://flutter.dev/) 下载安装。如果你在国内，可以访问 [Flutter 中文网](https://flutter.cn/) 下载安装。

### 安装 Android SDK

请访问 [Android 官网](https://developer.android.com/studio) 下载安装。

### 配置 VSCode

### 配置 Flutter SDK

### 配置 Android SDK

### 配置模拟器

### 配置代理

### 配置 Gradle

### 配置 Flutter

## 创建 Flutter 项目

## 运行 Flutter 项目

## 配置 Flutter 项目

### 配置 Android

#### 配置 AndroidManifest.xml

如果需要访问网络，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

需要注意的是，如果是本机的服务器，模拟器默认是无法正确识别到主机的，所以在打开模拟器时，需要在命令行中执行如下命令：

```bash
adb reverse tcp:8080 tcp:8080
```

如果需要访问本地文件，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

如果需要访问相机，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

如果需要访问麦克风，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

如果需要访问通讯录，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

如果需要访问位置，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

如果需要访问电话，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

如果需要访问日历，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.READ_CALENDAR" />
```

如果需要访问短信，需要在 AndroidManifest.xml 中添加如下配置：

```xml
<uses-permission android:name="android.permission.READ_SMS" />
```

#### 配置 build.gradle

### 配置 iOS

#### 配置 Info.plist

如果需要访问网络，需要在 Info.plist 中添加如下配置：

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

如果需要其他常见权限，需要在 Info.plist 中添加如下配置：

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册</string>
<key>NSCameraUsageDescription</key>
<string>需要访问相机</string>
<key>NSMicrophoneUsageDescription</key>
<string>需要访问麦克风</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>需要访问位置</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>需要访问位置</string>
<key>NSContactsUsageDescription</key>
<string>需要访问通讯录</string>
<key>NSCalendarsUsageDescription</key>
<string>需要访问日历</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>需要访问语音识别</string>
<key>NSRemindersUsageDescription</key>
<string>需要访问提醒事项</string>
<key>NSMotionUsageDescription</key>
<string>需要访问运动与健身</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>需要访问蓝牙</string>
<key>NSAppleMusicUsageDescription</key>
<string>需要访问媒体资料库</string>
```
