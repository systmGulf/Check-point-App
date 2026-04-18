import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/style/app_colors.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_attendance_type_switcher.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_background.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_check_in_out_section.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_header.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_history_header.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_history_section.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_tasks_section.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/get_employee_history/get_employee_history_cubit.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/tasks/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  int selectedIndex = 0;

  Future<void> _onRefresh() async {
    context.read<GetEmployeeHistoryCubit>().getEmployeeHistory();
    context.read<EmployeeTasksCubit>().getMyTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HomeBackground(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _onRefresh,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                verticalSpace(15),
                const HomeHeader(),
                HomeAttendanceTypeSwitcher(
                  selectedIndex: selectedIndex,
                  onSelect: (index) => setState(() => selectedIndex = index),
                ),
                verticalSpace(20),
                HomeCheckInOutSection(selectedIndex: selectedIndex),
                verticalSpace(30),
                const HomeTasksSection(),
                verticalSpace(30),
                const HomeHistoryHeader(),
                verticalSpace(10),
                const HomeHistorySection(),
                verticalSpace(10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
