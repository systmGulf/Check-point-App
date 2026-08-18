import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    label: state.allEmployeesValue.data![index].userName ??
                        state.allEmployeesValue.data![index].name!,
                    value: DropdownItemModel(
                        state.allEmployeesValue.data![index].deviceTokens!,
                        name: state.allEmployeesValue.data![index].userName ??
                            state.allEmployeesValue.data![index].name!,
                        id: state.allEmployeesValue.data![index].id!)));
            log(dropdownItems.toString());
            return MultiDropdown<DropdownItemModel>(
              items: dropdownItems,
              controller: controller,
              enabled: true,
              fieldDecoration: FieldDecoration(
                backgroundColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1.2,
                  ),
                ),
                hintText: 'select employees'.tr(),
                hintStyle: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14.sp,
                ),
              ),
              searchEnabled: true,
              searchDecoration: SearchFieldDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                hintText: 'Search'.tr(),
              ),
              chipDecoration: ChipDecoration(
                backgroundColor:
                    const Color(0xFFEFF6FF), // Soft light blue background
                wrap: true,
                runSpacing: 8.h,
                labelStyle: TextStyle(
                  color: ColorsManger.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
                deleteIcon: Icon(
                  Icons.close_rounded,
                  color: ColorsManger.primaryColor,
                  size: 16.sp,
                ),
                border: Border.all(
                  color: ColorsManger.primaryColor.withOpacity(0.2),
                  width: 1.0,
                ),
                spacing: 8.w,
              ),
              onSelectionChange: (selectedItems) {
                context.read<TasksCubit>().dropdownItems.clear();
                context.read<TasksCubit>().dropdownItems.addAll(selectedItems);
              },
            );
          } else if (state is GetAllEmployeesFailure) {
            return Text(state.errorMsg);
          } else if (state is GetAllEmployeesLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: ColorsManger.primaryColor,
              strokeWidth: 2,
              backgroundColor: ColorsManger.timelineBackground,
            ));
          } else {
            return const SizedBox();
          }
        });
  }
}
