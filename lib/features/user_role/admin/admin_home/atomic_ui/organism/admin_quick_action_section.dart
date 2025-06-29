import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import 'admin_quick_actions_item.dart';

class AdminQuickActionsSection extends StatelessWidget {
  const AdminQuickActionsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Quick Actions'.tr(context: context),
        style: AppStylesManger.font16BoldBlack,
      ),
      verticalSpace(10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0XFFFAFAFA),
        ),
        child: Column(
          children: [
            QuickActionsItem(
              icon: CupertinoIcons.person_add,
              text: 'Add New Employee'.tr(context: context),
              action: () {
                context.pushName(Routes.allUsersScreen);
              },
            ),
            verticalSpace(15),
            QuickActionsItem(
              icon: Icons.business_center_outlined,
              text: 'Add New Department'.tr(context: context),
              action: () {
                context.pushName(Routes.supervisorPermission);
              },
            ),
            verticalSpace(15),
            QuickActionsItem(
              icon: CupertinoIcons.building_2_fill,
              text: 'Add New Branch'.tr(context: context),
              action: () {
                context.pushName(Routes.companyBranchesScreen);
              },
            ),
            verticalSpace(15),
            QuickActionsItem(
              icon: CupertinoIcons.person_crop_square,
              text: 'Add New Customer'.tr(context: context),
              action: () {
                context.pushName(Routes.clientsScreen);
              },
            )
          ],
        ),
      )
    ]);
  }
}
