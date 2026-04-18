import 'package:employee_mangement/core/dependencyـinjection/registerـfactory.dart';
import 'package:employee_mangement/core/style/app_colors.dart';
import 'package:employee_mangement/features/home/presentation/widgets/home_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/custom_floating_action_button_widget.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/employee_more_option_drawer.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/organism/employee_custom_drawer.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.scaffoldBackground,
      floatingActionButton: const CustomFloatingActionButtonWidget(),
      endDrawer: const Drawer(child: EmployeeCustomDrawer()),
      drawer: Drawer(
        child: BlocProvider(
          create: (context) =>
              LeaveApplicationCubit(getIt<EmployeeActionRepo>())
                ..getLeaveTypes(),
          child: const EmployeeMoreOptionDrawer(),
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: const Icon(Icons.menu, color: AppColors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
            icon: const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 20,
              child: Icon(Icons.person, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: const HomeBody(),
    );
  }
}
