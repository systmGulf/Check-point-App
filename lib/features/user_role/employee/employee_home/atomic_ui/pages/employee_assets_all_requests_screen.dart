import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_request_asset_form_body.dart';
import 'package:flutter/material.dart';

class EmployeeAssetsAllRequestsScreen extends StatelessWidget {
  const EmployeeAssetsAllRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: buildCustomAppBar(context, 'Request Asset'.tr(context: context)),
      body: const EmployeeRequestAssetFormBody(),
    );
  }
}
