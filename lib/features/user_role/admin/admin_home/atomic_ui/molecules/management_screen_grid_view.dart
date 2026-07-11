import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../atoms/management_screen_grid_view_item.dart';

class ManagementScreenGridView extends StatelessWidget {
  const ManagementScreenGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      BounceInLeft(
        child: ManagementScreenGridViewItem(
          image: 'assets/images/corporate.png',
          onTap: () {
            context.pushName(Routes.supervisorPermission);
          },
          text: 'Departments'.tr(context: context),
          color1: ColorsManger.primaryColor,
          color2: Colors.white,
        ),
      ),

      BounceInLeft(
        child: ManagementScreenGridViewItem(
          onTap: () {
            context.pushName(Routes.companyBranchesScreen);
          },
          image: 'assets/images/corporate-culture.png',
          text: 'Company branches'.tr(context: context),
          color1: const Color.fromARGB(255, 79, 194, 83),
          color2: Colors.white,
        ),
      ),
      BounceInLeft(
        child: ManagementScreenGridViewItem(
          onTap: () {
            context.pushName(Routes.shiftsScreen);
          },
          image: 'assets/images/people.png',
          text: 'Shifts & Policies'.tr(context: context),
          color1: const Color.fromARGB(255, 207, 171, 168),
          color2: Colors.white,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 100,
          crossAxisCount: 2),
      itemBuilder: (context, index) {
        return items[index];
      },
      itemCount: 3,
    );
  }
}
