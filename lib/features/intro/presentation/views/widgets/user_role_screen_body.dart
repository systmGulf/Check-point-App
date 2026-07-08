import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/animations/animations.dart';
import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/routing/routes.dart';
import 'role_option.dart';

class UserRoleScreenBody extends StatefulWidget {
  const UserRoleScreenBody({super.key});

  @override
  State<UserRoleScreenBody> createState() => _UserRoleScreenBodyState();
}

class _UserRoleScreenBodyState extends State<UserRoleScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpace(24),
            Align(
              alignment: AlignmentDirectional.center,
              child: AnimatedImageWidget(
                imagePath: Assets.NetworkingImage,
                width: 180.w,
                height: 180.w,
              ),
            ),
            verticalSpace(24),
            AnimatedListItemWidget(
              index: 0,
              child: RoleOption(
                roleDescription: 'Continue_as_Employee_to_start_work'.tr(),
                roleTag: 'Employee Portal'.tr(),
                onTap: () {
                  context.pushName(Routes.employeeLoginScreen);
                },
                roleOptionText: 'Employee'.tr(),
                roleImage: Assets.EmployeeImage,
              ),
            ),
            verticalSpace(12),
            AnimatedListItemWidget(
              index: 1,
              child: RoleOption(
                roleDescription: 'Lead_Employees_and_Assign_Tasks'.tr(),
                roleTag: 'Supervisor Console'.tr(),
                onTap: () {
                  context.pushName(Routes.supervisorLoginScreen);
                },
                roleOptionText: 'Supervisor'.tr(),
                roleImage: Assets.MangerImage,
              ),
            ),
            verticalSpace(12),
            AnimatedListItemWidget(
              index: 2,
              child: RoleOption(
                roleDescription: 'Manage_App_Users_and_Permissions'.tr(),
                roleTag: 'Admin Center'.tr(),
                onTap: () {
                  Navigator.pushNamed(context, Routes.adminLoginScreen);
                },
                roleOptionText: 'Admin'.tr(),
                roleImage: Assets.AdminImage,
              ),
            ),
            verticalSpace(28),
            Align(
              alignment: Alignment.center,
              child: AnimatedImageWidget(
                imagePath: Assets.AppLogoImage,
                width: 58.r,
                height: 58.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
