import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
