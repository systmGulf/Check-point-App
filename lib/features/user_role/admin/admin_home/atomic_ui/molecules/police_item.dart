import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_alart_message.dart';
import 'package:employee_mangement/core/widgets/employee_assigned_widget.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/taks_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/get_police_by_shift_id.dart';

import '../../../../../../core/common/app_container_decoration.dart';
import '../../../../../../core/common/formate_hours.dart';
import '../../../../../../core/helpers/app_spaces.dart';
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
    this.onDeleteEmployee,
  });
  final String month, year, timeIn, timeOut;
  final int policeId;
  final List<Employee> employees;
  final void Function(String employeeId)? onDeleteEmployee;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: AppContainerDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Column(
                children: [
                  Text('Date'.tr(context: context),
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
                                  policeId: policeId),
                            ),
                          ),
                        );
                      });
                },
                child: Text(
                  'ADD EMPLOYEES'.tr(context: context),
                  style: AppStylesManger.font13DarkBlueMedium.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                  onPressed: () {
                    buildDeleteAlertDialog(
                        message: 'Are you sure you want to delete this Police?'
                            .tr(context: context),
                        context,
                        title: 'Delete Police'.tr(context: context), onYes: () {
                      context
                          .read<ShiftsAndPolicesCubit>()
                          .deletePolice(id: policeId);
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
          verticalSpace(10.h),
          Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFF7BDDB5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time in'.tr(context: context),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F4F45),
                        )),
                    Text(formatHour(timeIn),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F4F45),
                        )),
                  ],
                ),
              ),
            ),
            horizontalSpace(10.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFF7BDDB5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time out'.tr(context: context),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F4F45),
                        )),
                    Text(formatHour(timeOut),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F4F45),
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
                '${"Employees assigned to this police".tr(context: context)} (${employees.length})'
                    .tr(context: context),
                style: AppStylesManger.font12RegularGrey.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: employees.isNotEmpty
                  ? employees
                      .map((employee) => EmployeeAssignedWidget(
                            name: employee.name ?? '',
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
                            .tr(context: context),
                        style: AppStylesManger.font12RegularGrey.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ])
        ]));
  }
}
