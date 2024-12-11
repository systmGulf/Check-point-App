import 'package:easy_localization/easy_localization.dart';
import 'supervisor_tasks_screen.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../employee/employee_home/atomic_ui/organism/employee_custom_drawer.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../molecules/supervisor_set_plan_screen_body.dart';
import 'attandace_screen.dart';
import 'supervisor_attendance_screen.dart';
import 'supervisor_requests_screen.dart';

class SupervisorHomeScreen extends StatefulWidget {
  const SupervisorHomeScreen({super.key});
  static GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  State<SupervisorHomeScreen> createState() => _SupervisorHomeScreenState();
}

class _SupervisorHomeScreenState extends State<SupervisorHomeScreen> {
  int selectedIndex = 0;
  PageController controller = PageController();

  static GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<String> texts = [
      'Attendance'.tr(context: context),
      'Employees Attendance'.tr(context: context),
      'Tasks'.tr(context: context),
      'Requests'.tr(context: context),
      'Plans'.tr(context: context),
    ];
    return Scaffold(
        key: scaffoldkey,
        endDrawer: const Drawer(
          child: EmployeeCustomDrawer(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    scaffoldkey.currentState?.openEndDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 30.h,
                  ),
                )),
          ],
          centerTitle: true,
          leadingWidth: 80.w,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: GestureDetector(
              onTap: () {
                context.pushName(Routes.supervisorNotificationsScreen);
              },
              child: const Icon(
                Icons.notifications,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          title: Text(texts[selectedIndex],
              style: AppStylesManger.font18BoldBlack),
        ),
        bottomNavigationBar: IntrinsicHeight(
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              controller.jumpToPage(
                selectedIndex,
              );
            },
            iconSize: 30.h,
            selectedItemColor: ColorsManger.primaryColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_filled),
                label: 'Home'.tr(context: context),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.attribution_outlined),
                label: 'Attendance'.tr(context: context),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.task_alt),
                label: 'Tasks'.tr(context: context),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.event_note_outlined),
                label: 'Requests'.tr(context: context),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.analytics),
                label: 'Plans'.tr(context: context),
              ),
            ],
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
        ));
  }

  List<Widget> screens = [
    const SupervisorAttendanceScreen(),
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
    BlocProvider(
      create: (context) => getIt<PlanCubit>()..getPlan(),
      child: const SetPlanScreen(),
    ),
  ];
}
