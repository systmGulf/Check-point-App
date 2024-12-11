import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/user_name_and_time_and_check_in_and_out.dart';
import '../../../../employee/employee_home/atomic_ui/molecules/employee_home_section_item.dart';
import '../../../../employee/employee_home/atomic_ui/molecules/office_checking_in.dart';

class SupervisorAttendanceScreen extends StatefulWidget {
  const SupervisorAttendanceScreen({super.key});

  @override
  State<SupervisorAttendanceScreen> createState() =>
      _SupervisorAttendanceScreenState();
}

class _SupervisorAttendanceScreenState
    extends State<SupervisorAttendanceScreen> {
  int selectedIndex = 0;

  List<Widget> checkingSites = [
    const CheckInOrCheckOutWidget(
      attendType: 'Office',
    ),
    const CheckInOrCheckOutWidget(
      attendType: 'Customer',
    ),
    const CheckInOrCheckOutWidget(
      attendType: 'Site',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    List<String> checkingText = [
      'Office'.tr(context: context),
      'Customer'.tr(context: context),
      'Site'.tr(context: context)
    ];
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner-home.png',
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              verticalSpace(15),
              BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      current is GetEmployeeLoading ||
                      current is GetEmployeeSuccess ||
                      current is GetEmployeeFailure,
                  builder: (context, state) {
                    print(state);
                    if (state is GetEmployeeSuccess) {
                      return UserNameAndTimeAndCheckInAndOutItem(
                        name: "${state.employeeLoginModel.name}",
                      );
                    } else if (state is GetEmployeeFailure) {
                      return Text(state.error);
                    } else {
                      return  Center(child: CircularProgressIndicator(),);
                    }
                  }),
              verticalSpace(20),
              Directionality(
                textDirection: TextDirection.ltr,
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
                  containerWight: 350.w,
                  children: List.generate(3, (index) {
                    return Text(
                      checkingText[index],
                      style: AppStylesManger.font18BoldBlack,
                    );
                  }),
                ),
              ),
              verticalSpace(15),
              checkingSites[selectedIndex],
              verticalSpace(30),
              EmployeeHomeSectionItem(
                title: 'Alart'.tr(context: context),
                content:
                    'No Alert available for today. Please check back again tomorrow.'
                        .tr(context: context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
