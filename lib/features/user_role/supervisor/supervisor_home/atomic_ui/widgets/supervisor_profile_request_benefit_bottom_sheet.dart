import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/employee_profile_cubit/employee_profile_benefit_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_benefit_model/employee_benefits_response.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SupervisorProfileRequestBenefitBottomSheet extends StatefulWidget {
  const SupervisorProfileRequestBenefitBottomSheet({
    super.key,
    required this.employeeId,
    required this.employeeName,
    required this.onBenefitRequested,
  });

  final String employeeId;
  final String employeeName;
  final VoidCallback onBenefitRequested;

  @override
  State<SupervisorProfileRequestBenefitBottomSheet> createState() =>
      _SupervisorProfileRequestBenefitBottomSheetState();
}

class _SupervisorProfileRequestBenefitBottomSheetState
    extends State<SupervisorProfileRequestBenefitBottomSheet> {
  EmployeeBenefitItem? selectedBenefit;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;

  @override
  void initState() {
    super.initState();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeProfileBenefitRequestCubit,
        EmployeeProfileBenefitRequestState>(
      listenWhen: (previous, current) =>
          previous.isBenefitRequested != current.isBenefitRequested ||
          previous.submitErrorMessage != current.submitErrorMessage,
      listener: (context, state) {
        if (state.submitErrorMessage != null &&
            state.submitErrorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submitErrorMessage!)),
          );
        }

        if (state.isBenefitRequested) {
          context
              .read<EmployeeProfileBenefitRequestCubit>()
              .clearBenefitRequestedFlag();
          widget.onBenefitRequested();
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Request Benefit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Benefit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (state.isLoadingBenefits)
                    const _BenefitDropdownSkeleton()
                  else
                    _BenefitDropdownField(
                      benefits: state.benefits,
                      selectedBenefit: selectedBenefit,
                      onChanged: (value) {
                        setState(() {
                          selectedBenefit = value;
                          startDateController.text =
                              (value?.period?.startDate ?? '').trim();
                          endDateController.text =
                              (value?.period?.endDate ?? '').trim();
                        });
                      },
                    ),
                  const SizedBox(height: 14),
                  _DateField(
                    label: 'Start Date',
                    controller: startDateController,
                  ),
                  const SizedBox(height: 10),
                  _DateField(
                    label: 'End Date',
                    controller: endDateController,
                  ),
                  const SizedBox(height: 18),
                  CustomAppButton(
                    textButton: state.isSubmitting
                        ? 'Submitting...'
                        : 'Request Benefit',
                    buttonColor: Colors.black,
                    onPressed:
                        state.isSubmitting ? null : () => _submit(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    final benefit = selectedBenefit;
    if (benefit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a benefit')),
      );
      return;
    }

    final startDate = startDateController.text.trim();
    final endDate = endDateController.text.trim();
    if (startDate.isEmpty || endDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end date')),
      );
      return;
    }

    context.read<EmployeeProfileBenefitRequestCubit>().requestBenefit(
          employeeId: widget.employeeId,
          employeeName: widget.employeeName,
          benefit: benefit,
          startDate: startDate,
          endDate: endDate,
        );
  }
}

class _BenefitDropdownField extends StatelessWidget {
  const _BenefitDropdownField({
    required this.benefits,
    required this.selectedBenefit,
    required this.onChanged,
  });

  final List<EmployeeBenefitItem> benefits;
  final EmployeeBenefitItem? selectedBenefit;
  final ValueChanged<EmployeeBenefitItem?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<EmployeeBenefitItem>(
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Colors.white,
      initialValue: selectedBenefit,
      items: benefits
          .map(
            (benefit) => DropdownMenuItem<EmployeeBenefitItem>(
              value: benefit,
              child: Text(
                (benefit.name ?? benefit.planName ?? '--').trim(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Select benefit',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
    );
  }
}

class _BenefitDropdownSkeleton extends StatelessWidget {
  const _BenefitDropdownSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        alignment: Alignment.centerLeft,
        child: const Text('Loading benefits'),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              controller.text =
                  '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
            }
          },
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }
}
