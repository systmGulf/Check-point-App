import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../atoms/admin_management_screen_item.dart';
import '../molecules/management_screen_grid_view.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> categoryItems = [
      SlideInLeft(
        from: 50,
        child: AdminManagementScreenItems(
            onTap: () {
              context.pushName(Routes.sitesScreen);
            },
            color: Colors.green,
            text: 'Sites'.tr(),
            icon: Icons.location_on_outlined),
      ),
      SlideInLeft(
        from: 100,
        child: AdminManagementScreenItems(
          color: ColorsManger.primaryColor,
          onTap: () {
            context.pushName(Routes.clientsScreen);
          },
          text: 'Clients'.tr(),
          icon: Icons.group,
        ),
      ),
      SlideInLeft(
        from: 150,
        child: AdminManagementScreenItems(
          color: ColorsManger.primaryColor,
          onTap: () {
            context.pushName(Routes.adminAttendanceScreen);
          },
          onAddTap: () {
            context.pushName(Routes.adminAttendSelectionScreen);
          },
          text: 'Employees Attendance'.tr(),
          icon: Icons.calendar_month_outlined,
        ),
      ),
      SlideInLeft(
        from: 200,
        child: AdminManagementScreenItems(
          color: Colors.orange,
          onTap: () {
            context.pushName(Routes.adminLeavesScreen);
          },
          text: 'Leaves'.tr(),
          icon: Icons.event_note,
        ),
      ),
    ];
    return Stack(
      children: [
        Image.asset(
          Assets.BannerHomeImage,
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
