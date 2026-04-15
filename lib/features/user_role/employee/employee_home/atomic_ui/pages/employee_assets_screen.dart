import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/custom_new_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_new_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/employee_assets_screen_body.dart';
import 'package:flutter/material.dart';

class EmployeeAssetsScreen extends StatelessWidget {
  const EmployeeAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomNewFloatingActionButton(
        onPressed: () {
          context.pushName(Routes.attachReceiptScreen);
        },
      ),
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: customNewAppBar(
        title: "Assets".tr(context: context),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: ColorsManger.primaryColorLight,
              size: 30,
            ),
          ),
        ],
      ),
      body: EmployeeAssetsScreenBody(),
    );
  }
}
