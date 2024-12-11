import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../molecules/employee_attendace_information.dart';
import '../molecules/employee_card.dart';
import '../molecules/personal_statistics.dart';

class EmployeePreview extends StatefulWidget {
  const EmployeePreview(
      {super.key,
      required this.employeeId,
      required this.month,
      required this.year});
  final String employeeId;
  final int month;
  final int year;

  @override
  State<EmployeePreview> createState() => _EmployeePreviewState();
}

class _EmployeePreviewState extends State<EmployeePreview> {
  @override
  Widget build(BuildContext context) {
    context.read<GetEmployeesDataCubit>().getEmployeeSummaryByDepartmentId(
        employeeId: widget.employeeId, month: widget.month, year: widget.year);
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManger.primaryColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              height: 24,
              width: 24,
              child: Center(
                child: Transform(
                    alignment: Alignment.center,
                    transform: currentLanguageCode == 'ar'
                        ? Matrix4.rotationY(3.14)
                        : Matrix4.rotationY(0),
                    child: SvgPicture.asset('assets/images/arrow_back.svg')),
              ),
            ),
          ),
        ),
        body: BlocBuilder<GetEmployeesDataCubit, GetEmployeesDataState>(
          buildWhen: (previous, current) =>
              current is GetEmployeeSummaryFailure ||
              current is GetEmployeeSummarySuccess ||
              current is GetEmployeeSummaryLoading,
          builder: (context, state) {
            if (state is GetEmployeeSummaryFailure) {
              return Text(state.errorMsg);
            }
            if (state is GetEmployeeSummarySuccess) {
              return Skeletonizer(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EmployeeCard(
                        date:
                            state.getEmployeeSummaryValue.date!.substring(0, 7),
                        employeeName:
                            state.getEmployeeSummaryValue.employeeName ?? ''),
                    verticalSpace(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Personal Statistics'.tr(context: context),
                                style: AppStylesManger.font18RegulerBlack),
                            verticalSpace(20),
                            SizedBox(
                              height: 130.h,
                              child: PersonalStatistics(
                                late: state
                                    .getEmployeeSummaryValue.totalLateDays!
                                    .toDouble(),
                                absent: state
                                    .getEmployeeSummaryValue.totalAbsentDays!
                                    .toDouble(),
                                present: state
                                    .getEmployeeSummaryValue.totalDaysWorked!
                                    .toDouble(),
                              ),
                            ),
                            verticalSpace(20),
                            EmployeeAttendanceInformation(
                              text: 'Total Working Hours'.tr(context: context),
                              days:
                                  '${state.getEmployeeSummaryValue.totalHoursWorked.toString().substring(0, 3)} ${"Hours".tr(context: context)}',
                            ),
                            verticalSpace(15),
                            EmployeeAttendanceInformation(
                              text: 'Leaves'.tr(context: context),
                              days: '0 ${"Days".tr(context: context)}',
                            ),
                            verticalSpace(15),
                            EmployeeAttendanceInformation(
                              text: 'Total Working Days'.tr(context: context),
                              days:
                                  '${state.getEmployeeSummaryValue.totalDaysWorked} ${"Days".tr(context: context)}',
                            ),
                            verticalSpace(15),
                            EmployeeAttendanceInformation(
                              text: 'Late'.tr(context: context),
                              days:
                                  '${state.getEmployeeSummaryValue.totalLateDays} ${"Days".tr(context: context)}',
                            ),
                            verticalSpace(15),
                            EmployeeAttendanceInformation(
                              text: 'Early Leaves'.tr(context: context),
                              days:
                                  '${state.getEmployeeSummaryValue.totalEarlyLeaveDays} ${"Days".tr(context: context)}',
                            ),
                            verticalSpace(15),
                            EmployeeAttendanceInformation(
                              text: 'Absent'.tr(context: context),
                              days:
                                  '${state.getEmployeeSummaryValue.totalAbsentDays} ${"Days".tr(context: context)}',
                            ),
                          ]),
                    )
                  ],
                ),
              );
            }
            if (state is GetEmployeeSummaryLoading) {
              return Skeletonizer(
                enabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const EmployeeCard(
                        date: 'Loading...', employeeName: 'Loading...'),
                    verticalSpace(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Statistics'.tr(context: context),
                              style: AppStylesManger.font18RegulerBlack),
                          verticalSpace(20),
                          SizedBox(
                            height: 130.h,
                            child: const PersonalStatistics(
                              late: 0.5,
                              absent: 0.25,
                              present: 0.25,
                            ),
                          ),
                          verticalSpace(20),
                          // Add skeletons for other elements here
                          EmployeeAttendanceInformation(
                            text: 'Total Working Hours'.tr(context: context),
                            days: 'Loading...',
                          ),
                          verticalSpace(15),
                          EmployeeAttendanceInformation(
                            text: 'Leaves'.tr(context: context),
                            days: 'Loading...',
                          ),
                          verticalSpace(15),
                          EmployeeAttendanceInformation(
                            text: 'Total Working Days'.tr(context: context),
                            days: 'Loading...',
                          ),
                          verticalSpace(15),
                          EmployeeAttendanceInformation(
                            text: 'Late'.tr(context: context),
                            days: 'Loading...',
                          ),
                          verticalSpace(15),
                          EmployeeAttendanceInformation(
                            text: 'Early Leaves'.tr(context: context),
                            days: 'Loading...',
                          ),
                          verticalSpace(15),
                          EmployeeAttendanceInformation(
                            text: 'Absent'.tr(context: context),
                            days: 'Loading...',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }
}
