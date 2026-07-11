import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/department_postion.dart';
import '../organism/get_employees_by_department.dart';

class DepartmentUsersAndPermission extends StatefulWidget {
  const DepartmentUsersAndPermission(
      {super.key, required this.text, required this.departmentId});
  final String text;
  final int departmentId;

  @override
  State<DepartmentUsersAndPermission> createState() =>
      _DepartmentUsersAndPermissionState();
}

class _DepartmentUsersAndPermissionState
    extends State<DepartmentUsersAndPermission> {
  int indexSelected = 0;
  @override
  Widget build(BuildContext context) {
    List<String> position = [
      'Managers'.tr(),
      'Employees'.tr(),
    ];
    BlocProvider.of<EmployeeCubit>(context).getEmployeeByDepartment(
      departmentId: widget.departmentId,
    );
    return Scaffold(
        appBar: buildCustomAppBar(
          context,
          widget.text,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                    children: List.generate(position.length, (index) {
                  return DepartmentPosition(
                      onTap: () {
                        indexSelected = index;
                        setState(() {});
                      },
                      index: indexSelected == index,
                      text: position[index]);
                })),
                verticalSpace(10),
                indexSelected == 1
                    ? GetMembersByDepartment(
                        departmentId: widget.departmentId,
                        role: 'Employee',
                      )
                    : GetMembersByDepartment(
                        departmentId: widget.departmentId,
                        role: 'Supervisor',
                      )
              ],
            ),
          ),
        ));
  }
}
