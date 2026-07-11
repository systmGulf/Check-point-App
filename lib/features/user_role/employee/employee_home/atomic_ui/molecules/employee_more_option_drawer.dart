import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/utils/assets_manager.dart';
import '../../../../../../core/styles/colors.dart';
import '../organism/employee_more_option_list_view.dart';

class EmployeeMoreOptionDrawer extends StatelessWidget {
  const EmployeeMoreOptionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Column(
            children: [
              verticalSpace(40),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManger.primaryColor.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  Assets.AppLogoImage,
                  fit: BoxFit.contain,
                ),
              ),
              verticalSpace(20),
              const MoreOptionDrawerListView(),
            ],
          )),
        ],
      ),
    );
  }
}
