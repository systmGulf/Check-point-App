import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/admin_data.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/department_cubit/department_cubit.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import 'select_department_drop_button.dart';

class SelectDepartment extends StatefulWidget {
  const SelectDepartment({
    super.key,
    this.department,
    this.departmentId,
  });
  final String? department;
  final int? departmentId;

  @override
  State<SelectDepartment> createState() => _SelectDepartmentState();
}

class _SelectDepartmentState extends State<SelectDepartment> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<EmployeeCubit>(context).departmentId =
        widget.departmentId ?? 00;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
        builder: (context, state) {
      if (state is GetDepartmentLoading) {
        return Skeletonizer(
          child: SelectDepartmentDropButton(
              departments: DepartmentValue(data: []),
              department: widget.department,
              departmentId: widget.departmentId),
        );
      } else if (state is GetDepartmentSuccess) {
        return SelectDepartmentDropButton(
            departments: state.departmentList,
            department: widget.department,
            departmentId: widget.departmentId);
      }
      return const SizedBox.shrink();
    });
  }
}
