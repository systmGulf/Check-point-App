import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../atoms/premission_item.dart';

class ManagementScreenGridView extends StatelessWidget {
  const ManagementScreenGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      ManagementScreenGridViewItem(
        image: 'assets/images/corporate.png',
        onTap: () {
          context.pushName(Routes.supervisorPermission);
        },
        text: 'Departments'.tr(context: context),
        color1: ColorsManger.primaryColor,
        color2: Colors.white,
      ),
      ManagementScreenGridViewItem(
        onTap: () {
          context.pushName(Routes.holidaysScreen);
        },
        image: 'assets/images/calendar-date.png',
        text: 'Holidays'.tr(context: context),
        color1: const Color.fromARGB(255, 96, 161, 214),
        color2: Colors.white,
      ),
      ManagementScreenGridViewItem(
        onTap: () {
          context.pushName(Routes.companyBranchesScreen);
        },
        image: 'assets/images/corporate-culture.png',
        text: 'Company branches'.tr(context: context),
        color1: const Color.fromARGB(255, 79, 194, 83),
        color2: Colors.white,
      ),
      ManagementScreenGridViewItem(
        onTap: () {
          context.pushName(Routes.eventsScreen);
        },
        image: 'assets/images/people.png',
        text: 'Events'.tr(context: context),
        color1: const Color.fromARGB(255, 207, 171, 168),
        color2: Colors.white,
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
      itemCount: 4,
    );
  }
}
