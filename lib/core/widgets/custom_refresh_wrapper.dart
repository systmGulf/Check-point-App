import 'package:flutter/material.dart';

class CustomRefreshWrapper extends StatelessWidget {
  const CustomRefreshWrapper({
    super.key,
    required this.onRefresh,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        children: [child],
      ),
    );
  }
}
