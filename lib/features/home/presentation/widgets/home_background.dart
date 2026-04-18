import 'package:employee_mangement/core/animations/animations.dart';
import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedByWidgetType(
      widgetType: WidgetAnimationType.image,
      child: Image(
        image: AssetImage('assets/images/banner-home.png'),
      ),
    );
  }
}
