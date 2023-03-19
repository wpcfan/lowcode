import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

/// 底部导航栏
class MyBottomBar extends StatelessWidget {
  const MyBottomBar({
    super.key,
    this.onTap,
  });
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.selectedIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'About',
            ),
          ],
        );
      },
    );
  }
}
