import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/get_police_by_shift_id.dart';

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
    required this.policeId, required this.employees,
  });
  final String month, year, timeIn, timeOut;
  final int policeId;
  final List<Employee> employees;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        builder: (_) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<EmployeeCubit>()
                                  ..getAllEmployees(
                                      pageNumber: 0, itemCount: -1),
                              ),
                              BlocProvider.value(
                                value: context.read<ShiftsAndPolicesCubit>(),
                              ),
                            ],
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: AddEmployeesToPoliceyModelBottomSheet(
                                  policeId: policeId),
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
                      context
                          .read<ShiftsAndPolicesCubit>()
                          .deletePolice(id: policeId);
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
         employees.isNotEmpty?    Text(
              'Employees assigned to this police'
                  .tr(context: context),
              style: AppStylesManger.font12RegularGrey.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ) : Text(
              'No employees assigned to this police'
                  .tr(context: context),
              style: AppStylesManger.font12RegularGrey.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red
              ),
            ),
            verticalSpace(10.h),
            ...employees.map((employee) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        UserImage(imageUrl: employee.imageUrl ?? '', height: 50,),
                        horizontalSpace(10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name ?? '',
                              style: AppStylesManger.font14RegularBlack
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              employee.position ?? '',
                              style: AppStylesManger.font12RegularGrey,
                            ),
                            Text(
                              "${"Department".tr(context: context)}: ${employee.departmentName ?? ''}",
                              style: AppStylesManger.font12RegularGrey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
