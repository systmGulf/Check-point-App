import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/admin_data.dart';

import '../../../../../../core/styles/colors.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class SelectBranchDropButton extends StatefulWidget {
  const SelectBranchDropButton({super.key, required this.branches});
  final GetBranchesValue branches;

  @override
  State<SelectBranchDropButton> createState() => _SelectBranchDropButtonState();
}

class _SelectBranchDropButtonState extends State<SelectBranchDropButton> {
  String? branch;
  int? branchId;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorsManger.primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        hint: Text(
          'Select Branch'.tr(context: context),
        ),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        dropdownColor: Colors.white,
        iconSize: 24,
        value: branch,
        elevation: 16,
        underline: const SizedBox(),
        onChanged: (value) {
          print(value);
          setState(() {
            branch = value.toString();
            branchId = widget.branches.data!
                .firstWhere((element) => element.name == branch)
                .id;
            print(branchId);
            BlocProvider.of<EmployeeCubit>(context).branchId = branchId!;
          });
        },
        items: widget.branches.data!
            .map((e) => DropdownMenuItem(
                  value: e.name,
                  child: Text(e.name ?? ""),
                ))
            .toList(),
      ),
    );
  }
}
