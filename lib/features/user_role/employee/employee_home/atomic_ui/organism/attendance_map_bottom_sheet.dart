import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';
import '../molecules/time_and_date_widget.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import '../../../../../../core/common/formate_hours.dart';
import 'check_in_bloc_builder.dart';
import 'check_out_bloc_builder.dart';

class AttendanceMapBottomSheet extends StatelessWidget {
  const AttendanceMapBottomSheet({
    super.key,
    required this.widget,
    required this.attendanceType,
    required this.area,
  });

  final String widget;
  final AttendanceTypeEnum attendanceType;
  final String area;

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
                    color: Colors.grey.withValues(alpha: 0.5),
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
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  const TimeAndDateWidet(),
                  BlocConsumer<AttendanceCubit, AttendanceState>(
                    listenWhen: (previous, current) =>
                        current is TrackingError ||
                        current is TrackingStarted ||
                        current is TrackingStopped,
                    listener: (context, state) {
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.hideCurrentSnackBar();
                      if (state is TrackingError) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      } else if (state is TrackingStarted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Tracking started'.tr())),
                        );
                      } else if (state is TrackingStopped) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Tracking stopped'.tr())),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is TrackingLoading ||
                        current is TrackingStatusChanged ||
                        current is TrackingStarted ||
                        current is TrackingStopped,
                    builder: (context, state) {
                      if (area == 'Office') {
                        return const SizedBox.shrink();
                      }

                      final cubit = context.read<AttendanceCubit>();
                      if (state is GetAttendanceTargetsLoading ||
                          state is GetAttendanceTargetsError ||
                          cubit.attendanceTargets.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final isLoading = state is TrackingLoading;
                      final isEnabled = state is TrackingStatusChanged
                          ? state.isTrackingEnabled
                          : cubit.isTrackingEnabled;

                      final String onlineUntilText = 'Online until'.tr() +
                          ' ' +
                          (ApiConstant.employeeCheckoutTime.isNotEmpty
                              ? formatHour(ApiConstant.employeeCheckoutTime)
                              : 'checkout'.tr());

                      return Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isEnabled || isLoading
                                ? null
                                : () => cubit.goOnline(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManger.primaryColor,
                              disabledBackgroundColor:
                                  ColorsManger.primaryColor.withValues(
                                alpha: 0.45,
                              ),
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              isLoading
                                  ? 'Starting...'.tr()
                                  : isEnabled
                                      ? onlineUntilText
                                      : 'Go Online'.tr(),
                              style: AppStylesManger.font16blackMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  verticalSpace(20),
                  BlocBuilder<AttendanceCubit, AttendanceState>(
                    buildWhen: (previous, current) =>
                        current is AccessAbleAreaState ||
                        current is AccessAbleAreaErrorState ||
                        current is GetFeedBackStatusLoadingState ||
                        current is GetFeedBackStatusFailureState ||
                        current is GetFeedBackStatusSuccessState ||
                        current is GetUserBranchDone ||
                        current is GetUserBranchLoading ||
                        current is GetAttendanceTargetsDone ||
                        current is GetAttendanceTargetsLoading ||
                        current is GetAttendanceTargetsError ||
                        current is AttendanceTargetSelected,
                    builder: (context, state) {
                      final cubit = context.read<AttendanceCubit>();
                      final hasAttendanceTargets =
                          cubit.attendanceTargets.isNotEmpty;

                      if (area != 'Office') {
                        if (state is GetAttendanceTargetsLoading) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: ColorsManger.primaryColor,
                                  ),
                                  verticalSpace(12),
                                  Text(
                                    'Loading attendance places...'.tr(),
                                    style: AppStylesManger.font16blackMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is GetAttendanceTargetsError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                state.error,
                                textAlign: TextAlign.center,
                                style: AppStylesManger.font16blackMedium,
                              ),
                            ),
                          );
                        }

                        if (!hasAttendanceTargets) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                area == 'Customer'
                                    ? 'No customers found'.tr()
                                    : 'No sites found'.tr(),
                                textAlign: TextAlign.center,
                                style: AppStylesManger.font16blackMedium,
                              ),
                            ),
                          );
                        }
                      }

                      if (cubit.currentUserLocation == null) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: ColorsManger.primaryColor,
                                ),
                                verticalSpace(12),
                                Text(
                                  'Getting current location...'.tr(),
                                  style: AppStylesManger.font16blackMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is AccessAbleAreaState) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9).withOpacity(0.3),
                                border: Border.all(color: Colors.green.shade200, width: 1.2),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  horizontalSpace(12),
                                  Expanded(
                                    child: Text(
                                      '${"You are in".tr()} ${"range".tr()} ${widget.tr()}',
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.wifi_rounded,
                                    color: Colors.green.shade700,
                                    size: 20.sp,
                                  ),
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
                                  ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBEE).withOpacity(0.3),
                                border: Border.all(color: Colors.red.shade200, width: 1.2),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  horizontalSpace(12),
                                  Expanded(
                                    child: Text(
                                      '${"You are not in".tr()} ${"range".tr()} ${widget.tr()}',
                                      style: TextStyle(
                                        color: Colors.red.shade800,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.wifi_off_rounded,
                                    color: Colors.red.shade700,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace(20),
                            Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                horizontalSpace(10),
                                Expanded(
                                  child: Text(
                                    '${"تحذير: أنت الآن خارج نطاق,  لا يمكنك ".tr()} ${attendanceType.name.tr()}.',
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                      fontSize: 14.sp,
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
