import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../organism/admin_custom_drawer.dart';
import 'admin_home_screen_body.dart';
import 'mangement_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int selectedIndex = 0;
  PageController controller = PageController();
  static GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<String> texts = [
      'Home'.tr(),
      'Management'.tr(),
    ];
    return Scaffold(
        endDrawer: const Drawer(
          child: AdminCustomDrawer(),
        ),
        key: scaffoldkey,
        appBar: AppBar(
            elevation: 0,
            actions: const [],
            title: Text(
              texts[selectedIndex],
              style: AppStylesManger.font18BoldBlack,
            ),
            centerTitle: true,
            leading: BlocProvider(
              create: (context) =>
                  getIt<EmployeeCubit>()..getAddAccountRequests(),
              child: BlocBuilder<EmployeeCubit, EmployeeState>(
                buildWhen: (previous, current) =>
                    current is GetAddAccountRequestsSuccess ||
                    current is GetAddAccountRequestsFailure ||
                    current is GetAddAccountRequestsLoading,
                builder: (context, state) => IconButton(
                    onPressed: () {
                      context
                          .pushName(Routes.adminNotificationScreen)
                          .then((_) {
                        BlocProvider.of<EmployeeCubit>(context)
                            .getAddAccountRequests();
                      });
                    },
                    icon: Badge(
                      
                      backgroundColor: ColorsManger.primaryColor,
                      label: state is GetAddAccountRequestsSuccess &&
                              state.value.data!.isNotEmpty
                          ? Text(state.value.data!.length.toString())
                          : null,
                      child: Icon(
                        Icons.notifications,
                        size: 30,
                        shadows: [BoxShadow(color: ColorsManger.primaryColor)],
                        color: Colors.black,
                      ),
                    )),
              ),
            ),
            backgroundColor: Colors.white),
        bottomNavigationBar: SlidingClippedNavBar(
          backgroundColor: Colors.white,
          onButtonPressed: (index) {
            setState(() {
              selectedIndex = index;
            });
            controller.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
          iconSize: 30,
          activeColor: ColorsManger.primaryColor,
          selectedIndex: selectedIndex,
          barItems: [
            BarItem(
              icon: Icons.home,
              title: 'Home'.tr(),
            ),
            BarItem(
              icon: Icons.settings,
              title: 'Management'.tr(),
            ),
          ],
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
    const AdminHomeScreenBody(),
    const ManagementScreen()
  ];
}
