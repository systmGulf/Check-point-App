import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/dependencyـinjection/registerـfactory.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/news_cubit/supervisor_news_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/pages/supervisor_announcement_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../molecules/more_option_item.dart';
import 'option_drawer_item.dart';

List<Widget> employeeMoreOptionsDrawerItems(
  BuildContext context, {
  bool isSupervisor = false,
}) {
  return [
    if (isSupervisor) ...[
      GestureDetector(
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
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 19.w),
          child: Text(
            'Announcements'.tr(context: context),
            style: AppStylesManger.font18RegulerBlack,
          ),
        ),
      ),
      verticalSpace(10),
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
    verticalSpace(10),
    GestureDetector(
      onTap: () {
        context.pushName(Routes.employeeAssetsManagerScreen);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 19.w),
        child: Text(
          'Assets'.tr(
            context: context,
          ),
          style: AppStylesManger.font18RegulerBlack,
        ),
      ),
    ),
    verticalSpace(10),
    GestureDetector(
      onTap: () {
        context.pushName(Routes.employeeAddNewCustomerScreen);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 19.w),
        child: Text(
          'Add New Customer'.tr(
            context: context,
          ),
          style: AppStylesManger.font18RegulerBlack,
        ),
      ),
    ),
    verticalSpace(22),
    GestureDetector(
      onTap: () {
        context.pushName(Routes.myPlansScreen);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 19.w),
        child: Text(
          'My Plans'.tr(
            context: context,
          ),
          style: AppStylesManger.font18RegulerBlack,
        ),
      ),
    ),
    verticalSpace(20),
    InkWell(
      onTap: () {
        context.pushName(Routes.myTasksScreen);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 19.w),
        child: Text(
          'My Tasks'.tr(
            context: context,
          ),
          style: AppStylesManger.font18RegulerBlack,
        ),
      ),
    ),
  ];
}
