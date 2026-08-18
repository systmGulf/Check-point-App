import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/app_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
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
      'Settings'.tr(),
    ];
    return Scaffold(
      key: scaffoldkey,
      appBar: selectedIndex == 2
          ? null // AppSettingsScreen has its own custom curved header
          : AppBar(
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
                      child: const Icon(
                        Icons.notifications,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
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
            padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
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
                    iconData = isSelected ? Icons.tune_rounded : Icons.tune_outlined;
                    break;
                  case 2:
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: isSelected ? ColorsManger.primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Icon(
                          iconData,
                          color: isSelected ? ColorsManger.primaryColor : const Color(0xFF9CA3AF),
                          size: 24.sp,
                        ),
                        SizedBox(height: 4.h),
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
    const AdminHomeScreenBody(),
    const ManagementScreen(),
    const AppSettingsScreen(),
  ];
}
