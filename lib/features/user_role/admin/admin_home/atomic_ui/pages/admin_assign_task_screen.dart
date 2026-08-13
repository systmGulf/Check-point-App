import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../supervisor/supervisor_home/contoller/tasks_cubit/tasks_cubit.dart';
import '../../../../supervisor/supervisor_home/model/drop_down_item.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class AdminAssignTaskScreen extends StatefulWidget {
  const AdminAssignTaskScreen({super.key, required this.taskId});
  final int taskId;

  @override
  State<AdminAssignTaskScreen> createState() => _AdminAssignTaskScreenState();
}

class _AdminAssignTaskScreenState extends State<AdminAssignTaskScreen> {
  final MultiSelectController<DropdownItemModel> selectController =
      MultiSelectController<DropdownItemModel>();
  List<DropdownItemModel> selectedAssignees = [];
  bool isLoadingDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: buildCustomAppBar(context, 'Assign Task'.tr()),
      body: BlocListener<TasksCubit, TasksState>(
        listenWhen: (previous, current) =>
            current is AssignTaskLoading ||
            current is AssignTaskSuccess ||
            current is AssignTaskError,
        listener: (context, state) {
          if (state is AssignTaskLoading) {
            if (!isLoadingDialogShowing) {
              isLoadingDialogShowing = true;
              customLoadingIndicator(context);
            }
          } else {
            if (isLoadingDialogShowing) {
              Navigator.pop(context);
              isLoadingDialogShowing = false;
            }
            if (state is AssignTaskSuccess) {
              buildSnackBar(
                context,
                customSnackBar: CustomSnackBar.success(
                  message: "Task assigned successfully".tr(),
                ),
              );
              Navigator.pop(context);
            } else if (state is AssignTaskError) {
              buildSnackBar(
                context,
                customSnackBar: CustomSnackBar.error(
                  message: state.errorMessage.tr(),
                ),
              );
            }
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(16),
                  Text(
                    'Assign Task To (Employees & Supervisors)'.tr(),
                    style: AppStylesManger.font12RegularGrey.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  verticalSpace(8),
                  BlocBuilder<EmployeeCubit, EmployeeState>(
                    buildWhen: (previous, current) =>
                        current is GetAllEmployeesLoading ||
                        current is GetAllEmployeesSuccess ||
                        current is GetAllEmployeesFailure,
                    builder: (context, state) {
                      if (state is GetAllEmployeesLoading) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: CircularProgressIndicator(
                              color: ColorsManger.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      } else if (state is GetAllEmployeesFailure) {
                        return Text(state.error);
                      } else if (state is GetAllEmployeesSuccess) {
                        final employees = state.value.data ?? [];
                        final dropdownItems = List.generate(
                          employees.length,
                          (index) {
                            final emp = employees[index];
                            final displayLabel = '${emp.name ?? emp.userName ?? ''} (${emp.role?.tr() ?? ''})';
                            return DropdownItem<DropdownItemModel>(
                              label: displayLabel,
                              value: DropdownItemModel(
                                emp.deviceTokens ?? [],
                                name: emp.name ?? emp.userName ?? '',
                                id: emp.id.toString(),
                              ),
                            );
                          },
                        );
                        return MultiDropdown<DropdownItemModel>(
                          items: dropdownItems,
                          controller: selectController,
                          enabled: true,
                          fieldDecoration: FieldDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE8D9D9), width: 1.2),
                            ),
                            hintText: 'Select employees and supervisors'.tr(),
                          ),
                          searchEnabled: true,
                          searchDecoration: SearchFieldDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Search...'.tr(),
                          ),
                          chipDecoration: ChipDecoration(
                            backgroundColor: ColorsManger.primaryColor,
                            wrap: true,
                            runSpacing: 2,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            deleteIcon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            spacing: 8,
                          ),
                          onSelectionChange: (selectedItems) {
                            setState(() {
                              selectedAssignees = selectedItems;
                            });
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  verticalSpace(30),
                  CustomAppButton(
                    textButton: 'Assign'.tr(),
                    buttonColor: ColorsManger.primaryColor,
                    onPressed: () {
                      if (selectedAssignees.isEmpty) {
                        buildSnackBar(
                          context,
                          customSnackBar: CustomSnackBar.error(
                            message: 'Please select at least one assignee'.tr(),
                          ),
                        );
                        return;
                      }
                      context.read<TasksCubit>().assignTasks(
                            taskId: widget.taskId,
                            employees: selectedAssignees,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
