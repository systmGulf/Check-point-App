import 'package:flutter/material.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class ProgressLoadingBar extends StatelessWidget {
  const ProgressLoadingBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressBarAnimation(
      duration: const Duration(seconds: 3),
      gradient: const LinearGradient(
        colors: [Color(0XFFf77308), Colors.yellow],
      ),
      backgroundColor: Colors.grey.withOpacity(0.4),
    );
  }
}
