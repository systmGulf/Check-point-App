import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/animations/animations.dart';
import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/styles.dart';
import 'role_option.dart';

class UserRoleScreenBody extends StatelessWidget {
  const UserRoleScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(22.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    ColorsManger.primaryColor,
                    ColorsManger.primaryColorLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      'Choose your role'.tr(),
                      style: AppStylesManger.font12RegularBlack.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  verticalSpace(18),
                  Text(
                    'Select how you want to continue in Check Point.'.tr(),
                    style:
                        AppStylesManger.font26BoldWhite.copyWith(height: 1.2),
                  ),
                  verticalSpace(10),
                  Text(
                    'Continue'.tr(),
                    style: AppStylesManger.font14RegularWhite.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  verticalSpace(18),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: AnimatedImageWidget(
                      imagePath: Assets.NetworkingImage,
                      width: 118.w,
                      height: 118.w,
                    ),
                  ),
                ],
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
                imagePath: Assets.VodafoneImage,
                width: 52.r,
                height: 52.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
