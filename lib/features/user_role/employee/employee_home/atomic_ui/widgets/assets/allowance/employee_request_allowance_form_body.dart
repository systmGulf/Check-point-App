import 'package:employee_mangement/core/style/app_colors.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_cubit.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_allowance_model/all_allowances_response.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EmployeeRequestAllowanceFormBody extends StatefulWidget {
  const EmployeeRequestAllowanceFormBody({super.key});

  @override
  State<EmployeeRequestAllowanceFormBody> createState() =>
      _EmployeeRequestAllowanceFormBodyState();
}

class _EmployeeRequestAllowanceFormBodyState
    extends State<EmployeeRequestAllowanceFormBody> {
  AllowanceCatalogItem? selectedAllowance;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeAssetsCubit, EmployeeAssetsState>(
      listenWhen: (previous, current) =>
          previous.isRequestSubmitted != current.isRequestSubmitted ||
          previous.submitErrorMessage != current.submitErrorMessage,
      listener: (context, state) {
        if (state.submitErrorMessage != null &&
            state.submitErrorMessage!.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.submitErrorMessage!),
          );
        }
        if (state.isRequestSubmitted) {
          context.read<EmployeeAssetsCubit>().clearRequestSubmissionFlag();
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        if (state.isLoadingAvailableAllowances &&
            state.availableAllowances.isEmpty) {
          return const _EmployeeRequestAllowanceFormSkeleton();
        }

        if (state.errorMessage != null && state.availableAllowances.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 36),
                  const SizedBox(height: 12),
                  Text(state.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<EmployeeAssetsCubit>()
                        .loadAvailableAllowances(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select allowance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<AllowanceCatalogItem>(
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                initialValue: selectedAllowance,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                hint: const Text('Choose allowance'),
                items: state.availableAllowances
                    .map(
                      (allowance) => DropdownMenuItem<AllowanceCatalogItem>(
                        value: allowance,
                        child: Text(
                          _buildAllowanceLabel(allowance),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAllowance = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomAppButton(
                textButton: state.isSubmittingRequest
                    ? 'Submitting...'
                    : 'Submit request',
                buttonColor: AppColors.black,
                onPressed: state.isSubmittingRequest
                    ? null
                    : () => _submitAllowanceRequest(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitAllowanceRequest(BuildContext context) {
    final allowanceId = selectedAllowance?.id ?? '';
    final employeeId = ApiConstant.employeeId.trim();

    if (allowanceId.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message: 'Please select an allowance',
        ),
      );
      return;
    }

    if (employeeId.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message: 'Employee ID is missing',
        ),
      );
      return;
    }

    context.read<EmployeeAssetsCubit>().submitAllowanceRequest(
          allowanceId: allowanceId,
          employeeId: employeeId,
        );
  }

  String _buildAllowanceLabel(AllowanceCatalogItem allowance) {
    final name = allowance.name?.trim();
    final code = allowance.code?.trim();
    final amount = allowance.amount;

    final label = <String>[
      if (name != null && name.isNotEmpty) name else 'Allowance',
      if (code != null && code.isNotEmpty) code,
      if (amount != null) '${amount.toStringAsFixed(0)} EGP',
    ];

    return label.join(' - ');
  }
}

class _EmployeeRequestAllowanceFormSkeleton extends StatelessWidget {
  const _EmployeeRequestAllowanceFormSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select allowance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text('Choose allowance'),
            ),
            const SizedBox(height: 16),
            Container(
              height: 51,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text('Submit request'),
            ),
          ],
        ),
      ),
    );
  }
}
