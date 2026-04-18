import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_refresh_wrapper.dart';

class AnnouncementStateView extends StatelessWidget {
  const AnnouncementStateView({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshWrapper(
      onRefresh: onRefresh,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.65,
        child: Center(child: child),
      ),
    );
  }
}
