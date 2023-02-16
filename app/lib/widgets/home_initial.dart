import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HomeInitial extends StatelessWidget {
  const HomeInitial({super.key, this.isLoading = false});
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: isLoading,
      skeleton: SkeletonListView(),
      child: const Center(child: Text("Content")),
    );
  }
}
