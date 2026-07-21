import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_alart_message.dart';
import 'package:employee_mangement/core/widgets/employee_assigned_widget.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/taks_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/get_police_by_shift_id.dart';

import '../../../../../../core/common/formate_hours.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import 'add_employees_to_police_model_botttom_sheet.dart';

class PoliceItem extends StatelessWidget {
  const PoliceItem({
    super.key,
    required this.month,
    required this.year,
    required this.timeIn,
    required this.timeOut,
    required this.policeId,
    required this.employees,
    required this.onEdit,
    this.onDeleteEmployee,
  });
  final String month, year, timeIn, timeOut;
  final int policeId;
  final List<Employee> employees;
  final VoidCallback onEdit;
  final void Function(String employeeId)? onDeleteEmployee;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: AppConatinerDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Column(
                children: [
                  Text('Date'.tr(),
                      style: AppStylesManger.font14RegularBlack.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('$month/$year',
                      style: AppStylesManger.font14RegularBlack
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (bottomSheetContext) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => context.read<EmployeeCubit>()
                                ..getAllEmployees(pageNumber: 0, itemCount: 0),
                            ),
                            BlocProvider.value(
                              value: context.read<ShiftsAndPolicesCubit>(),
                            ),
                          ],
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(bottomSheetContext)
                                  .viewInsets
                                  .bottom,
                            ),
                            child: SingleChildScrollView(
                              child: AddEmployeesToPoliceModelBottomSheet(
                                policeId: policeId,
                                initialAssignedEmployees: employees,
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Text(
                  'ADD EMPLOYEES'.tr(),
                  style: AppStylesManger.font13DarkBlueMedium.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              AppActionIconButton.edit(
                onPressed: onEdit,
                size: 34,
              ),
              horizontalSpace(8.w),
              AppActionIconButton.delete(
                onPressed: () {
                  buildDeleteAlertDialog(
                      message: 'Are you sure you want to delete this Police?'
                          .tr(),
                      context,
                      title: 'Delete Police'.tr(), onYes: () {
                    context
                        .read<ShiftsAndPolicesCubit>()
                        .deletePolice(id: policeId);
                  });
                },
                size: 34,
              )
            ],
          ),
          verticalSpace(10.h),
          Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsManger.tealGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time in'.tr(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: ColorsManger.darkTeal,
                        )),
                    Text(formatHour(timeIn),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ColorsManger.darkTeal,
                        )),
                  ],
                ),
              ),
            ),
            horizontalSpace(10.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsManger.tealGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time out'.tr(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: ColorsManger.darkTeal,
                        )),
                    Text(formatHour(timeOut),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: ColorsManger.darkTeal,
                        )),
                  ],
                ),
              ),
            )
          ]),
          verticalSpace(10.h),
          ExpansionTile(
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              collapsedTextColor: Colors.black,
              tilePadding: const EdgeInsets.all(0),
              expandedAlignment: Alignment.topLeft,
              childrenPadding: const EdgeInsets.all(0),
              title: Text(
                '${"Employees assigned to this police".tr()} (${employees.length})'
                    .tr(),
                style: AppStylesManger.font12RegularGrey.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: employees.isNotEmpty
                  ? employees
                      .map((employee) => EmployeeAssignedWidget(
                            name: employee.userName ?? employee.name ?? '',
                            imageUrl: employee.imageUrl ?? '',
                            position: employee.position ?? '',
                            departmentName: employee.departmentName ?? '',
                            onDelete: () =>
                                onDeleteEmployee!(employee.id ?? ""),
                          ))
                      .toList()
                  : [
                      Text(
                        'No employees assigned to this police'
                            .tr(),
                        style: AppStylesManger.font12RegularGrey.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ])
        ]));
  }
}
