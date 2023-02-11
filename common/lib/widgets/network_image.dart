import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// 考虑到网络图片的加载可能会失败，所以这里使用 FutureBuilder 来处理
/// 如果加载失败，显示一个本地的图片
/// 如果加载成功，显示网络图片
/// 如果正在加载，显示一个 CircularProgressIndicator
class NetworkImage extends StatelessWidget {
  final String imageUrl;

  const NetworkImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// FutureBuilder 的 future 参数接收一个 Future 对象
    /// 该 Future 对象会在 FutureBuilder 的 build 方法被调用时执行
    /// 执行完毕后，会根据 Future 的状态来更新 FutureBuilder 的状态
    return FutureBuilder(
      future: _loadImage(),

      /// builder 参数接收一个函数，该函数会在 FutureBuilder 的状态发生变化时被调用
      /// 该函数的参数 snapshot 就是 FutureBuilder 的状态
      /// snapshot.connectionState 表示 FutureBuilder 的状态
      /// snapshot.hasError 表示 Future 是否有错误
      /// snapshot.data 表示 Future 的返回值
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Image.asset('assets/error.png');
          } else {
            return Image.memory(snapshot.data as Uint8List);
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<Uint8List> _loadImage() async {
    try {
      /// 使用 http 包来加载网络图片
      /// http.get 方法返回一个 Future 对象
      /// 该 Future 对象在图片加载完毕后会返回一个 Response 对象
      /// Response 对象的 bodyBytes 属性就是图片的二进制数据
      /// 这里使用 await 关键字来等待 Future 执行完毕
      /// 等待完毕后，会将 Response 对象返回
      var response = await http.get(Uri.https(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return Future.error('Failed to load image');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
