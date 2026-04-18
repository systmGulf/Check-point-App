import 'package:easy_localization/easy_localization.dart' as el;
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../../../../../core/widgets/user_name_and_time_and_check_in_and_out.dart';
import '../../../../employee/employee_home/atomic_ui/molecules/office_checking_in.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../molecules/task_section_widget.dart';

class SupervisorHomeScreenBody extends StatefulWidget {
  const SupervisorHomeScreenBody({super.key});

  @override
  State<SupervisorHomeScreenBody> createState() =>
      _SupervisorHomeScreenBodyState();
}

class _SupervisorHomeScreenBodyState extends State<SupervisorHomeScreenBody> {
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
          Assets.assetsImagesBannerHome,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              verticalSpace(15),
              UserNameAndTimeAndCheckInAndOutItem(
                image: '',
                name: "${ApiConstant.username}",
              ),
              // BlocBuilder<LoginCubit, LoginState>(
              //     buildWhen: (previous, current) =>
              //         current is GetEmployeeLoading ||
              //         current is GetEmployeeSuccess ||
              //         current is GetEmployeeFailure,
              //     builder: (context, state) {
              //       print(state);
              //       if (state is GetEmployeeSuccess) {

              //       } else if (state is GetEmployeeFailure) {
              //         return Text(state.error);
              //       } else {
              //         return Skeletonizer(
              //             child: const UserNameAndTimeAndCheckInAndOutItem(
              //           image: '',
              //           name: "Data Loading",
              //         ));
              //       }
              //     }),
              // verticalSpace(20),
              // FadeInLeft(
              //   delay: const Duration(milliseconds: 300),
              //   child: Directionality(
              //     textDirection: TextDirection.ltr,
              //     child: SlideSwitcher(
              //       initialIndex: selectedIndex,
              //       onSelect: (index) {
              //         setState(() {
              //           selectedIndex = index;
              //         });
              //       },
              //       containerColor: ColorsManger.primaryColor,
              //       slidersBorder: Border.all(color: ColorsManger.primaryColor),
              //       containerHeight: 40.h,
              //       containerWight: 350.w,
              //       children: List.generate(3, (index) {
              //         return AnimatedTextWidget(
              //           text: checkingText[index],
              //           style: AppStylesManger.font18BoldBlack.copyWith(
              //             color: selectedIndex == index
              //                 ? ColorsManger.primaryColor
              //                 : Colors.white,
              //           ),
              //           textAlign: TextAlign.center,
              //         );
              //       }),
              //     ),
              //   ),
              // ),
              verticalSpace(15),
              checkingSites[selectedIndex],
              verticalSpace(5),
              BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
                buildWhen: (previous, current) =>
                    current is GetMyTasksError ||
                    current is GetMyTasksSuccess ||
                    current is GetMyTasksLoading,
                builder: (context, state) {
                  if (state is GetMyTasksError) {
                    return state.error ==
                            'Please check your internet connection'
                        ? NoInternetConnectionWidget(onPressed: () {
                            context.read<EmployeeTasksCubit>().getMyTasks();
                          })
                        : Column(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              verticalSpace(20),
                              Text(state.error)
                            ],
                          );
                  }
                  if (state is GetMyTasksSuccess) {
                    return TasksSection(
                        taskCount: state.getTaskResponse.length,
                        onTap: () {
                          // Navigate to tasks page
                          context.pushName(Routes.myTasksScreen);
                        });
                  }
                  return Skeletonizer(
                      child: TasksSection(
                    taskCount: 1,
                    onTap: () {
                      // Navigate to tasks page
                    },
                  ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
