import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  static const smallScreen = 600;
  static const mediumScreen = 960;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < smallScreen;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < mediumScreen &&
      MediaQuery.of(context).size.width >= smallScreen;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreen;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= mediumScreen) {
      return desktop;
    } else if (size.width >= smallScreen && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
