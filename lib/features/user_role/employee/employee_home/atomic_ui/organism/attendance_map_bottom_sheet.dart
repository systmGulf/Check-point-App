import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/get_plan_by_employee_id_model.dart';

import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';
import '../molecules/time_and_date_widget.dart';
import 'check_in_bloc_builder.dart';
import 'check_out_bloc_builder.dart';

class AttendanceMapBottomSheet extends StatelessWidget {
  const AttendanceMapBottomSheet({
    super.key,
    required this.widget,
    required this.attendanceType,
    required this.area,
    required this.customerPlans,
  });

  final String widget;
  final AttendanceTypeEnum attendanceType;
  final String area;
  final Data customerPlans;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        minChildSize: 0.30.h,
        initialChildSize: 0.45.h,
        builder: (context, scrollController) {
          return IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.40),
                    child: Divider(
                      color: ColorsManger.primaryColor,
                      thickness: 1.5,
                    ),
                  ),
                  const TimeAndDateWidet(),
                  verticalSpace(40),
                  BlocBuilder<AttendanceCubit, AttendanceState>(
                    buildWhen: (previous, current) =>
                        current is AccessAbleAreaState ||
                        current is AccessAbleAreaErrorState ||
                        current is GetFeedBackStatusLoadingState ||
                        current is GetFeedBackStatusFailureState ||
                        current is GetFeedBackStatusSuccessState,
                    builder: (context, state) {
                      if (state is AccessAbleAreaState) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                      '${"You are in".tr(context: context)} ${"range".tr(context: context)} ${widget.tr(context: context)}',
                                      textAlign: TextAlign.center,
                                      style: AppStylesManger.font16blackMedium),
                                  const Spacer(),
                                  const Icon(Icons.location_on,
                                      color: Colors.green)
                                ],
                              ),
                            ),
                            verticalSpace(20),
                            attendanceType.name == "checkIn"
                                ? CheckInBlocBuilder(
                                    area: area,
                                  )
                                : CheckOutBlocBuilder(
                                    area: area,
                                    customerPlans: customerPlans,
                                  ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.red
                                    .shade100, // Red background color for "out of range"
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${"You are not in".tr(context: context)}  ${"range".tr(context: context)} ${widget.tr(context: context)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.location_off,
                                      color: Colors.red)
                                ],
                              ),
                            ),
                            verticalSpace(30),
                            Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                  size: 32,
                                ),
                                horizontalSpace(10),
                                Expanded(
                                  child: Text(
                                    '${"تحذير: أنت الآن خارج نطاق,  لا يمكنك ".tr()} ${attendanceType.name.tr(context: context)}.',
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
