import 'package:flutter/material.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

import '../styles/colors.dart';

class ProgressLoadingBar extends StatelessWidget {
  const ProgressLoadingBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressBarAnimation(
      duration: const Duration(seconds: 2),
      gradient: LinearGradient(
        colors: [ColorsManger.primaryColor, ColorsManger.lighorage],
      ),
      backgroundColor: Colors.grey.withOpacity(0.4),
    );
  }
}
