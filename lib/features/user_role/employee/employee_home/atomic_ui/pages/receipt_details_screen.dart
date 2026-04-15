import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/custom_new_app_bar.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/receipt_details_view_body.dart';
import 'package:flutter/material.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  const ReceiptDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: customNewAppBar(title: "Receipt Details".tr(context: context)),
      body: const ReceiptDetailsViewBody(),
    );
  }
}
