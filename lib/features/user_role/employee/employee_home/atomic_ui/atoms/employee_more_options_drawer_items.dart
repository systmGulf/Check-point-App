import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../molecules/more_option_item.dart';
import 'option_drawer_item.dart';
import '../../../../../../core/improvements/theme_picker_dialog.dart';

List<Widget> employeeMoreOptionsDrawerItems(BuildContext context) {
  return [
    MoreOptionDrawerItem(
      title: 'Leaves'.tr(
        context: context,
      ),
      children: [
        OptionDrawerItem(
          title: 'Request Leave'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.leaveApplicationScreen, arguments: 0);
          },
        ),
        verticalSpace(10),
        OptionDrawerItem(
          title: 'Public Holidays'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.leaveApplicationScreen, arguments: 1);
          },
        ),
        verticalSpace(10),
        OptionDrawerItem(
          title: 'My Leaves'.tr(
            context: context,
          ),
          onPressed: () {
            context.pushName(Routes.leaveApplicationScreen, arguments: 2);
          },
        ),
        verticalSpace(10),
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
    verticalSpace(20),
    InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogCtx) => const ThemePickerDialog(),
        );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 19.w),
        child: Text(
          'Change Theme Color'.tr(
            context: context,
          ),
          style: AppStylesManger.font18RegulerBlack,
        ),
      ),
    ),
  ];
}
