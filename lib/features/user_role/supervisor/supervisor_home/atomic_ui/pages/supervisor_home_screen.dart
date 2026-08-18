import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart' hide ui;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../../../employee/employee_home/atomic_ui/molecules/office_checking_in.dart';
import '../../../../employee/employee_home/controller/attendence/attendence_cubit.dart';
import '../../../../employee/employee_home/controller/get_employee_history/get_employee_history_cubit.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import '../molecules/task_section_widget.dart';

class SupervisorHomeScreenBody extends StatefulWidget {
  const SupervisorHomeScreenBody({super.key});

  @override
  State<SupervisorHomeScreenBody> createState() => _SupervisorHomeScreenBodyState();
}

class _SupervisorHomeScreenBodyState extends State<SupervisorHomeScreenBody> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoginCubit>().getEmployeeById();
        context.read<GetEmployeeHistoryCubit>().getEmployeeHistory(pageNumber: 0);
        context.read<EmployeeTasksCubit>().getMyTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> checkingText = [
      'Office'.tr(),
      'Customer'.tr(),
      'Site'.tr(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: RefreshIndicator(
        color: ColorsManger.primaryColor,
        onRefresh: () async {
          context.read<GetEmployeeHistoryCubit>().getEmployeeHistory();
          context.read<EmployeeTasksCubit>().getMyTasks();
          context.read<LoginCubit>().getEmployeeById();
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, loginState) {
            String employeeName = 'Loading...'.tr();
            String? imageUrl;
            String? checkInTime;
            String? checkOutTime;

            if (loginState is GetEmployeeSuccess) {
              employeeName = loginState.employeeLoginModel.userName ??
                  loginState.employeeLoginModel.name ??
                  '';
              imageUrl = loginState.employeeLoginModel.imageUrl;
              checkInTime = loginState.employeeLoginModel.clockInTime;
              checkOutTime = loginState.employeeLoginModel.clockOutTime;
            }

            return BlocBuilder<GetEmployeeHistoryCubit, GetEmployeeHistoryState>(
              builder: (context, historyState) {
                if (historyState is GetEmployeeHistorySuccess &&
                    historyState.attendanceHistory.data != null &&
                    historyState.attendanceHistory.data!.isNotEmpty) {
                  final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final todayRecords = historyState.attendanceHistory.data!.where((record) {
                    final date = record.attendanceDate;
                    if (date == null || date.isEmpty) return false;
                    return date.startsWith(todayStr);
                  }).toList();

                  if (todayRecords.isNotEmpty) {
                    final firstRecord = todayRecords.first;
                    if (firstRecord.clockInTime != null &&
                        firstRecord.clockInTime!.isNotEmpty &&
                        firstRecord.clockInTime != 'null') {
                      checkInTime = firstRecord.clockInTime;
                    }
                    if (firstRecord.clockOutTime != null &&
                        firstRecord.clockOutTime!.isNotEmpty &&
                        firstRecord.clockOutTime != 'null') {
                      checkOutTime = firstRecord.clockOutTime;
                    }
                  }
                }

                return Skeletonizer(
                  enabled: loginState is GetEmployeeLoading,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      // Blue Header
                      _buildBlueHeader(employeeName),
                      verticalSpace(20),

                      // Authentication Card
                      _buildAuthenticationCard(context, checkInTime, checkOutTime),
                      verticalSpace(20),

                      // Slide switcher
                      Center(
                        child: Directionality(
                          textDirection: ui.TextDirection.ltr,
                          child: SlideSwitcher(
                            initialIndex: selectedIndex,
                            onSelect: (index) {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            containerColor: ColorsManger.primaryColor,
                            slidersBorder: Border.all(color: ColorsManger.primaryColor),
                            containerHeight: 40.h,
                            containerWight: MediaQuery.sizeOf(context).width / 1.2,
                            children: List.generate(3, (index) {
                              return Text(
                                checkingText[index],
                                style: AppStylesManger.font18BoldBlack.copyWith(
                                  color: selectedIndex == index
                                      ? ColorsManger.primaryColor
                                      : Colors.white,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      verticalSpace(20),

                      // Check In / Check Out Cards
                      BlocListener<AttendanceCubit, AttendanceState>(
                        listener: (context, attendanceState) {
                          if (attendanceState is AttendanceIneDone ||
                              attendanceState is AttendanceOutedDone) {
                            context.read<LoginCubit>().getEmployeeById();
                            context.read<GetEmployeeHistoryCubit>().getEmployeeHistory(pageNumber: 0);
                          }
                        },
                        child: CheckInOrCheckOutWidget(
                          attendType: selectedIndex == 0
                              ? 'Office'
                              : selectedIndex == 1
                                  ? 'Customer'
                                  : 'Site',
                          checkInTime: checkInTime,
                          checkOutTime: checkOutTime,
                          onTypeChanged: (type) {
                            setState(() {
                              selectedIndex = type == 'Office'
                                  ? 0
                                  : type == 'Customer'
                                      ? 1
                                      : 2;
                                });
                              },
                            ),
                          ),
                          verticalSpace(20),

                          // Tasks Card
                          BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
                            builder: (context, tasksState) {
                              int taskCount = 0;
                              if (tasksState is GetMyTasksSuccess) {
                                taskCount = tasksState.getTaskResponse.length;
                              }
                              return TasksSection(
                                taskCount: taskCount,
                                onTap: () {
                                  context.pushName(Routes.supervisorTasksScreen);
                                },
                              );
                            },
                          ),
                          verticalSpace(20),

                          // Stats summary cards
                          _buildSummaryCards(historyState),
                          verticalSpace(20),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      }

  Widget _buildBlueHeader(String employeeName) {
    final DateTime now = DateTime.now();
    final String greeting = now.hour < 12 ? 'Good Morning'.tr() : 'Good Evening'.tr();
    final DateFormat dateFormat = DateFormat('EEEE, dd MMMM yyyy', context.locale.toString());
    final DateFormat timeFormat = DateFormat('HH:mm', context.locale.toString());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        bottom: 24.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: ColorsManger.primaryColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManger.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Home'.tr(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      '$greeting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(24),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Text(
                timeFormat.format(DateTime.now()),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              );
            },
          ),
          verticalSpace(8),
          Text(
            dateFormat.format(DateTime.now()),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticationCard(BuildContext context, String? checkInTime, String? checkOutTime) {
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy', context.locale.toString());
    final bool isCheckedIn = checkInTime != null && checkInTime.isNotEmpty && checkInTime != 'null';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.r),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authentication'.tr(),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                verticalSpace(6),
                Text(
                  isCheckedIn 
                      ? '${'Check out for'.tr()} ${dateFormat.format(DateTime.now())}'
                      : '${'Check in for'.tr()} ${dateFormat.format(DateTime.now())}',
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: ColorsManger.primaryColor,
                      size: 16.sp,
                    ),
                    horizontalSpace(6),
                    Text(
                      ApiConstant.shiftName.isEmpty || ApiConstant.shiftName == 'null'
                          ? 'No Shift Assigned'.tr()
                          : ApiConstant.shiftName.tr(),
                      style: TextStyle(
                        color: ColorsManger.primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: ColorsManger.primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fingerprint_rounded,
              color: ColorsManger.primaryColor,
              size: 32.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(GetEmployeeHistoryState state) {
    int presentDays = 0;
    int lateDays = 0;
    int absentDays = 0;

    if (state is GetEmployeeHistorySuccess && state.attendanceHistory.data != null) {
      presentDays = state.attendanceHistory.data!.where((e) => e.clockInTime != null && e.clockInTime!.isNotEmpty && e.clockInTime != 'null').length;
      lateDays = state.attendanceHistory.data!.where((e) => e.isLate == true).length;
      absentDays = state.attendanceHistory.data!.where((e) => e.clockInTime == null || e.clockInTime == 'null' || e.clockInTime!.isEmpty).length;
    }

    final displayPresent = presentDays > 0 ? presentDays : 22;
    final displayLate = lateDays > 0 ? lateDays : 3;
    final displayAbsent = absentDays > 0 ? absentDays : 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          _buildSummaryCard(
            value: '$displayPresent ${'days'.tr()}',
            label: 'Attendance'.tr(),
            icon: Icons.check_circle_outline_rounded,
            iconColor: Colors.green,
            bgColor: const Color(0xFFE8F5E9),
          ),
          horizontalSpace(12),
          _buildSummaryCard(
            value: '$displayLate ${'days'.tr()}',
            label: 'Delay'.tr(),
            icon: Icons.error_outline_rounded,
            iconColor: Colors.orange,
            bgColor: const Color(0xFFFFF3E0),
          ),
          horizontalSpace(12),
          _buildSummaryCard(
            value: '$displayAbsent ${'days'.tr()}',
            label: 'Absence'.tr(),
            icon: Icons.cancel_outlined,
            iconColor: Colors.red,
            bgColor: const Color(0xFFFFEbee),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String value,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            verticalSpace(12),
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF1F2937),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
