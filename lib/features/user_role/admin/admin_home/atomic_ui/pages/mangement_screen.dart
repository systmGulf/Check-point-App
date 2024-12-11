import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../atoms/admin_permission_screen_item.dart';
import '../molecules/pemission_grid_view.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<AdminManagementScreenItems> categoryItems = [
      AdminManagementScreenItems(
          onTap: () {
            context.pushName(Routes.sitesScreen);
          },
          color: Colors.green,
          text: 'Sites'.tr(context: context),
          icon: Icons.location_on_outlined),
      AdminManagementScreenItems(
        color: ColorsManger.primaryColor,
        onTap: () {
          context.pushName(Routes.clientsScreen);
        },
        text: 'Clients'.tr(context: context),
        icon: Icons.group,
      ),
      AdminManagementScreenItems(
        color: Colors.blueGrey,
        onTap: () {
          context.pushName(Routes.notifyUsersScreen);
        },
        text: 'Notifications'.tr(context: context),
        icon: Icons.notifications_outlined,
      ),
    ];
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner-home.png',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              verticalSpace(20),
              const ManagementScreenGridView(),
              verticalSpace(30),
              Expanded(
                child: ListView.builder(
                    itemCount: categoryItems.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return categoryItems[index];
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
