import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/styles/colors.dart';
import '../../controller/leave_application/leave_application_cubit.dart';
import '../molecules/custom_floating_action_button_widget.dart';
import '../molecules/employee_more_option_drawer.dart';
import '../organism/employee_custom_drawer.dart';
import '../organism/employee_home_screen_body.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButtonWidget(),
      endDrawer: const Drawer(
        child: EmployeeCustomDrawer(),
      ),
      drawer: Drawer(
        child: BlocProvider(
          create: (context) => LeaveApplicationCubit(
            getIt<EmployeeActionRepo>(),
          ),
          child: const EmployeeMoreOptionDrawer(),
        ),
      ),
      key: scaffoldKey,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              icon: CircleAvatar(
                  backgroundColor: ColorsManger.primaryColor,
                  radius: 20,
                  child: const Icon(Icons.person, color: Colors.white))),
        ],
        leading: GestureDetector(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: const Icon(Icons.menu)),
        backgroundColor: Colors.white,
      ),
      body: const EmployeeHomeScreenBody(),
    );
  }
}
