import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../molecules/more_option_item.dart';
import 'option_drawer_item.dart';

List<Widget> employeeMoreOptionsDrawerItems(BuildContext context) {
  return [
    MoreOptionDrawerItem(
      title: 'Request Claim'.tr(
        context: context,
      ),
      children: [
        OptionDrawerItem(
          title: 'Application'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.requestClaimApplicationScreen);
          },
        ),
        verticalSpace(10),
      ],
    ),
    MoreOptionDrawerItem(
      title: 'Leave'.tr(
        context: context,
      ),
      children: [
        OptionDrawerItem(
          title: 'Application'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.leaveApplicationScreen);
          },
        ),
        verticalSpace(10),
        OptionDrawerItem(
          title: 'Planner'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.leavePlanner);
          },
        ),
        verticalSpace(10),
        OptionDrawerItem(
          title: 'Schedule'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.leaveSchedule);
          },
        ),
        verticalSpace(10),
      ],
    ),
    MoreOptionDrawerItem(
      title: 'accident'.tr(
        context: context,
      ),
      children: [
        verticalSpace(10),
        OptionDrawerItem(
          title: 'MySelf'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.incidentMyself);
          },
        ),
        verticalSpace(10),
        OptionDrawerItem(
          title: 'Team'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.incidentTeam);
          },
        ),
      ],
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
