import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../molecules/members_in_department_list_view.dart';

class EmployeesByDepartmentLoadingSkeleton extends StatelessWidget {
  final String? role;
  final int? departmentId;
  final int itemCount;

  const EmployeesByDepartmentLoadingSkeleton({
    super.key,
    this.role,
    this.departmentId,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        child: Column(
      children: List.generate(
          itemCount,
          (index) => MembersInDepartmentListView(
                manger: [],
                role: role ?? 'Data Loading',
                departmentId: departmentId ?? 0,
              )),
    ));
  }
}
