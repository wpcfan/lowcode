import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

/// 轮播图组件
/// 使用PageView实现
class BannerWidget extends StatefulWidget {
  final List<ImageData> items;
  final String? errorImage;
  final int animationDuration;
  final Curve animationCurve;
  final BlockConfig config;
  final double ratio;
  final void Function(MyLink?)? onTap;
  final int transitionDuration;
  final int secondsToNextPage;

  const BannerWidget({
    super.key,
    required this.items,
    required this.config,
    required this.ratio,
    this.errorImage,
    this.animationDuration = 500,
    this.animationCurve = Curves.ease,
    this.onTap,
    this.transitionDuration = 500,
    this.secondsToNextPage = 5,
  });

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
    if (widget.items.isEmpty) return;
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
    if (widget.items.isEmpty) return;
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
    final borderWidth = widget.config.borderWidth ?? 0;
    final borderColor = widget.config.borderColor ?? Colors.transparent;
    final backgroundColor = widget.config.backgroundColor ?? Colors.transparent;
    final blockWidth = (widget.config.blockWidth ?? 0) / widget.ratio;
    final blockHeight = (widget.config.blockHeight ?? 0) / widget.ratio;
    final horizontalPadding =
        (widget.config.horizontalPadding ?? 0) / widget.ratio;
    final verticalPadding = (widget.config.verticalPadding ?? 0) / widget.ratio;

    page({required Widget child}) => child
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .decorated(
            border: Border.all(width: borderWidth, color: borderColor),
            color: backgroundColor)
        .constrained(width: blockWidth, height: blockHeight);

    final pagedItem = widget.items.isEmpty
        ? const Placeholder()
        : PageView.builder(
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
                width: blockWidth,
                height: blockHeight,
                link: widget.items[idx].link,
                onTap: (link) => widget.onTap?.call(link),
              );
            },
          );
    final indicators = List.generate(
      widget.items.length,
      (index) => const SizedBox(width: 8.0, height: 8.0)
          .decorated(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.grey[500],
          )
          .inkWell(onTap: () => _nextPage(index))
          .padding(horizontal: 4.0),
    )
        .toRow(mainAxisAlignment: MainAxisAlignment.center)
        .padding(bottom: 8.0)
        .alignment(Alignment.bottomCenter);
    return [
      pagedItem.constrained(width: blockWidth, height: blockHeight),
      indicators,
    ].toStack().parent(page);
  }
}
