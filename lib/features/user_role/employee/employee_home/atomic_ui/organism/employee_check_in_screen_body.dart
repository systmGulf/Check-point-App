import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/get_plan_by_employee_id_model.dart';
import 'package:lottie/lottie.dart' show Lottie;

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';
import '../molecules/custom_checking_screen_app_bar.dart';
import 'attendance_map_bottom_sheet.dart';
import 'check_in_auth_bloc_listener.dart';
import 'customer_map_screen.dart';
import 'office_map_screen.dart';
import 'site_map_screen.dart';

class EmployeeCheckInScreenBody extends StatefulWidget {
  const EmployeeCheckInScreenBody(
      {super.key, required this.checkType, required this.attendanceType});
  final String checkType;
  final AttendanceTypeEnum attendanceType;

  @override
  State<EmployeeCheckInScreenBody> createState() =>
      _EmployeeCheckInScreenBodyState();
}

class _EmployeeCheckInScreenBodyState extends State<EmployeeCheckInScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedByWidgetType(
          widgetType: WidgetAnimationType.container,
          child: widget.checkType == "Office"
              ? OfficeMapScreen(
                  attendanceType: widget.attendanceType,
                )
              : BlocBuilder<AttendanceCubit, AttendanceState>(
                  buildWhen: (previous, current) =>
                      current is GetCustomerAreaDone ||
                      current is GetCustomerAreaError ||
                      current is GetCustomerAreaLoading,
                  builder: (context, state) {
                    if (state is GetCustomerAreaDone) {
                      final today =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());

                      final matchingAreas = state.customerArea.value?.data
                          ?.where((area) => area.plan?.planDate != null)
                          .where((area) {
                        final planDate = DateFormat('yyyy-MM-dd')
                            .format(area.plan!.planDate!);
                        return planDate == today;
                      }).toList();

                      if (matchingAreas!.isNotEmpty) {
                        log(matchingAreas[0].plan!.planDate.toString());

                        return widget.checkType == "Customer"
                            ? CustomerMapScreen(
                                oncustomerChanged: (value) {},
                                attendanceType: widget.attendanceType,
                              )
                            : SiteMapScreen(
                                attendanceType: widget.attendanceType,
                              );
                      }
                    } else if (state is GetCustomerAreaError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            verticalSpace(10),
                            Text(
                              state.error,
                              style: AppStylesManger.font14RedularRed,
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedByWidgetType(
                              widgetType: WidgetAnimationType.image,
                              child: Lottie.asset(
                                'assets/animated_images/empty.json',
                                repeat: false,
                                height: 150.h,
                                width: 150.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            AnimatedByWidgetType(
                              widgetType: WidgetAnimationType.text,
                              delayDuration: const Duration(milliseconds: 200),
                              child: Text(
                                'You Do Not Have ${widget.checkType} Plans'
                                    .tr(context: context),
                                style: AppStylesManger.font15BoldRed.copyWith(
                                  color: ColorsManger.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        AttendanceMapBottomSheet(
          customerPlans: Data(),
          area: widget.checkType,
          attendanceType: widget.attendanceType,
          widget: widget.checkType,
        ),
        CustomCheckingScreenAppBar(
          text: 'Check In'.tr(context: context),
        ),
        const CheckInAuthBlocListener()
      ],
    );
  }
}
