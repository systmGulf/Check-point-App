import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_new_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_assets_dashboard_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_cubit.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeAssetsScreen extends StatelessWidget {
  const EmployeeAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomNewFloatingActionButton(
        onPressed: () async {
          final result =
              await context.pushName(Routes.employeeAssetsAllRequestsScreen);
          if (result == true && context.mounted) {
            context.read<EmployeeAssetsCubit>().loadDashboard();
          }
        },
      ),
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      appBar: buildCustomAppBar(context, 'Assets'.tr(context: context)),
      body: BlocBuilder<EmployeeAssetsCubit, EmployeeAssetsState>(
        builder: (context, state) {
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
