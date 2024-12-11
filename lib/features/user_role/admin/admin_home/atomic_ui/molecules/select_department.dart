import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/colors.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

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
  String? selectedValue;
  int? departmentId;
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
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is GetDepartmentSuccess) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ColorsManger.primaryColor),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton(
            value: selectedValue ?? widget.department,
            hint: Text(
              'Select Department'.tr(context: context),
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
                departmentId = state.departmentList.data!
                    .firstWhere(
                        (element) => element.departmentName == selectedValue)
                    .id;

                BlocProvider.of<EmployeeCubit>(context).departmentId =
                    departmentId!;
              });
            },
            items: state.departmentList.data!
                .map((e) => DropdownMenuItem(
                      value: e.departmentName,
                      child: Text(e.departmentName ?? ""),
                    ))
                .toList(),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
