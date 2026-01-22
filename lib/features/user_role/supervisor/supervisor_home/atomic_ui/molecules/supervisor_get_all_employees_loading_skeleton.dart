import 'package:animate_do/animate_do.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/molecules/supervisor_get_employee_in_team_item.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/employee_model/all_employees_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SupervisorGetAllEmployeesLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const SupervisorGetAllEmployeesLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      child: SlideInUp(
        onFinish: (a) {},
        child: Skeletonizer(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) => SupervisorGetEmployeesInTeamItem(
              name: 'load Data',
              id: 'load Data',
              getAllEmployeesValue: EmployeeData(),
            ),
          ),
        ),
      ),
    );
  }
}
