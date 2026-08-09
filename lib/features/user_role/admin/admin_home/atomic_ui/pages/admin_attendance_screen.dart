import 'package:animate_do/animate_do.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:employee_mangement/core/widgets/build_alart_message.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/user_attendace_model.dart';

import '../../../../../../core/common/convert_time_to_12_houre_format.dart';
import '../../../../../../core/common/formate_worked_time_function.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/admin_attendance_cubit/admin_attendance_cubit.dart';

class AdminAttendanceScreen extends StatefulWidget {
  const AdminAttendanceScreen({super.key});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  final EasyInfiniteDateTimelineController _calendarController =
      EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;

    return Scaffold(
      appBar: buildCustomAppBar(context, 'Employees Attendance'.tr()),
      body: BlocConsumer<AdminAttendanceCubit, AdminAttendanceState>(
        listenWhen: (previous, current) =>
            current is AdminAttendanceExportLoading ||
            current is AdminAttendanceExportSuccess ||
            current is AdminAttendanceExportFailure ||
            current is AdminAttendanceDeleteLoading ||
            current is AdminAttendanceDeleteSuccess ||
            current is AdminAttendanceDeleteFailure,
        listener: (context, state) {
          if (state is AdminAttendanceExportLoading) {
            customLoadingIndicator(context);
          } else if (state is AdminAttendanceExportSuccess) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'Export success'.tr(),
              ),
            );
          } else if (state is AdminAttendanceExportFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.errorMsg.tr(),
              ),
            );
          } else if (state is AdminAttendanceDeleteLoading) {
            customLoadingIndicator(context);
          } else if (state is AdminAttendanceDeleteSuccess) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'Attendance deleted successfully'.tr(),
              ),
            );
          } else if (state is AdminAttendanceDeleteFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.errorMsg.tr(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EasyInfiniteDateTimeLine(
                  locale: currentLanguageCode,
                  activeColor: ColorsManger.primaryColor,
                  controller: _calendarController,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  focusDate: state.selectedDate,
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                  onDateChange: (selectedDate) {
                    if (selectedDate != state.selectedDate) {
                      context
                          .read<AdminAttendanceCubit>()
                          .setSelectedDate(selectedDate);
                    }
                  },
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
              Expanded(
                child: BlocBuilder<AdminAttendanceCubit, AdminAttendanceState>(
                  buildWhen: (previous, current) =>
                      current is AdminAttendanceLoading ||
                      current is AdminAttendanceSuccess ||
                      current is AdminAttendanceFailure,
                  builder: (context, state) {
                    if (state is AdminAttendanceLoading) {
                      return Skeletonizer(
                        enabled: true,
                        ignoreContainers: true,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 16),
                              child: AdminEmployeeAttendanceWidget(
                                employeeName: 'Employee Name Holder',
                                area: 'Office',
                                location: '30.059543946827535,31.22361885831085',
                                inTime: '9:21 AM',
                                outTime: 'Clock Out',
                                totalHours: 'Total hr',
                                employeeImage: null,
                                isLate: false,
                                isEarly: false,
                                onDelete: null,
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is AdminAttendanceFailure) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 40),
                          verticalSpace(10),
                          Text(state.errorMsg),
                          verticalSpace(10),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AdminAttendanceCubit>()
                                  .getAdminAttendance();
                            },
                            child: Text('Retry'.tr()),
                          )
                        ],
                      );
                    } else if (state is AdminAttendanceSuccess) {
                      final List<UserAttendanceData> filteredList = (state
                                  .employeeAllAttendance.attendancePage?.data ??
                              [])
                          .where((attendance) =>
                              attendance.attendanceDate ==
                              state.selectedDate.toString().substring(0, 10))
                          .toList();

                      if (filteredList.isEmpty) {
                        return const Center(child: NoDataFound());
                      }

                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  'Share as Excel : '.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (context.mounted) {
                                      _showExportOptionsBottomSheet(
                                        context,
                                        state.employeeAllAttendance
                                                .attendancePage?.data ??
                                            [],
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    size: 20.sp,
                                    color: ColorsManger.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FadeInUp(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final item = filteredList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  child: AdminEmployeeAttendanceWidget(
                                    employeeName: item.employeeName ?? '',
                                    area: item.area ?? '',
                                    location: item.location ?? '',
                                    inTime: item.clockInTime ?? '',
                                    outTime: item.clockOutTime ?? '',
                                    totalHours:
                                        item.totalHours?.toString() ?? '',
                                    employeeImage: item.employeeImage,
                                    isLate: item.isLate ?? false,
                                    isEarly: item.isEarly ?? false,
                                    onDelete: item.id == null
                                        ? null
                                        : () {
                                            buildDeleteAlertDialog(
                                              context,
                                              title: 'Delete Attendance'.tr(),
                                              message:
                                                  'Are you sure you want to delete this attendance?'
                                                      .tr(),
                                              onYes: () {
                                                context.pop();
                                                context
                                                    .read<
                                                        AdminAttendanceCubit>()
                                                    .deleteAttendance(item.id!);
                                              },
                                            );
                                          },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showExportOptionsBottomSheet(
      BuildContext parentContext, List<UserAttendanceData> allAttendance) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              verticalSpace(20),
              Text(
                'Select Export Range'.tr(),
                style: AppStylesManger.font18SemiBold
                    .copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              verticalSpace(20),
              _buildExportOptionTile(
                context: context,
                icon: Icons.calendar_today_rounded,
                title: 'Daily'.tr(),
                subtitle: 'Export attendance for the selected day'.tr(),
                onTap: () {
                  Navigator.pop(context);
                  parentContext
                      .read<AdminAttendanceCubit>()
                      .exportAttendanceToExcel(
                        allAttendance: allAttendance,
                        rangeType: 'daily',
                      );
                },
              ),
              verticalSpace(12),
              _buildExportOptionTile(
                context: context,
                icon: Icons.date_range_rounded,
                title: 'Weekly'.tr(),
                subtitle: 'Export attendance for the current week'.tr(),
                onTap: () {
                  Navigator.pop(context);
                  parentContext
                      .read<AdminAttendanceCubit>()
                      .exportAttendanceToExcel(
                        allAttendance: allAttendance,
                        rangeType: 'weekly',
                      );
                },
              ),
              verticalSpace(12),
              _buildExportOptionTile(
                context: context,
                icon: Icons.calendar_month_rounded,
                title: 'Monthly'.tr(),
                subtitle: 'Export attendance for the current month'.tr(),
                onTap: () {
                  Navigator.pop(context);
                  parentContext
                      .read<AdminAttendanceCubit>()
                      .exportAttendanceToExcel(
                        allAttendance: allAttendance,
                        rangeType: 'monthly',
                      );
                },
              ),
              verticalSpace(20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE9ECEF)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: ColorsManger.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: ColorsManger.primaryColor,
                size: 24.sp,
              ),
            ),
            horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStylesManger.font16BoldBlack,
                  ),
                  verticalSpace(4),
                  Text(
                    subtitle,
                    style: AppStylesManger.font12RegularGrey.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class AdminEmployeeAttendanceWidget extends StatelessWidget {
  final String employeeName;
  final String area;
  final String location;
  final String inTime;
  final String outTime;
  final String totalHours;
  final String? employeeImage;
  final bool isLate;
  final bool isEarly;
  final VoidCallback? onDelete;

  const AdminEmployeeAttendanceWidget({
    super.key,
    required this.employeeName,
    required this.area,
    required this.location,
    required this.inTime,
    required this.outTime,
    required this.totalHours,
    this.employeeImage,
    required this.isLate,
    required this.isEarly,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: AppContainerDecoration(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserImage(
                  imageUrl: employeeImage,
                  height: 40,
                ),
                horizontalSpace(10),
                Expanded(
                  child: Text(
                    employeeName,
                    style: AppStylesManger.font15BoldrBlue
                        .copyWith(color: Colors.black),
                  ),
                ),
                if (onDelete != null) ...[
                  horizontalSpace(10),
                  AppActionIconButton.delete(
                    size: 32,
                    onPressed: onDelete!,
                  ),
                ],
              ],
            ),
            verticalSpace(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        area.isEmpty
                            ? 'Unknown area'.tr(context: context)
                            : area.tr(context: context),
                        style: AppStylesManger.font15BoldrBlue
                            .copyWith(color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (location.isNotEmpty) ...[
                        verticalSpace(4),
                        Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStylesManger.font12RegularGrey.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                horizontalSpace(12),
                Text(
                  'Present'.tr(context: context),
                  style: AppStylesManger.font15BoldrBlue
                      .copyWith(color: Colors.green),
                ),
              ],
            ),
            verticalSpace(12),
            const DottedLine(),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: _AttendanceTimeItem(
                    title: 'Clock In'.tr(context: context),
                    child: inTime == '00:00:00' || inTime.isEmpty
                        ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              convertTo12HourFormat(
                                inTime.length >= 5
                                    ? inTime.substring(0, 5)
                                    : inTime,
                              ),
                              style: TextStyle(
                                color: isLate ? Colors.red : Colors.green,
                                fontWeight: isLate
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                  ),
                ),
                horizontalSpace(8),
                Expanded(
                  child: _AttendanceTimeItem(
                    title: 'Clock Out'.tr(context: context),
                    child: outTime == '00:00:00' || outTime.isEmpty
                        ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              convertTo12HourFormat(
                                outTime.length >= 5
                                    ? outTime.substring(0, 5)
                                    : outTime,
                              ),
                              style: TextStyle(
                                color: isEarly ? Colors.red : Colors.green,
                                fontWeight: isEarly
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                  ),
                ),
                horizontalSpace(8),
                Expanded(
                  child: _AttendanceTimeItem(
                    title: 'Total hr'.tr(context: context),
                    child: inTime == '00:00:00' ||
                            outTime == '00:00:00' ||
                            inTime.isEmpty ||
                            outTime.isEmpty
                        ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              formatWorkedTime(
                                  clockInTime: inTime, clockOutTime: outTime),
                              style: TextStyle(
                                color: isEarly
                                    ? Colors.red
                                    : ColorsManger.primaryColor,
                                fontWeight: isEarly
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceTimeItem extends StatelessWidget {
  const _AttendanceTimeItem({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppStylesManger.font15BoldrBlue.copyWith(color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        child,
      ],
    );
  }
}
