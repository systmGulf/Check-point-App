import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/get_employee_history/get_employee_history_cubit.dart';
import '../molecules/employee_home_section_item.dart';
import '../molecules/office_checking_in.dart';
import 'employee_attendace_bloc_builder.dart';
import 'get_employee_data_in_employee_home_screen_bloc_builder.dart';

class EmployeeHomeScreenBody extends StatefulWidget {
  const EmployeeHomeScreenBody({super.key});

  @override
  State<EmployeeHomeScreenBody> createState() => _EmployeeHomeScreenBodyState();
}

class _EmployeeHomeScreenBodyState extends State<EmployeeHomeScreenBody> {
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
      'Customer'.tr(
        context: context,
      ),
      'Site'.tr(
        context: context,
      )
    ];

    return Stack(
      children: [
        Image.asset(
          'assets/images/banner-home.png',
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RefreshIndicator(
            color: ColorsManger.primaryColor,
            onRefresh: () async {
              BlocProvider.of<GetEmployeeHistoryCubit>(context)
                  .getEmployeeHistory();
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                verticalSpace(15),
                const GetEmployeeDataInEmployeeHomeScreenBlocBuilder(),
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
                    containerWight: MediaQuery.sizeOf(context).width / 1.2,
                    children: List.generate(3, (index) {
                      return Text(
                        checkingText[index],
                        style: AppStylesManger.font18BoldBlack,
                      );
                    }),
                  ),
                ),
                verticalSpace(20),
                checkingSites[selectedIndex],
                verticalSpace(30),
                EmployeeHomeSectionItem(
                  title: 'Alart'.tr(
                    context: context,
                  ),
                  content:
                      'No Alert available for today. Please check back again tomorrow.'
                          .tr(
                    context: context,
                  ),
                ),
                verticalSpace(30),
                EmployeeHomeSectionItem(
                  title: 'Announcement'.tr(
                    context: context,
                  ),
                  content:
                      'No Announcement Yet. 3 Latest Announcements will be displayed here.'
                          .tr(
                    context: context,
                  ),
                ),
                verticalSpace(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'History'.tr(
                        context: context,
                      ),
                      style: AppStylesManger.font18RegulerBlack,
                    ),
                    GestureDetector(
                        onTap: () {
                          context
                              .pushName(Routes.employeeAttendanceHistoryScreen);
                        },
                        child: const Icon(Icons.arrow_forward_ios_outlined))
                  ],
                ),
                verticalSpace(10),
                const EmployeeAttendanceBlocBuilder(),
                verticalSpace(10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
