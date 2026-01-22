import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/molecules/select_department_drop_button.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/department_model/department_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelectDepartmentLoadingSkeleton extends StatelessWidget {
  final DepartmentValue? department;
  final int? departmentId;

  const SelectDepartmentLoadingSkeleton({
    super.key,
    this.department,
    this.departmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: SelectDepartmentDropButton(
        departments: DepartmentValue(data: []),
        department: '',
        departmentId: departmentId,
      ),
    );
  }
}
