import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/animations/animations.dart';
import 'role_option.dart';

class UserRoleScreenBody extends StatelessWidget {
  const UserRoleScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8EFFE), Color(0xFFD6E3FB), Colors.white],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Network illustration ─────────────────────────────────────
            Expanded(
              flex: 4,
              child: Center(
                child: AnimatedImageWidget(
                  imagePath: Assets.NetworkingImage,
                  width: 200.w,
                  height: 200.w,
                ),
              ),
            ),

            // ── Role cards ───────────────────────────────────────────────
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    AnimatedListItemWidget(
                      index: 0,
                      child: RoleOption(
                        isActive: true,
                        roleTag: 'Employee Portal'.tr(),
                        roleOptionText: 'Employee'.tr(),
                        roleDescription: 'Continue_as_Employee_to_start_work'.tr(),
                        roleImage: Assets.EmployeeImage,
                        onTap: () => context.pushName(Routes.employeeLoginScreen),
                      ),
                    ),
                    verticalSpace(12),
                    AnimatedListItemWidget(
                      index: 1,
                      child: RoleOption(
                        roleTag: 'Supervisor Console'.tr(),
                        roleOptionText: 'Supervisor'.tr(),
                        roleDescription: 'Lead_Employees_and_Assign_Tasks'.tr(),
                        roleImage: Assets.MangerImage,
                        onTap: () => context.pushName(Routes.supervisorLoginScreen),
                      ),
                    ),
                    verticalSpace(12),
                    AnimatedListItemWidget(
                      index: 2,
                      child: RoleOption(
                        roleTag: 'Admin Center'.tr(),
                        roleOptionText: 'Admin'.tr(),
                        roleDescription: 'Manage_App_Users_and_Permissions'.tr(),
                        roleImage: Assets.AdminImage,
                        onTap: () => Navigator.pushNamed(context, Routes.adminLoginScreen),
                      ),
                    ),
                    verticalSpace(28),
                  ],
                ),
              ),
            ),

            // ── Enlighten button ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManger.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  icon: const Text('⚡', style: TextStyle(fontSize: 20)),
                  label: Text(
                    'Enlighten',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
