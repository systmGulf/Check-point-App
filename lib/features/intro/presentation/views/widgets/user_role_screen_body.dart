import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/animations/animations.dart';
import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/build_custom_app_bar.dart';
import 'role_option.dart';

class UserRoleScreenBody extends StatelessWidget {
  const UserRoleScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCustomAppBar(context, ""),
              verticalSpace(MediaQuery.sizeOf(context).height * 0.05),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.3,
                child: const Image(
                    image: AssetImage(Assets.assetsImagesNetworking)),
              ),
              verticalSpace(40),
              AnimatedListItemWidget(
                index: 0,
                child: RoleOption(
                  roleDescription: 'Continue_as_Employee_to_start_work'.tr(),
                  onTap: () {
                    context.pushName(Routes.employeeLoginScreen);
                  },
                  roleOptionText: 'Employee'.tr(),
                  roleImage: Assets.assetsImagesEmployeeImage,
                ),
              ),
              verticalSpace(10),
              AnimatedListItemWidget(
                index: 1,
                child: RoleOption(
                  roleDescription: 'Lead_Employees_and_Assign_Tasks'.tr(),
                  onTap: () {
                    context.pushName(Routes.supervisorLoginScreen);
                  },
                  roleOptionText: 'Supervisor'.tr(),
                  roleImage: Assets.assetsImagesManger,
                ),
              ),
              verticalSpace(10),
              AnimatedListItemWidget(
                index: 2,
                child: RoleOption(
                  roleDescription: 'Manage_App_Users_and_Permissions'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.adminLoginScreen);
                  },
                  roleOptionText: 'Admin'.tr(),
                  roleImage: Assets.assetsImagesAdmin,
                ),
              ),
              verticalSpace(40),
              Align(
                alignment: Alignment.center,
                child: AnimatedImageWidget(
                  imagePath: Assets.assetsImagesVodaphone,
                  width: 60.r,
                  height: 60.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
