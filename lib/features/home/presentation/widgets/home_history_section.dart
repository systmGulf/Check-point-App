import 'package:employee_mangement/core/animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/organism/employee_attendace_bloc_builder.dart';

class HomeHistorySection extends StatelessWidget {
  const HomeHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedByWidgetType(
      widgetType: WidgetAnimationType.listItem,
      delayDuration: Duration(milliseconds: 600),
      child: EmployeeAttendanceBlocBuilder(),
    );
  }
}
