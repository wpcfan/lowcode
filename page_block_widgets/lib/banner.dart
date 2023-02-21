import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

/// 轮播图组件
/// 使用PageView实现
class BannerWidget extends StatefulWidget {
  final List<ImageData> items;
  final String errorImage;
  final int animationDuration;
  final Curve animationCurve;
  final BlockConfig config;
  final double ratio;
  final void Function(MyLink?)? onTap;
  final int transitionDuration;
  final int secondsToNextPage;

  const BannerWidget(
      {super.key,
      required this.items,
      required this.config,
      required this.errorImage,
      required this.ratio,
      this.animationDuration = 500,
      this.animationCurve = Curves.ease,
      this.onTap,
      this.transitionDuration = 500,
      this.secondsToNextPage = 5});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _currentPage = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer =
        Timer.periodic(Duration(seconds: widget.secondsToNextPage), (timer) {
      _pageController.animateToPage(
        (_currentPage + 1) % widget.items.length,
        duration: Duration(milliseconds: widget.transitionDuration),
        curve: Curves.ease,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
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
    final blockWidth = (widget.config.blockWidth ?? 0) / widget.ratio;
    final blockHeight = (widget.config.blockHeight ?? 0) / widget.ratio;
    final horizontalPadding =
        (widget.config.horizontalPadding ?? 0) / widget.ratio;
    final verticalPadding = (widget.config.verticalPadding ?? 0) / widget.ratio;
    return Container(
      width: blockWidth,
      height: blockHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Stack(
        children: [
          SizedBox(
            height: blockHeight - verticalPadding * 2,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index % widget.items.length;
                });
              },
              itemBuilder: (context, index) {
                int idx = index % widget.items.length;
                return ImageWidget(
                  imageUrl: widget.items[idx].image,
                  errorImage: widget.errorImage,
                  link: widget.items[idx].link,
                  onTap: (link) => widget.onTap?.call(link),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.items.length,
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
