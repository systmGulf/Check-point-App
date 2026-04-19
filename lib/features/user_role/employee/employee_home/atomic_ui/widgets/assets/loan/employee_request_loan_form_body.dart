import 'package:employee_mangement/core/style/app_colors.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_cubit.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EmployeeRequestLoanFormBody extends StatefulWidget {
  const EmployeeRequestLoanFormBody({super.key});

  @override
  State<EmployeeRequestLoanFormBody> createState() =>
      _EmployeeRequestLoanFormBodyState();
}

class _EmployeeRequestLoanFormBodyState
    extends State<EmployeeRequestLoanFormBody> {
  late final TextEditingController amountController;
  late final TextEditingController requesterNameController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
  InstallementTypeItem? selectedInstallementType;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    requesterNameController = TextEditingController(text: ApiConstant.username);
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    requesterNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

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
        if (state.isLoadingInstallementTypes &&
            state.installementTypes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null && state.installementTypes.isEmpty) {
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
                        .loadInstallementTypes(),
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
              _buildLoanDropdown(state),
              const SizedBox(height: 12),
              _buildTextField(
                controller: amountController,
                label: 'Amount',
                hint: '50000',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: requesterNameController,
                label: 'Requester Name',
                hint: 'Employee Name',
              ),
              const SizedBox(height: 12),
              _buildDateField(
                controller: startDateController,
                label: 'Start Date',
              ),
              const SizedBox(height: 12),
              _buildDateField(
                controller: endDateController,
                label: 'End Date',
              ),
              const SizedBox(height: 18),
              CustomAppButton(
                textButton: state.isSubmittingRequest
                    ? 'Submitting...'
                    : 'Submit request',
                buttonColor: AppColors.black,
                onPressed: state.isSubmittingRequest
                    ? null
                    : () => _submitLoanRequest(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoanDropdown(EmployeeAssetsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Loan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<InstallementTypeItem>(
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          initialValue: selectedInstallementType,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          hint: const Text('Choose installement type'),
          items: state.installementTypes
              .map(
                (type) => DropdownMenuItem<InstallementTypeItem>(
                  value: type,
                  child: Text(
                    '${type.name ?? 'Type'} (${type.code ?? '-'})',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedInstallementType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final selected = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );
            if (selected != null) {
              controller.text =
                  '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
            }
          },
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _submitLoanRequest(BuildContext context) {
    final now = DateTime.now();
    final code =
        'LoanReq-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(8)}';
    final installementTypeId = selectedInstallementType?.id ?? '';
    final amountText = amountController.text.trim();
    final requesterName = requesterNameController.text.trim();
    final startDate = startDateController.text.trim();
    final endDate = endDateController.text.trim();
    final requesterId = ApiConstant.employeeId;

    final amount = num.tryParse(amountText);

    if (installementTypeId.isEmpty ||
        amount == null ||
        requesterId.isEmpty ||
        requesterName.isEmpty ||
        startDate.isEmpty ||
        endDate.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message: 'Please fill all required loan fields',
        ),
      );
      return;
    }

    context.read<EmployeeAssetsCubit>().submitLoanRequest(
          code: code,
          installementTypeId: installementTypeId,
          amount: amount,
          startDate: startDate,
          endDate: endDate,
          requesterId: requesterId,
          requesterName: requesterName,
        );
  }
}
