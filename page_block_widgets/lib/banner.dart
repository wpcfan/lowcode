import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

/// 轮播图组件
/// 使用PageView实现
class BannerWidget extends StatefulWidget {
  final List<ImageData> data;
  final String errorImage;
  final int animationDuration;
  final Curve animationCurve;
  final double height;
  final void Function(MyLink?)? onImageSelected;

  const BannerWidget({
    super.key,
    required this.data,
    required this.height,
    required this.errorImage,
    this.animationDuration = 500,
    this.animationCurve = Curves.ease,
    this.onImageSelected,
  });

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: widget.animationDuration),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return ImageWidget(
                  imageUrl: widget.data[index].image,
                  errorImage: widget.errorImage,
                  height: widget.height,
                  link: widget.data[index].link,
                  onTap: (link) => widget.onImageSelected?.call(link),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.data.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => _nextPage(index),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
