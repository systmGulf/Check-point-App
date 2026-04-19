import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';

class SurveysTabBar extends StatelessWidget implements PreferredSizeWidget {
  const SurveysTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: ColorsManger.primaryColor,
      labelColor: ColorsManger.primaryColor,
      unselectedLabelColor: ColorsManger.grey9c,
      tabs: [
        Tab(text: 'My Surveys'),
        Tab(text: 'Available Surveys'),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
