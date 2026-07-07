import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hr_management_system_package/core/core.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_change_language_bottom_sheet.dart';
import '../../../../../../core/widgets/user_image_and_picking_image_button.dart';
import '../../../../employee/employee_home/atomic_ui/organism/pick_image_bloc_listener.dart';

class AdminCustomDrawer extends StatelessWidget {
  const AdminCustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<AdminDrawerItem> drawerItems = [
      AdminDrawerItem(
          onTap: () {
            context.pushName(Routes.termsAndConditionsScreen);
          },
          icon: Icons.warning_rounded,
          trailingIcon: Icons.arrow_forward_ios,
          title: 'Terms & Conditions'.tr(context: context)),
      AdminDrawerItem(
          icon: Icons.notifications,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () {
            context.pushName(Routes.notifyUsersScreen);
          },
          title: 'Notifications'.tr(context: context)),
      AdminDrawerItem(
          icon: Icons.person_add_alt,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () {
            context.pushName(Routes.allUsersScreen);
          },
          title: 'Add User'.tr(context: context)),
      AdminDrawerItem(
          icon: Icons.language,
          trailingIcon: Icons.arrow_forward_ios,
          title: 'Change Language'.tr(context: context),
          onTap: () {
            buildChangeLanguageBottomSheet(context);
          }),
      AdminDrawerItem(
          onTap: () async {
            FlutterBackgroundService().invoke('stop');
            await SecureCache.deleteFromCache();
            ApiConstant.token = await SecureCache.getFromCache(key: 'token');
            if (!context.mounted) return;
            context.pushReplacementName(Routes.userRoleScreen);
          },
          icon: Icons.logout,
          color: Colors.red,
          trailingIcon: Icons.arrow_forward_ios,
          title: 'Logout'.tr(context: context)),
    ];
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            verticalSpace(15),
            UserImageAndPickingImageButton(),
            verticalSpace(15),
            Text(
              ApiConstant.username,
              style: AppStylesManger.font14RegularBlack
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            verticalSpace(15),
            Expanded(
              child: ListView(children: drawerItems),
            ),
            PickImageBlocListener(),
          ],
        ),
      ),
    );
  }
}

class AdminDrawerItem extends StatelessWidget {
  const AdminDrawerItem(
      {super.key,
      required this.icon,
      required this.trailingIcon,
      required this.title,
      this.onTap,
      this.color});
  final IconData icon, trailingIcon;
  final String title;
  final Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          dense: true,
          minLeadingWidth: 0,
          leading: Icon(icon, color: color ?? Colors.grey, size: 23),
          title: Text(title,
              style: AppStylesManger.font14RegularBlack.copyWith(
                  color: color ?? const Color.fromARGB(255, 93, 93, 93),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5)),
          trailing: Icon(trailingIcon, color: color ?? Colors.grey, size: 15),
        ),
      ),
    );
  }
}
