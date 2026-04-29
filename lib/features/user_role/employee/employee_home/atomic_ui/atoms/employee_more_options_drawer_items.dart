import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/dependencyـinjection/registerـfactory.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/pages/supervisor_announcement_screen.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/news_cubit/supervisor_news_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/pages/supervisor_profile_screen.dart';
import '../../../../supervisor/supervisor_home/contoller/payslip/cubit/payslip_cubit.dart';
import '../molecules/more_option_item.dart';
import 'option_drawer_item.dart';

List<Widget> employeeMoreOptionsDrawerItems(
  BuildContext context, {
  bool isSupervisor = false,
}) {
  return [
    if (isSupervisor) ...[
      _DrawerActionTile(
        title: 'Profile'.tr(context: context),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        getIt<PayslipCubit>()..getPayslipById(),
                  ),
                  BlocProvider(
                    create: (context) => getIt<SurveysCubit>(),
                  ),
                ],
                child: const SupervisorProfileScreen(),
              ),
            ),
          );
        },
      ),
      _DrawerActionTile(
        title: 'Announcements'.tr(context: context),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) =>
                    getIt<SupervisorNewsCubit>()..getAnnouncement(),
                child: const SupervisorAnnouncementScreen(),
              ),
            ),
          );
        },
      ),
    ],
    BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
      buildWhen: (previous, current) =>
          current is GetLeaveTypesFailure ||
          current is GetLeaveTypesSuccess ||
          current is GetLeaveTypesLoading,
      builder: (context, state) {
        if (state is GetLeaveTypesSuccess) {
          return MoreOptionDrawerItem(
              title: 'Leave Requests'.tr(
                context: context,
              ),
              children: List.generate(
                  state.leaveTypeResponse.value!.length,
                  (index) => OptionDrawerItem(
                      title: state.leaveTypeResponse.value![index].type!,
                      onPressed: () {
                        context.pushName(
                          Routes.requestClaimApplicationScreen,
                          arguments: {
                            'leaveTypeId':
                                state.leaveTypeResponse.value![index].id,
                            'leaveTypeName':
                                state.leaveTypeResponse.value![index].type,
                          },
                        );
                      })));
        } else if (state is GetLeaveTypesFailure) {
          return Text(state.error);
        } else if (state is GetLeaveTypesLoading) {
          return Skeletonizer(
              child: MoreOptionDrawerItem(
            title: 'Leave Requests'.tr(
              context: context,
            ),
            children: [],
          ));
        } else {
          return Container();
        }
      },
    ),
    MoreOptionDrawerItem(
      title: 'Assets'.tr(context: context),
      children: [
        OptionDrawerItem(
          title: 'Loan'.tr(context: context),
          onPressed: () {
            context.pushName(
              Routes.employeeAssetsManagerScreen,
              arguments: {'assetType': 'loan'},
            );
          },
        ),
        OptionDrawerItem(
          title: 'Allowance'.tr(context: context),
          onPressed: () {
            context.pushName(
              Routes.employeeAssetsManagerScreen,
              arguments: {'assetType': 'allowance'},
            );
          },
        ),
        OptionDrawerItem(
          title: 'Assets'.tr(context: context),
          onPressed: () {
            context.pushName(
              Routes.employeeAssetsManagerScreen,
              arguments: {'assetType': 'assets'},
            );
          },
        ),
      ],
    ),
    _DrawerActionTile(
      title: 'Add New Customer'.tr(
        context: context,
      ),
      onTap: () {
        context.pushName(Routes.employeeAddNewCustomerScreen);
      },
    ),
    // _DrawerActionTile(
    //   title: 'My Plans'.tr(
    //     context: context,
    //   ),
    //   onTap: () {
    //     context.pushName(Routes.myPlansScreen);
    //   },
    // ),
    _DrawerActionTile(
      title: 'My Tasks'.tr(
        context: context,
      ),
      onTap: () {
        context.pushName(Routes.myTasksScreen);
      },
    ),
    _DrawerActionTile(
      title: 'Complaints'.tr(
        context: context,
      ),
      onTap: () {
        context.pushName(Routes.complaintsScreen);
      },
    ),
    // Padding(
    //   padding: EdgeInsetsDirectional.only(start: 19.w),
    //   child: Text(
    //     'Assesments'.tr(
    //       context: context,
    //     ),
    //     style: AppStylesManger.font18RegulerBlack,
    //   ),
    // ),
    _DrawerActionTile(
      title: 'Assessments'.tr(
        context: context,
      ),
      onTap: () {
        context.pushName(Routes.assesmentsScreen);
      },
    ),
    _DrawerActionTile(
      title: 'Feedback'.tr(
        context: context,
      ),
      onTap: () {
        context.pushName(Routes.feedback);
      },
    ),
  ];
}

class _DrawerActionTile extends StatelessWidget {
  const _DrawerActionTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColorsManger.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppStylesManger.font16BoldBlack,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: ColorsManger.grey9c,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
