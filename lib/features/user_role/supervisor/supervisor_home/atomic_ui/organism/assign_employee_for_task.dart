import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/colors.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../../model/drop_down_item.dart';

class AssignEmployeesForTask extends StatefulWidget {
  const AssignEmployeesForTask({super.key});

  @override
  State<AssignEmployeesForTask> createState() => _AssignEmployeesForTaskState();
}

class _AssignEmployeesForTaskState extends State<AssignEmployeesForTask> {
  String? selectedEmployeeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetEmployeesDataCubit, GetEmployeesDataState>(
        buildWhen: (previous, current) =>
            current is GetAllEmployeesSuccess ||
            current is GetAllEmployeesFailure ||
            current is GetAllEmployeesLoading,
        builder: (context, state) {
          if (state is GetAllEmployeesSuccess) {
            final byId = <String, DropdownItemModel>{};
            for (final employee in state.allEmployeesValue.data ?? []) {
              final id = employee.id?.trim() ?? '';
              if (id.isEmpty) continue;
              byId[id] = DropdownItemModel(
                employee.deviceTokens ?? const <String>[],
                name: employee.name?.trim().isNotEmpty == true
                    ? employee.name!.trim()
                    : '--',
                id: id,
              );
            }
            final dropdownItems = byId.values.toList();

            if (selectedEmployeeId != null &&
                !byId.containsKey(selectedEmployeeId)) {
              selectedEmployeeId = null;
            }

            return DropdownButtonFormField<String>(
              initialValue: selectedEmployeeId,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Select employee'.tr(context: context),
              ),
              items: dropdownItems
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedEmployeeId = value;
                });
                if (value != null) {
                  final selected = byId[value];
                  if (selected == null) return;
                  context.read<TasksCubit>().selectedEmployeeId = selected.id;
                  context.read<TasksCubit>().selectedEmployeeTokens =
                      selected.employeesDeviceTokens;
                }
              },
            );
          } else if (state is GetAllEmployeesFailure) {
            return Text(state.errorMsg);
          } else if (state is GetAllEmployeesLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: ColorsManger.primaryColor,
              strokeWidth: 2,
              backgroundColor: ColorsManger.lighorage,
            ));
          } else {
            return const SizedBox();
          }
        });
  }
}
