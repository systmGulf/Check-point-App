import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/repo/leave_requests_repo/admin_leave_requests_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class AdminDashboardBoard extends StatefulWidget {
  const AdminDashboardBoard({super.key});

  @override
  State<AdminDashboardBoard> createState() => AdminDashboardBoardState();
}

class AdminDashboardBoardState extends State<AdminDashboardBoard> {
  bool _isLoading = false;
  int _departmentsCount = 0;
  int _branchesCount = 0;
  int _todayAttendanceCount = 0;
  int _pendingLeavesCount = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final employeeCubit = context.read<EmployeeCubit>();
      
      // 1. Fetch Employees & Account Requests from backend
      await Future.wait([
        employeeCubit.getAllEmployees(pageNumber: 0, itemCount: 100),
        employeeCubit.getAddAccountRequests(),
      ]);

      // 2. Fetch Departments count from backend
      try {
        final departmentRepo = getIt<DepartmentRepo>();
        final deptResult = await departmentRepo.getAllDepartments(pageKey: 0, pageSize: 100);
        deptResult.fold(
          (l) => null,
          (r) {
            if (mounted) {
              _departmentsCount = r.totalCount ?? r.data?.length ?? 0;
            }
          },
        );
      } catch (e) {
        debugPrint("Error fetching departments: $e");
      }

      // 3. Fetch Branches count from backend
      try {
        final branchesRepo = getIt<BranchesRepo>();
        final branchResult = await branchesRepo.getAllBranches();
        branchResult.fold(
          (l) => null,
          (r) {
            if (mounted) {
              _branchesCount = r.data?.length ?? 0;
            }
          },
        );
      } catch (e) {
        debugPrint("Error fetching branches: $e");
      }

      // 4. Fetch Today's Attendance records from backend
      try {
        final apiService = getIt<ApiService>();
        final attResult = await apiService.get(endPoint: "Attendance?itemCount=1000&index=0");
        if (attResult != null && attResult['isSuccess'] == true && attResult['data'] != null) {
          final List dataList = attResult['data'];
          final todayStr = DateTime.now().toString().substring(0, 10);
          final todayRecords = dataList.where((item) {
            final date = item['attendanceDate']?.toString();
            return date != null && date.startsWith(todayStr);
          }).toList();
          
          if (mounted) {
            _todayAttendanceCount = todayRecords.length;
          }
        }
      } catch (e) {
        debugPrint("Error fetching attendance: $e");
      }

      // 5. Fetch Pending Leave Requests from backend
      try {
        final leaveRepo = getIt<AdminLeaveRequestsRepo>();
        final leaveResult = await leaveRepo.getAllLeaveRequests();
        leaveResult.fold(
          (l) => null,
          (r) {
            if (mounted && r.value?.data != null) {
              _pendingLeavesCount = r.value!.data!.where((req) {
                final status = req.status;
                return status == 'Pending' || status == 0 || status == '0' || status == null;
              }).length;
            }
          },
        );
      } catch (e) {
        debugPrint("Error fetching leave requests: $e");
      }
    } catch (e) {
      debugPrint("Error loading admin board metrics: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "AD";
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    } else if (parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return "AD";
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = ApiConstant.username.isNotEmpty ? ApiConstant.username : 'Admin';
    final String rawPosition = ApiConstant.position.isNotEmpty ? ApiConstant.position : 'HR Director';
    final String position = rawPosition.tr();
    final String initials = _getInitials(displayName);

    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        final cubit = context.read<EmployeeCubit>();
        final int totalEmployees = cubit.totalEmployeesCount ?? 0;
        final int pendingAccountRequests = cubit.totalAccountRequestsCount ?? 0;
        final int totalPendingActions = pendingAccountRequests + _pendingLeavesCount;

        // Calculate attendance percentage
        final int attendancePercentage = totalEmployees > 0
            ? ((_todayAttendanceCount / totalEmployees) * 100).round()
            : 0;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7F1D1D), // Dark Crimson Red
                Color(0xFF991B1B), // Rich Red
                Color(0xFFB91C1C), // Primary Red
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7F1D1D).withOpacity(0.4),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              children: [
                // Background subtle organic blur circles
                Positioned(
                  top: -40.h,
                  right: -30.w,
                  child: Container(
                    width: 170.w,
                    height: 170.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60.h,
                  left: -40.w,
                  child: Container(
                    width: 220.w,
                    height: 220.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Admin Dashboard".tr(),
                                    style: TextStyle(
                                      color: const Color(0xFFFBBF24),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  const Text("⚡", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                displayName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                position,
                                style: TextStyle(
                                  color: const Color(0xFFFDE68A),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Bell Notification Icon with badge count
                              GestureDetector(
                                onTap: () {
                                  context
                                      .pushName(Routes.adminNotificationScreen)
                                      .then((_) {
                                    fetchDashboardData();
                                  });
                                },
                                child: Container(
                                  width: 44.r,
                                  height: 44.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.notifications_none_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      if (totalPendingActions > 0)
                                        Positioned(
                                          top: 5.h,
                                          right: 5.w,
                                          child: Container(
                                            padding: EdgeInsets.all(4.r),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFEF4444),
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 16.r,
                                              minHeight: 16.r,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$totalPendingActions',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Avatar circle with Initials
                              Container(
                                width: 44.r,
                                height: 44.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      color: const Color(0xFF7F1D1D),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // 2x2 Grid of Stat Cards
                      Row(
                        children: [
                          _buildStatCard(
                            iconWidget: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: const Icon(
                                Icons.people_alt_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            trendWidget: const Icon(
                              Icons.trending_up_rounded,
                              color: Color(0xFF34D399),
                              size: 20,
                            ),
                            value: '$totalEmployees',
                            title: "Total Employees".tr(),
                            subtitle: "Active in system".tr(),
                          ),
                          SizedBox(width: 10.w),
                          _buildStatCard(
                            iconWidget: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: const Icon(
                                Icons.bar_chart_rounded,
                                color: Color(0xFF0284C7),
                                size: 20,
                              ),
                            ),
                            trendWidget: Icon(
                              attendancePercentage >= 50
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              color: attendancePercentage >= 50
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFFF87171),
                              size: 20,
                            ),
                            value: "$attendancePercentage%",
                            title: "Attendance Today".tr(),
                            subtitle: "$_todayAttendanceCount ${'present today'.tr()}",
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          _buildStatCard(
                            iconWidget: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Color(0xFF38BDF8),
                                size: 20,
                              ),
                            ),
                            trendWidget: const SizedBox.shrink(),
                            value: "$_departmentsCount",
                            title: "Departments".tr(),
                            subtitle: _branchesCount > 0
                                ? "Across {} branches".tr(args: ['$_branchesCount'])
                                : "Company departments".tr(),
                          ),
                          SizedBox(width: 10.w),
                          _buildStatCard(
                            iconWidget: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                color: Color(0xFFFBBF24),
                                size: 22,
                              ),
                            ),
                            trendWidget: const Icon(
                              Icons.trending_down_rounded,
                              color: Color(0xFFF87171),
                              size: 20,
                            ),
                            value: "$totalPendingActions",
                            title: "Pending Actions".tr(),
                            subtitle: totalPendingActions > 0
                                ? "Needs attention".tr()
                                : "All actions settled".tr(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required Widget iconWidget,
    required Widget trendWidget,
    required String value,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconWidget,
                trendWidget,
              ],
            ),
            SizedBox(height: 10.h),
            _isLoading
                ? SizedBox(
                    height: 24.h,
                    width: 24.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
            SizedBox(height: 4.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFFDE68A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
