import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import 'employee_drawer_item_list_view.dart';

class EmployeeCustomDrawer extends StatelessWidget {
  const EmployeeCustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),
                color: ColorsManger.primaryColor,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    verticalSpace(14),
                    GestureDetector(
                      onTap: () {
                        context.pushName(Routes.employeeUpdateProfile);
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: ColorsManger.primaryColor,
                        child: const Image(
                            image: AssetImage(
                          'assets/images/employee_image.png',
                        )),
                      ),
                    ),
                    verticalSpace(10),
                    Text(
                      '${"Hi".tr(
                        context: context,
                      )} ${ApiConstant.username}',
                      style: AppStylesManger.font21regulerWhite,
                    ),
                    Text(
                      ApiConstant.position,
                      style: AppStylesManger.font14regularWhite,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          )),
          const SliverToBoxAdapter(
              child: Column(
            children: [
              EmployeeDrawerListViewItems(),
            ],
          )),
          SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await SecureCache.deleteFromCache();
                      ApiConstant.token =
                          await SecureCache.getFromCache(key: 'token');
                      if (context.mounted) {
                        context.pushReplacementName(Routes.userRoleScreen);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 30,
                          ),
                          horizontalSpace(10),
                          Text(
                              'Logout'.tr(
                                context: context,
                              ),
                              style: AppStylesManger.font16BoldBlack),
                        ],
                      ),
                    ),
                  ),
                  verticalSpace(20),
                  Row(
                    children: [
                      const Spacer(),
                      Text('${"Version".tr(context: context)} 1.0.0'),
                      const Spacer(),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
