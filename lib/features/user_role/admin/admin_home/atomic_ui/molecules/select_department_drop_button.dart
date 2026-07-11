import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/styles/colors.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class SelectDepartmentDropButton extends StatefulWidget {
  const SelectDepartmentDropButton(
      {super.key,
      this.department,
      this.departmentId,
      required this.departments});
  final String? department;
  final int? departmentId;
  final DepartmentValue departments;
  @override
  State<SelectDepartmentDropButton> createState() =>
      _SelectDepartmentDropButtonState();
}

class _SelectDepartmentDropButtonState
    extends State<SelectDepartmentDropButton> {
  String? selectedValue;
  int? departmentId;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorsManger.primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        value: selectedValue ?? widget.department,
        hint: Text(
          'Select Department'.tr(),
        ),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        dropdownColor: Colors.white,
        iconSize: 24,
        elevation: 16,
        underline: const SizedBox(),
        onChanged: (value) {
          setState(() {
            selectedValue = value.toString();
            departmentId = widget.departments.data!
                .firstWhere(
                    (element) => element.departmentName == selectedValue)
                .id;

            BlocProvider.of<EmployeeCubit>(context).departmentId =
                departmentId!;
          });
        },
        items: widget.departments.data!
            .map((e) => DropdownMenuItem(
                  value: e.departmentName,
                  child: Text(e.departmentName ?? ""),
                ))
            .toList(),
      ),
    );
  }
}
