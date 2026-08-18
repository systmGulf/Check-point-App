import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../controller/odoo_dashboard/odoo_dashboard_cubit.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';

class OdooDashboardScreen extends StatelessWidget {
  const OdooDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorsManger.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Odoo Dashboard'.tr(),
          style: const TextStyle(
            color: Color(0xFF24252C),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF24252C)),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: RefreshIndicator(
        color: ColorsManger.primaryColor,
        onRefresh: () => context.read<OdooDashboardCubit>().fetchDashboardData(),
        child: BlocBuilder<OdooDashboardCubit, OdooDashboardState>(
          builder: (context, state) {
            if (state is OdooDashboardLoading) {
              return Center(
                child: CircularProgressIndicator(color: ColorsManger.primaryColor),
              );
            }

            if (state is OdooDashboardFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64.sp),
                      verticalSpace(16),
                      Text(
                        'Failed to load Odoo dashboard'.tr(),
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      verticalSpace(8),
                      Text(
                        state.error.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      verticalSpace(24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<OdooDashboardCubit>().fetchDashboardData();
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text('Retry'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManger.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is OdooDashboardSuccess) {
              final status = state.status;
              final attendanceData = state.attendanceData;
              final leaveRequests = state.leaveRequests;
              final bool isCheckedIn = status['checked_in'] ?? false;
              final String employeeName = status['employee_name'] ?? '';

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                children: [
                  // Greeting & Status Header Card
                  _buildHeaderCard(employeeName, isCheckedIn),
                  verticalSpace(20),

                  // Period Selector Row
                  _buildPeriodSelector(context),
                  verticalSpace(20),

                  // Stats Row Cards
                  _buildStatsRow(attendanceData, leaveRequests),
                  verticalSpace(24),

                  // Recent Attendance
                  _buildSectionHeader('Recent Attendance'.tr()),
                  verticalSpace(12),
                  if (attendanceData.attendances.isEmpty)
                    _buildEmptyState('No attendance logs found for this period.'.tr())
                  else
                    ...attendanceData.attendances.take(5).map((log) => _buildAttendanceCard(context, log)),

                  verticalSpace(24),

                  // Recent Leave Requests
                  _buildSectionHeader('Recent Leave Requests'.tr()),
                  verticalSpace(12),
                  if (leaveRequests.isEmpty)
                    _buildEmptyState('No leave requests found.'.tr())
                  else
                    ...leaveRequests.take(5).map((req) => _buildLeaveRequestCard(context, req)),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String employeeName, bool isCheckedIn) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorsManger.primaryColor.withOpacity(0.12),
            radius: 30.r),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employeeName,
                  style: TextStyle(
                    color: const Color(0xFF24252C),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(4),
                Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: isCheckedIn ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    horizontalSpace(8),
                    Text(
                      isCheckedIn ? 'Currently Checked In'.tr() : 'Currently Checked Out'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final cubit = context.read<OdooDashboardCubit>();
    final currentPeriod = cubit.period;
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildPeriodBtn(context, 'week', 'Week'.tr(), currentPeriod == 'week'),
          _buildPeriodBtn(context, 'month', 'Month'.tr(), currentPeriod == 'month'),
          _buildPeriodBtn(context, 'year', 'Year'.tr(), currentPeriod == 'year'),
        ],
      ),
    );
  }

  Widget _buildPeriodBtn(BuildContext context, String periodKey, String title, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<OdooDashboardCubit>().changePeriod(periodKey),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? ColorsManger.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(OdooMyAttendanceData attendanceData, List<OdooLeaveRequest> leaves) {
    final double workedHrs = attendanceData.totalWorkedHours;
    final int workedDays = attendanceData.count;
    final double leavesCount = leaves.fold(0.0, (sum, item) => sum + item.numberOfDays);

    return Row(
      children: [
        _buildStatCard(
          icon: Icons.access_time_rounded,
          value: '${workedHrs.toStringAsFixed(1)}h',
          label: 'Work Hours'.tr(),
          bgColor: const Color(0xFFE8F5E9),
          iconColor: Colors.green,
        ),
        horizontalSpace(12),
        _buildStatCard(
          icon: Icons.calendar_today_rounded,
          value: '$workedDays',
          label: 'Work Days'.tr(),
          bgColor: const Color(0xFFE3F2FD),
          iconColor: Colors.blue,
        ),
        horizontalSpace(12),
        _buildStatCard(
          icon: Icons.beach_access_rounded,
          value: '${leavesCount.toStringAsFixed(1)}d',
          label: 'Leaves'.tr(),
          bgColor: const Color(0xFFFFF3E0),
          iconColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            verticalSpace(12),
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF24252C),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpace(4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF24252C),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, OdooAttendanceLog log) {
    final DateFormat timeFormat = DateFormat('hh:mm a', context.locale.toString());
    final DateFormat dateFormat = DateFormat('dd MMM yyyy', context.locale.toString());
    final DateTime inTime = DateTime.parse(log.checkIn);
    final DateTime? outTime = log.checkOut != null ? DateTime.parse(log.checkOut!) : null;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: ColorsManger.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.login_rounded, color: ColorsManger.primaryColor, size: 22.sp),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(inTime),
                      style: TextStyle(
                        color: const Color(0xFF24252C),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: ColorsManger.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        log.location.tr(),
                        style: TextStyle(
                          color: ColorsManger.primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(6),
                Text(
                  '${timeFormat.format(inTime)} - ${outTime != null ? timeFormat.format(outTime) : 'Active'.tr()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestCard(BuildContext context, OdooLeaveRequest req) {
    final DateFormat dateFormat = DateFormat('dd MMM yyyy', context.locale.toString());
    final DateTime start = DateTime.parse(req.dateFrom);
    final DateTime end = DateTime.parse(req.dateTo);

    Color statusColor = Colors.orange;
    String statusText = 'Pending';
    if (req.state == 'validate') {
      statusColor = Colors.green;
      statusText = 'Approved';
    } else if (req.state == 'refuse') {
      statusColor = Colors.red;
      statusText = 'Rejected';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.beach_access_rounded, color: statusColor, size: 22.sp),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      req.leaveTypeName,
                      style: TextStyle(
                        color: const Color(0xFF24252C),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        statusText.tr(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(6),
                Text(
                  '${dateFormat.format(start)} - ${dateFormat.format(end)} (${req.numberOfDays.toStringAsFixed(1)} ${'days'.tr()})',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
