import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/custom_employee_asset_grid_view_container.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/custom_employee_recent_history_list_view_container.dart';
import 'package:flutter/material.dart';

class EmployeeAssetsScreenBody extends StatelessWidget {
  const EmployeeAssetsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          CustomEmployeeAssetGridViewContainer(),
          verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent History".tr(context: context),
                style: AppStylesManger.font16BoldBlack,
              ),
              InkWell(
                onTap: () {
                  context.pushName(Routes.employeeAssetsAllRequestsScreen);
                },
                child: Text(
                  "see all".tr(context: context),
                  style: AppStylesManger.font14BoldBlack.copyWith(
                    color: ColorsManger.grey9c,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(16),
          CustomEmployeeRecentHistoryListViewContainer(),
          verticalSpace(30),
        ],
      ),
    );
  }
}
