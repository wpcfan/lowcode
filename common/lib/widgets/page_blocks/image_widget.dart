import 'package:common/extensions/all.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.radius = 0,
    required this.errorImage,
  });
  final String image;
  final String errorImage;
  final double width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      width: width,
      height: height,
      fit: BoxFit.cover,

      /// loadingBuilder 参数接收一个函数，该函数会在图片加载过程中被调用
      /// 该函数的参数 loadingProgress 就是图片加载的进度
      /// loadingProgress.cumulativeBytesLoaded 表示已经加载的字节数
      /// loadingProgress.expectedTotalBytes 表示总共需要加载的字节数
      /// 如果图片加载成功，loadingProgress.expectedTotalBytes 会返回 null
      /// 所以这里需要判断一下
      /// 如果图片加载成功，就显示图片
      /// 如果图片正在加载，就显示一个 CircularProgressIndicator
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },

      /// errorBuilder 参数接收一个函数，该函数会在图片加载失败时被调用
      /// 该函数的参数 error 就是图片加载失败的错误信息
      /// errorBuilder 返回的 Widget 会被显示在图片的位置
      errorBuilder: (context, error, stackTrace) {
        debugPrint('error: $error');
        return Image.asset(errorImage);
      },
    ).clipRRect(all: radius);
  }
}
