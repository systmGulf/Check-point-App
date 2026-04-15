import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/custom_new_app_bar.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/custom_attach_receipt_view_body.dart';
import 'package:flutter/material.dart';

class AttachReceiptScreen extends StatelessWidget {
  const AttachReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customNewAppBar(title: "Attach Receipt".tr(context: context)),
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      body: CustomAttachReceiptViewBody(),
    );
  }
}
