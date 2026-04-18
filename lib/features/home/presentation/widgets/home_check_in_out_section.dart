import 'package:employee_mangement/core/animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/office_checking_in.dart';

class HomeCheckInOutSection extends StatelessWidget {
  const HomeCheckInOutSection({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  static const List<Widget> _checkingSites = [
    CheckInOrCheckOutWidget(attendType: 'Office'),
    CheckInOrCheckOutWidget(attendType: 'Customer'),
    CheckInOrCheckOutWidget(attendType: 'Site'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.container,
      delayDuration: const Duration(milliseconds: 300),
      child: _checkingSites[selectedIndex],
    );
  }
}
