import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/convert_time_to_12_houre_format.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../molecules/build_show_employee_image_dialog.dart';
import 'employee_tracking_diagram_map.dart';

class EmployeeAttendance extends StatelessWidget {
  const EmployeeAttendance({
    super.key,
    required this.employeeName,
    required this.location,
    required this.inTime,
    required this.outTime,
    required this.id,
    required this.totalHours,
    this.employeeImage,
    this.customerId,
    required this.employeeId,
  });

  final String employeeName, location, inTime, outTime, id, employeeId;
  final String totalHours;
  final String? employeeImage, customerId;

  @override
  Widget build(BuildContext context) {
    DateTime inDateTime =
        DateTime.parse('2000-01-01 ${inTime.substring(0, 5)}:00');
    DateTime outDateTime =
        DateTime.parse('2000-01-01 ${outTime.substring(0, 5)}:00');

    DateTime lateCheckInThreshold = DateTime.parse('2000-01-01 10:00:00');
    DateTime earlyCheckOutThreshold = DateTime.parse('2000-01-01 17:00:00');

    bool isLate = inDateTime.isAfter(lateCheckInThreshold);
    bool isEarly = outDateTime.isBefore(earlyCheckOutThreshold);

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: ColorsManger.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  image:
                      const AssetImage('assets/images/icon-default-user.png'),
                  height: 30.h),
              horizontalSpace(10),
              Text(
                employeeName,
                style: AppStylesManger.font15BoldrBlue
                    .copyWith(color: Colors.black),
              ),
              employeeImage != null
                  ? SizedBox(
                      child: IconButton(
                        onPressed: () {
                          buildShowEmployeeImageDialog(context,
                              employeeImage: employeeImage);
                        },
                        icon: Icon(
                          Icons.camera,
                          color: ColorsManger.primaryColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              location == 'Customer'
                  ? Row(
                      children: [
                        InkWell(
                            onTap: () {
                              context
                                  .read<SupervisorGetEmployeeAttendanceCubit>()
                                  .supervisorGetCustomerInAttendance(
                                      CustomerId: customerId!);
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: context.read<
                                          SupervisorGetEmployeeAttendanceCubit>(),
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Container(
                                            child: BlocBuilder<
                                                    SupervisorGetEmployeeAttendanceCubit,
                                                    SupervisorGetEmployeeAttendanceState>(
                                                buildWhen: (previous,
                                                        current) =>
                                                    current is GetCustomerCustomerInAttendanceFailure ||
                                                    current
                                                        is GetCustomerCustomerInAttendanceSuccess ||
                                                    current
                                                        is GetCustomerCustomerInAttendanceLoading,
                                                builder: (context, state) {
                                                  if (state
                                                      is GetCustomerCustomerInAttendanceSuccess) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close),
                                                            )),
                                                        CircleAvatar(
                                                          radius: 25.r,
                                                          child: Icon(
                                                              Icons.person),
                                                        ),
                                                        Text(
                                                          '${state.customerInAttenadceModel.value?.name ?? 'Data'}',
                                                          style: AppStylesManger
                                                              .font15BoldrBlue
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        verticalSpace(5),
                                                        Text(
                                                            '${state.customerInAttenadceModel.value?.workesAs ?? ''}'),
                                                        verticalSpace(5),
                                                        Text(
                                                            '${state.customerInAttenadceModel.value?.location ?? ''}'),
                                                      ],
                                                    );
                                                  } else if (state
                                                      is GetCustomerCustomerInAttendanceLoading) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ],
                                                    );
                                                  } else if (state
                                                      is GetCustomerCustomerInAttendanceFailure) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Center(
                                                          child: Text(state
                                                              .errorMessage),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                })),
                                      ),
                                    );
                                  });
                            },
                            child: Icon(Icons.visibility)),
                        horizontalSpace(5),
                        Text(
                          location.tr(
                            context: context,
                          ),
                          style: AppStylesManger.font15BoldrBlue
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    )
                  : Text(
                      location.tr(
                        context: context,
                      ),
                      style: AppStylesManger.font15BoldrBlue
                          .copyWith(color: Colors.black),
                    ),
              Text(
                'Present'.tr(
                  context: context,
                ),
                style: AppStylesManger.font15BoldrBlue
                    .copyWith(color: Colors.green),
              ),
            ],
          ),
          verticalSpace(12),
          const DottedLine(),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Clock In'.tr(
                      context: context,
                    ),
                    style: AppStylesManger.font15BoldrBlue
                        .copyWith(color: Colors.grey),
                  ),
                  inTime == '00:00:00'
                      ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                      : Text(
                          convertTo12HourFormat(
                            inTime.substring(0, 5),
                          ),
                          style: TextStyle(
                            color: isLate ? Colors.red : Colors.green,
                            fontWeight:
                                isLate ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Clock Out'.tr(
                      context: context,
                    ),
                    style: AppStylesManger.font15BoldrBlue
                        .copyWith(color: Colors.grey),
                  ),
                  outTime == '00:00:00'
                      ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                      : Text(
                          convertTo12HourFormat(
                            outTime.substring(0, 5),
                          ),
                          style: TextStyle(
                            color: isEarly ? Colors.red : Colors.green,
                            fontWeight:
                                isEarly ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Total hr'.tr(
                      context: context,
                    ),
                    style: AppStylesManger.font15BoldrBlue
                        .copyWith(color: Colors.grey),
                  ),
                  inTime == '00:00:00' || outTime == '00:00:00'
                      ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                      : Text(
                          double.parse(totalHours).toStringAsFixed(2),
                          style: TextStyle(
                            color: isEarly
                                ? Colors.red
                                : ColorsManger.primaryColor,
                            fontWeight:
                                isEarly ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                ],
              )
            ],
          ),
          horizontalSpace(15),
          location == 'Customer'
              ? GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        enableDrag: false,
                        context: context,
                        builder: (_) => BlocProvider.value(
                              value: context
                                  .read<SupervisorGetEmployeeAttendanceCubit>()
                                ..supervisorGetTrackingSummaryForEmployee(
                                    employeeId: employeeId),
                              child: EmployeeTrackingDiagramMap(),
                            ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ColorsManger.primaryColor,
                      ),
                      horizontalSpace(5),
                      Text(
                        'Location on Map'.tr(
                          context: context,
                        ),
                        style: AppStylesManger.font15BoldrBlue
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ]),
      ),
    );
  }
}
