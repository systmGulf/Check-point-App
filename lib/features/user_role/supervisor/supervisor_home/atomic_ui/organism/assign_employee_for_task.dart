import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

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
  final controller = MultiSelectController<DropdownItemModel>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetEmployeesDataCubit, GetEmployeesDataState>(
        buildWhen: (previous, current) =>
            current is GetAllEmployeesSuccess ||
            current is GetAllEmployeesFailure ||
            current is GetAllEmployeesLoading,
        builder: (context, state) {
          if (state is GetAllEmployeesSuccess) {
            List<DropdownItem<DropdownItemModel>> dropdownItems = List.generate(
                state.allEmployeesValue.data!.length,
                (index) => DropdownItem<DropdownItemModel>(
                    label: state.allEmployeesValue.data![index].name!,
                    value: DropdownItemModel(
                        state.allEmployeesValue.data![index].deviceTokens!,
                        name: state.allEmployeesValue.data![index].name!,
                        id: state.allEmployeesValue.data![index].id!)));
            log(dropdownItems.toString());
            return MultiDropdown<DropdownItemModel>(
              items: dropdownItems,
              controller: controller,
              enabled: true,
              fieldDecoration: FieldDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'select employees'.tr(context: context),
              ),
              searchEnabled: true,
              searchDecoration: SearchFieldDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search'.tr(context: context),
              ),
              chipDecoration: ChipDecoration(
                backgroundColor: ColorsManger.primaryColor,
                wrap: true,
                runSpacing: 2,
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
                deleteIcon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 16,
                ),
                spacing: 10,
              ),
              onSelectionChange: (selectedItems) {
                context.read<TasksCubit>().dropdownItems.addAll(selectedItems);
              },
            );
          } else if (state is GetAllEmployeesFailure) {
            return Text(state.errorMsg);
          } else if (state is GetAllEmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox();
          }
        });
  }
}
