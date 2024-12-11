import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../../model/drop_down_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
class AssignEmployeesForTask extends StatefulWidget {
  const AssignEmployeesForTask({super.key});

  @override
  State<AssignEmployeesForTask> createState() => _AssignEmployeesForTaskState();
}

class _AssignEmployeesForTaskState extends State<AssignEmployeesForTask> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetEmployeesDataCubit, GetEmployeesDataState>(
        buildWhen: (previous, current) =>
            current is GetAllEmployeesSuccess ||
            current is GetAllEmployeesFailure ||
            current is GetAllEmployeesLoading,
        builder: (context, state) {
          if (state is GetAllEmployeesSuccess) {
            List<DropdownItem> dropdownItems = state.allEmployeesValue.data!
                .map((employee) => DropdownItem(
                      id: employee.id ?? '',
                      name: employee.name ?? '',
                      isSelected: false,
                    ))
                .toList();
            return SelectEmployeesForTasks(
              dropdownItems: dropdownItems,
            );
          } else if (state is GetAllEmployeesFailure) {
            return Text(state.errorMsg);
          } else if (state is GetAllEmployeesLoading) {
            return Skeletonizer(
                child: SelectEmployeesForTasks(
              dropdownItems: [],
            ));
          } else {
            return const SizedBox();
          }
        });
  }
}

class SelectEmployeesForTasks extends StatefulWidget {
  const SelectEmployeesForTasks({super.key, required this.dropdownItems});
  final List<DropdownItem> dropdownItems;
  @override
  State<SelectEmployeesForTasks> createState() =>
      _SelectEmployeesForTasksState();
}

class _SelectEmployeesForTasksState extends State<SelectEmployeesForTasks> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assign To:'.tr(context: context),
            style:
                AppStylesManger.font15BoldBlue.copyWith(color: Colors.black)),
        SizedBox(height: 10.h),
        DropdownButtonFormField(
          icon: SizedBox(
              width: 24,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/arrow_down.svg',
                  color: Colors.orange,
                ),
              )),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ))),
          iconEnabledColor: ColorsManger.primaryColor,
          dropdownColor: Colors.white,
          isExpanded: true,
          hint: Text(
            'Select Employees'.tr(context: context),
            style: AppStylesManger.font15BoldBlue.copyWith(color: Colors.black),
          ),
          items: widget.dropdownItems.map((item) {
            return DropdownMenuItem<DropdownItem>(
              value: item,
              child: Text(
                item.name,
                style: AppStylesManger.font15BoldBlue
                    .copyWith(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (DropdownItem? selectedItem) {
            setState(() {
              if (!context
                  .read<TasksCubit>()
                  .employeeIds
                  .contains(selectedItem!.id)) {
                context.read<TasksCubit>().employeeIds.add(selectedItem.id);
                log(context.read<TasksCubit>().employeeIds.toString());
              } else {
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.info(
                    message:
                        "Employee is already selected".tr(context: context),
                  ),
                );
              }
            });
          },
        ),
        const SizedBox(height: 20),
        Text('Selected Employees:'.tr(context: context)),
        const SizedBox(height: 10),
        context.read<TasksCubit>().employeeIds.isEmpty
            ? Text('No Employees selected'.tr(context: context))
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                height: 150.h,
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        context.read<TasksCubit>().employeeIds.map((item) {
                      return Card(
                        elevation: 1,
                        color: Colors.white,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/icon-default-user.png'),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                context
                                    .read<TasksCubit>()
                                    .employeeIds
                                    .remove(item);
                              });
                            },
                            icon: SizedBox(
                                height: 24,
                                width: 24,
                                child: Center(
                                    child: SvgPicture.asset(
                                        'assets/images/delete_icon.svg'))),
                          ),
                          title: Text(widget.dropdownItems
                              .firstWhere((element) => element.id == item)
                              .name),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
      ],
    );
  }
}
