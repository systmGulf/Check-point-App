import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/allowance/employee_request_allowance_form_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/loan/employee_request_loan_form_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_request_asset_form_body.dart';
import 'package:flutter/material.dart';

class EmployeeAssetsAllRequestsScreen extends StatelessWidget {
  const EmployeeAssetsAllRequestsScreen({
    super.key,
    this.assetType = 'assets',
  });

  final String assetType;

  @override
  Widget build(BuildContext context) {
    final isAllowance = assetType.toLowerCase() == 'allowance';
    final isLoan = assetType.toLowerCase() == 'loan';
    return Scaffold(
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: buildCustomAppBar(
        context,
        isAllowance
            ? 'Request Allowance'.tr(context: context)
            : isLoan
                ? 'Request Loan'.tr(context: context)
                : 'Request Asset'.tr(context: context),
      ),
      body: isAllowance
          ? const EmployeeRequestAllowanceFormBody()
          : isLoan
              ? const EmployeeRequestLoanFormBody()
              : const EmployeeRequestAssetFormBody(),
    );
  }
}
