import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/styles/colors.dart';
import 'admin_quick_actions_item.dart';

class AdminQuickActionsSection extends StatelessWidget {
  const AdminQuickActionsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AnimatedTextWidget(
        text: 'Quick Actions'.tr(context: context),
        style: AppStylesManger.font16BoldBlack,
        textAlign: TextAlign.start,
      ),
      verticalSpace(10),
      AnimatedContainerWidget(
        backgroundColor: ColorsManger.backgroundWhiteFaint,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            AnimatedListItemWidget(
              index: 0,
              child: QuickActionsItem(
                icon: CupertinoIcons.person_add,
                text: 'Add New Employee'.tr(context: context),
                action: () {
                  context.pushName(Routes.allUsersScreen);
                },
              ),
            ),
            verticalSpace(15),
            AnimatedListItemWidget(
              index: 1,
              child: QuickActionsItem(
                icon: Icons.business_center_outlined,
                text: 'Add New Department'.tr(context: context),
                action: () {
                  context.pushName(Routes.supervisorPermission);
                },
              ),
            ),
            verticalSpace(15),
            AnimatedListItemWidget(
              index: 2,
              child: QuickActionsItem(
                icon: CupertinoIcons.building_2_fill,
                text: 'Add New Branch'.tr(context: context),
                action: () {
                  context.pushName(Routes.companyBranchesScreen);
                },
              ),
            ),
            verticalSpace(15),
            AnimatedListItemWidget(
              index: 3,
              child: QuickActionsItem(
                icon: CupertinoIcons.person_crop_square,
                text: 'Add New Customer'.tr(context: context),
                action: () {
                  context.pushName(Routes.clientsScreen);
                },
              ),
            )
          ],
        ),
      )
    ]);
  }
}
