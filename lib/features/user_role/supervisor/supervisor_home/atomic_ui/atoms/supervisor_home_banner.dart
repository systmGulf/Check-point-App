import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';

class SupervisorHomeBanner extends StatelessWidget {
  const SupervisorHomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsImagesBannerHome,
    );
  }
}
