import 'package:employee_mangement/core/animations/animations.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/organism/get_employee_data_in_employee_home_screen_bloc_builder.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedByWidgetType(
      widgetType: WidgetAnimationType.header,
      delayDuration: Duration(milliseconds: 100),
      child: GetEmployeeDataInEmployeeHomeScreenBlocBuilder(),
    );
  }
}
