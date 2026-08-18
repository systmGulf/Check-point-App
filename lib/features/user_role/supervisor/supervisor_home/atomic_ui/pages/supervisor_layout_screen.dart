import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/app_settings_screen.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_mangement/core/services/odoo_timeoff_service.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_leave_requests_repo/employee_action_repo.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../employee/employee_home/atomic_ui/molecules/employee_more_option_drawer.dart';
import '../../../../employee/employee_home/atomic_ui/organism/employee_custom_drawer.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import 'attandace_screen.dart';
import 'supervisor_home_screen.dart';
import 'supervisor_requests_screen.dart';
import 'supervisor_tasks_screen.dart';

class SupervisorLayoutScreen extends StatefulWidget {
  const SupervisorLayoutScreen({super.key});
  static GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  State<SupervisorLayoutScreen> createState() => _SupervisorLayoutScreenState();
}

class _SupervisorLayoutScreenState extends State<SupervisorLayoutScreen> {
  int selectedIndex = 0;
  PageController controller = PageController();

  static GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<String> texts = [
      'Home'.tr(),
      'Attendance'.tr(),
      'Tasks'.tr(),
      'Requests'.tr(),
      'Settings'.tr(),
    ];
    return Scaffold(
      key: scaffoldkey,
      endDrawer: const Drawer(
        child: EmployeeCustomDrawer(),
      ),
      drawer: Drawer(
        child: BlocProvider(
          create: (context) => LeaveApplicationCubit(
            employeeRepo: getIt<EmployeeActionRepo>(),
            odooTimeOffService: getIt<OdooTimeOffService>(),
          ),
          child: const EmployeeMoreOptionDrawer(),
        ),
      ),
      appBar: selectedIndex == 0 || selectedIndex == 4
          ? null // Home and Settings screens have their own headers
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    scaffoldkey.currentState?.openEndDrawer();
                  },
                  icon: CircleAvatar(
                    backgroundColor: ColorsManger.primaryColor,
                    radius: 20,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
              centerTitle: true,
              leadingWidth: 80.w,
              title: Text(
                texts[selectedIndex],
                style: AppStylesManger.font18BoldBlack,
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 64.h,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(texts.length, (index) {
                final bool isSelected = selectedIndex == index;
                IconData iconData;
                switch (index) {
                  case 0:
                    iconData = isSelected ? Icons.home_rounded : Icons.home_outlined;
                    break;
                  case 1:
                    iconData = isSelected ? Icons.calendar_month_rounded : Icons.calendar_month_outlined;
                    break;
                  case 2:
                    iconData = isSelected ? Icons.assignment_rounded : Icons.assignment_outlined;
                    break;
                  case 3:
                    iconData = isSelected ? Icons.description_rounded : Icons.description_outlined;
                    break;
                  case 4:
                    iconData = isSelected ? Icons.settings_rounded : Icons.settings_outlined;
                    break;
                  default:
                    iconData = Icons.home_rounded;
                }

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      controller.animateToPage(
                        selectedIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuad,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 24.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: isSelected ? ColorsManger.primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        Icon(
                          iconData,
                          color: isSelected ? ColorsManger.primaryColor : const Color(0xFF9CA3AF),
                          size: 24.sp,
                        ),
                        Text(
                          texts[index],
                          style: TextStyle(
                            color: isSelected ? ColorsManger.primaryColor : const Color(0xFF9CA3AF),
                            fontSize: 11.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: screens,
      ),
    );
  }

  List<Widget> screens = [
    const SupervisorHomeScreenBody(),
    BlocProvider(
      create: (context) => getIt<SupervisorGetEmployeeAttendanceCubit>()
        ..supervisorGetEmployeesAttendanceByDepartmentId(),
      child: const EmployeeAttendance(),
    ),
    BlocProvider(
      create: (context) => getIt<TasksCubit>()..getTasks(),
      child: SupervisorTasksScreen(),
    ),
    BlocProvider(
      create: (context) => getIt<LeaveApplicationCubitSupervisor>(),
      child: const SupervisorRequestsScreen(),
    ),
    const AppSettingsScreen(),
  ];
}
