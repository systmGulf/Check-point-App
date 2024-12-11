import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/routing/routes.dart';
import 'role_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserRoleScreenBody extends StatelessWidget {
  const UserRoleScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpace(MediaQuery.sizeOf(context).height * 0.1),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.3,
                child: const Image(
                    image: AssetImage('assets/images/networking.png')),
              ),
              verticalSpace(40),
              FadeInLeft(
                child: RoleOption(
                  roleDescription: 'Continue_as_Employee_to_start_work'.tr(),
                  onTap: () {
                    context.pushName(Routes.employeeLoginScreen);
                  },
                  roleOptionText: 'Employee'.tr(),
                  roleImage: 'assets/images/employee.png',
                ),
              ),
              verticalSpace(10),
              FadeInRight(
                child: RoleOption(
                  roleDescription: 'Lead_Employees_and_Assign_Tasks'.tr(),
                  onTap: () {
                    context.pushName(Routes.supervisorLoginScreen);
                  },
                  roleOptionText: 'Supervisor'.tr(),
                  roleImage: 'assets/images/manger.png',
                ),
              ),
              verticalSpace(10),
              FadeInLeft(
                child: RoleOption(
                  roleDescription: 'Manage_App_Users_and_Permissions'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.adminLoginScreen);
                  },
                  roleOptionText: 'Admin'.tr(),
                  roleImage: 'assets/images/admin.png',
                ),
              ),
              verticalSpace(40),
              SizedBox(
                  height: 100.h,
                  child: const Image(
                      image: AssetImage('assets/images/app_logo.png')))
            ],
          ),
        ),
      ),
    );
  }
}
