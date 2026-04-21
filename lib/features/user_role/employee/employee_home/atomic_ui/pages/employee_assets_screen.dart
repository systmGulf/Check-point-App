import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_new_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/allowance/employee_allowance_dashboard_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_assets_dashboard_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/loan/employee_loan_dashboard_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_cubit.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeAssetsScreen extends StatelessWidget {
  const EmployeeAssetsScreen({
    super.key,
    this.assetType = 'assets',
  });

  final String assetType;

  @override
  Widget build(BuildContext context) {
    final isAllowance = assetType.toLowerCase() == 'allowance';
    final isLoan = assetType.toLowerCase() == 'loan';
    return Scaffold(
      floatingActionButton: CustomNewFloatingActionButton(
        onPressed: () async {
          final result = await context.pushName(
            Routes.employeeAssetsAllRequestsScreen,
            arguments: {
              'assetType': isAllowance
                  ? 'allowance'
                  : isLoan
                      ? 'loan'
                      : 'assets',
            },
          );
          if (result == true && context.mounted) {
            if (isAllowance) {
              context.read<EmployeeAssetsCubit>().loadAllowances();
            } else if (isLoan) {
              context.read<EmployeeAssetsCubit>().loadLoans();
            } else {
              context.read<EmployeeAssetsCubit>().loadDashboard();
            }
          }
        },
      ),
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: buildCustomAppBar(
        context,
        isAllowance
            ? 'Allowance'.tr(context: context)
            : isLoan
                ? 'Loan'.tr(context: context)
                : 'Assets'.tr(context: context),
      ),
      body: BlocBuilder<EmployeeAssetsCubit, EmployeeAssetsState>(
        builder: (context, state) {
          if (isAllowance) {
            return EmployeeAllowanceDashboardBody(
              state: state,
              onRefresh: () =>
                  context.read<EmployeeAssetsCubit>().loadAllowances(),
            );
          }
          if (isLoan) {
            return EmployeeLoanDashboardBody(
              state: state,
              onRefresh: () => context.read<EmployeeAssetsCubit>().loadLoans(),
            );
          }
          return EmployeeAssetsDashboardBody(
            state: state,
            onRefresh: () =>
                context.read<EmployeeAssetsCubit>().loadDashboard(),
          );
        },
      ),
    );
  }
}
