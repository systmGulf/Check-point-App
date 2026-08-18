import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../controllers/odoo_admin_dashboard/odoo_admin_dashboard_cubit.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';

class OdooAdminDashboardScreen extends StatefulWidget {
  const OdooAdminDashboardScreen({super.key});

  @override
  State<OdooAdminDashboardScreen> createState() => _OdooAdminDashboardScreenState();
}

class _OdooAdminDashboardScreenState extends State<OdooAdminDashboardScreen> {
  final TextEditingController employeeIdController = TextEditingController();
  String? selectedLoc;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  @override
  void dispose() {
    employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorsManger.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Odoo Admin Dashboard'.tr(),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF24252C)),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: ColorsManger.primaryColor,
        onRefresh: () => context.read<OdooAdminDashboardCubit>().fetchAdminDashboardData(),
        child: BlocBuilder<OdooAdminDashboardCubit, OdooAdminDashboardState>(
          builder: (context, state) {
            if (state is OdooAdminDashboardLoading) {
              return Center(
                child: CircularProgressIndicator(color: ColorsManger.primaryColor),
              );
            }

            if (state is OdooAdminDashboardFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64.sp),
                      verticalSpace(16),
                      Text(
                        'Failed to load Admin dashboard'.tr(),
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
                          context.read<OdooAdminDashboardCubit>().fetchAdminDashboardData();
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

            if (state is OdooAdminDashboardSuccess) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                children: [
                  // Active Filters Indicator
                  if (_hasActiveFilters()) _buildActiveFiltersIndicator(context),

                  // Overall Stats Overview
                  _buildAdminStatsRow(state),
                  verticalSpace(24),

                  // Attendance Log Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Attendance Logs'.tr(),
                        style: TextStyle(
                          color: const Color(0xFF24252C),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${state.totalCount} ${'records'.tr()}',
                        style: TextStyle(
                          color: ColorsManger.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(12),

                  if (state.attendances.isEmpty)
                    _buildEmptyState('No attendance matching the filter criteria.'.tr())
                  else
                    ...state.attendances.map((log) => _buildAdminAttendanceCard(log)),

                  verticalSpace(24),

                  // Public Holidays Section
                  Text(
                    'Configured Public Holidays'.tr(),
                    style: TextStyle(
                      color: const Color(0xFF24252C),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace(12),
                  if (state.publicHolidays.isEmpty)
                    _buildEmptyState('No public holidays configured.'.tr())
                  else
                    ...state.publicHolidays.map((holiday) => _buildHolidayCard(holiday)),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return employeeIdController.text.isNotEmpty ||
        selectedLoc != null ||
        selectedFromDate != null ||
        selectedToDate != null;
  }

  Widget _buildActiveFiltersIndicator(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorsManger.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManger.primaryColor.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.filter_alt_rounded, color: ColorsManger.primaryColor, size: 18.sp),
              horizontalSpace(8),
              Text(
                'Active Filters Applied'.tr(),
                style: TextStyle(
                  color: ColorsManger.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                employeeIdController.clear();
                selectedLoc = null;
                selectedFromDate = null;
                selectedToDate = null;
              });
              context.read<OdooAdminDashboardCubit>().clearFilters();
            },
            child: Text(
              'Clear'.tr(),
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminStatsRow(OdooAdminDashboardSuccess state) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.people_rounded,
          value: '${state.totalCount}',
          label: 'Total Logs'.tr(),
          bgColor: const Color(0xFFE8F5E9),
          iconColor: Colors.green,
        ),
        horizontalSpace(12),
        _buildStatCard(
          icon: Icons.holiday_village_rounded,
          value: '${state.publicHolidays.length}',
          label: 'Holidays'.tr(),
          bgColor: const Color(0xFFFFF3E0),
          iconColor: Colors.orange,
        ),
        horizontalSpace(12),
        _buildStatCard(
          icon: Icons.category_rounded,
          value: '${state.leaveTypes.length}',
          label: 'Leave Types'.tr(),
          bgColor: const Color(0xFFE3F2FD),
          iconColor: Colors.blue,
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
        padding: EdgeInsets.all(16.r),
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

  Widget _buildAdminAttendanceCard(OdooAttendanceLog log) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');
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
            child: Icon(Icons.person_rounded, color: ColorsManger.primaryColor, size: 22.sp),
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
                      log.employeeName,
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
                  '${dateFormat.format(inTime)} | ${timeFormat.format(inTime)} - ${outTime != null ? timeFormat.format(outTime) : 'Active'.tr()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
                if (log.workedHours > 0) ...[
                  verticalSpace(4),
                  Text(
                    '${'Worked Hours'.tr()}: ${log.workedHours.toStringAsFixed(1)} hrs',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidayCard(OdooPublicHoliday holiday) {
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');
    final DateTime start = DateTime.parse(holiday.dateFrom);
    final DateTime end = DateTime.parse(holiday.dateTo);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManger.primaryColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManger.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: ColorsManger.primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.beach_access_rounded, color: ColorsManger.primaryColor, size: 20.sp),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holiday.name,
                  style: TextStyle(
                    color: const Color(0xFF24252C),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(4),
                Text(
                  '${dateFormat.format(start)} - ${dateFormat.format(end)}',
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
            top: 24.h,
            left: 20.w,
            right: 20.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Attendance'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF24252C),
                ),
              ),
              verticalSpace(16),

              // Employee ID Textfield
              TextField(
                controller: employeeIdController,
                decoration: InputDecoration(
                  labelText: 'Employee UUID'.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              verticalSpace(16),

              // Location Dropdown
              DropdownButtonFormField<String>(
                value: selectedLoc,
                decoration: InputDecoration(
                  labelText: 'Location'.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                items: [
                  DropdownMenuItem(value: 'office', child: Text('Office'.tr())),
                  DropdownMenuItem(value: 'customer', child: Text('Customer'.tr())),
                  DropdownMenuItem(value: 'site', child: Text('Site'.tr())),
                ],
                onChanged: (val) {
                  selectedLoc = val;
                },
              ),
              verticalSpace(16),

              // Date From and Date To buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedFromDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedFromDate = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        selectedFromDate == null
                            ? 'Date From'.tr()
                            : DateFormat('yyyy-MM-dd').format(selectedFromDate!),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedToDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedToDate = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        selectedToDate == null
                            ? 'Date To'.tr()
                            : DateFormat('yyyy-MM-dd').format(selectedToDate!),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(24),

              // Submit Action
              ElevatedButton(
                onPressed: () {
                  final String? fromStr = selectedFromDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedFromDate!)
                      : null;
                  final String? toStr = selectedToDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedToDate!)
                      : null;

                  context.read<OdooAdminDashboardCubit>().updateFilters(
                        employeeId: employeeIdController.text,
                        location: selectedLoc,
                        from: fromStr,
                        to: toStr,
                      );
                  Navigator.pop(sheetCtx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManger.primaryColor,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'Apply Filters'.tr(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpace(16),
            ],
          ),
        );
      },
    );
  }
}
