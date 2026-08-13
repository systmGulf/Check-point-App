import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../supervisor/supervisor_home/contoller/tasks_cubit/tasks_cubit.dart';
import '../../../../supervisor/supervisor_home/model/drop_down_item.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/molecules/priority_widget.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class AdminAddTasksScreen extends StatefulWidget {
  const AdminAddTasksScreen({super.key});

  @override
  State<AdminAddTasksScreen> createState() => _AdminAddTasksScreenState();
}

class _AdminAddTasksScreenState extends State<AdminAddTasksScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final MultiSelectController<DropdownItemModel> selectController =
      MultiSelectController<DropdownItemModel>();
  
  List<DropdownItemModel> selectedAssignees = [];
  bool isLoadingDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: buildCustomAppBar(context, 'Add New Task'.tr()),
      body: BlocListener<TasksCubit, TasksState>(
        listenWhen: (previous, current) =>
            current is AddTaskLoading ||
            current is AssignTaskLoading ||
            current is AddTaskError ||
            current is AddTaskSuccess,
        listener: (context, state) {
          if (state is AddTaskLoading || state is AssignTaskLoading) {
            if (!isLoadingDialogShowing) {
              isLoadingDialogShowing = true;
              customLoadingIndicator(context);
            }
          } else {
            if (isLoadingDialogShowing) {
              Navigator.pop(context); // Pop loading dialog
              isLoadingDialogShowing = false;
            }
            if (state is AddTaskSuccess) {
              buildSnackBar(
                context,
                customSnackBar: CustomSnackBar.success(
                  message: "Task created and assigned successfully".tr(),
                ),
              );
              Navigator.pop(context, state.createdTask);
            } else if (state is AddTaskError) {
              buildSnackBar(
                context,
                customSnackBar: CustomSnackBar.error(
                  message: state.errorMessage.tr(),
                ),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(16),
                  Text('Task title'.tr(),
                      style: AppStylesManger.font12RegularGrey.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      )),
                  verticalSpace(8),
                  CustomAppTextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter title'.tr();
                      }
                      return null;
                    },
                    controller: context.read<TasksCubit>().titleController,
                    hint: 'Enter title here...'.tr(),
                  ),
                  verticalSpace(16),
                  Text('Task Description'.tr(),
                      style: AppStylesManger.font12RegularGrey.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      )),
                  verticalSpace(8),
                  CustomAppTextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter description'.tr();
                      }
                      return null;
                    },
                    controller: context.read<TasksCubit>().descriptionController,
                    hint: 'Enter description here...'.tr(),
                    maxLines: 4,
                  ),
                  verticalSpace(16),
                  Text('Priority'.tr(),
                      style: AppStylesManger.font12RegularGrey.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      )),
                  verticalSpace(8),
                  priorityWidget(
                    onChanged: (priority) {
                      setState(() {
                        context.read<TasksCubit>().priorityStatus = priority ?? 'medium';
                      });
                    },
                  ),
                  verticalSpace(16),
                  Text('Due date'.tr(),
                      style: AppStylesManger.font12RegularGrey.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      )),
                  verticalSpace(8),
                  CustomAppTextFormField(
                    hint: context.read<TasksCubit>().dueDate.isNotEmpty
                        ? context.read<TasksCubit>().dueDate
                        : 'Select date'.tr(),
                    readOnly: true,
                    hintStyle: const TextStyle(
                      color: Color(0xFF7F7F7F),
                      fontSize: 14,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                        child: SvgPicture.asset('assets/images/calendar.svg'),
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd', 'en').format(value);
                            context.read<TasksCubit>().dueDate = formattedDate;
                          });
                        }
                      });
                    },
                  ),
                  verticalSpace(16),
                  Text('Assign Task To (Employees & Supervisors)'.tr(),
                      style: AppStylesManger.font12RegularGrey.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      )),
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
                    textButton: 'Add & Assign Task'.tr(),
                    buttonColor: ColorsManger.primaryColor,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final cubit = context.read<TasksCubit>();
                        if (cubit.dueDate.isEmpty) {
                          buildSnackBar(
                            context,
                            customSnackBar: CustomSnackBar.error(
                              message: 'Please select a due date'.tr(),
                            ),
                          );
                          return;
                        }
                        if (selectedAssignees.isEmpty) {
                          buildSnackBar(
                            context,
                            customSnackBar: CustomSnackBar.error(
                              message: 'Please select at least one assignee'.tr(),
                            ),
                          );
                          return;
                        }
                        cubit.addAndAssignTask(
                          title: cubit.titleController.text.trim(),
                          description: cubit.descriptionController.text.trim(),
                          dueDate: cubit.dueDate,
                          priorityStatus: cubit.priorityStatus,
                          assignees: selectedAssignees,
                        );
                      }
                    },
                  ),
                  verticalSpace(30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
