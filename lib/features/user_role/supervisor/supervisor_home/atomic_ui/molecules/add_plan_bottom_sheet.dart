import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/plans_v2_models.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import 'add_plan_bloc_listener.dart';

class AddPlanBottomSheet extends StatefulWidget {
  const AddPlanBottomSheet({super.key});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final List<_SubPlanInput> _subPlans = [_SubPlanInput()];

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    for (final item in _subPlans) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ),
              Center(
                child: Text(
                  'Set Plan'.tr(context: context),
                  style: AppStylesManger.font16BoldBlack,
                ),
              ),
              verticalSpace(12),
              Text('Title'.tr(context: context),
                  style: AppStylesManger.font12RegularGrey),
              verticalSpace(8),
              CustomAppTextFormField(
                controller: _titleController,
                hint: 'Enter title'.tr(context: context),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Title is required'.tr(context: context)
                    : null,
              ),
              verticalSpace(10),
              Text('Description'.tr(context: context),
                  style: AppStylesManger.font12RegularGrey),
              verticalSpace(8),
              CustomAppTextFormField(
                controller: _descriptionController,
                hint: 'Enter description'.tr(context: context),
                maxLines: 2,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Description is required'.tr(context: context)
                    : null,
              ),
              verticalSpace(10),
              _buildDateField(
                label: 'Start Date',
                value: _startDate,
                onTap: () => _pickDate(isStartDate: true),
              ),
              verticalSpace(10),
              _buildDateField(
                label: 'End Date',
                value: _endDate,
                onTap: () => _pickDate(isStartDate: false),
              ),
              verticalSpace(10),
              Text('Notes'.tr(context: context),
                  style: AppStylesManger.font12RegularGrey),
              verticalSpace(8),
              CustomAppTextFormField(
                controller: _notesController,
                maxLines: 3,
                hint: 'Enter notes'.tr(context: context),
              ),
              verticalSpace(14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sub Plans'.tr(context: context),
                    style: AppStylesManger.font14MediumBlack,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _subPlans.add(_SubPlanInput());
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: Text('Add Sub Plan'.tr(context: context)),
                  ),
                ],
              ),
              ...List.generate(_subPlans.length, (index) {
                return _SubPlanCard(
                  index: index,
                  input: _subPlans[index],
                  onPickDate: () => _pickSubPlanDate(index),
                  onRemove: _subPlans.length == 1
                      ? null
                      : () {
                          setState(() {
                            final item = _subPlans.removeAt(index);
                            item.dispose();
                          });
                        },
                );
              }),
              verticalSpace(8),
              CustomAppButton(
                onPressed: () => validateAndAddPlan(context),
                textButton: 'Add'.tr(context: context),
                buttonColor: ColorsManger.primaryColor,
              ),
              const AddPlanBlocListener(),
              verticalSpace(8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr(context: context),
            style: AppStylesManger.font12RegularGrey),
        verticalSpace(8),
        CustomAppTextFormField(
          onTap: onTap,
          readOnly: true,
          hint: value == null
              ? 'Choose date...'.tr(context: context)
              : _dateOnly(value),
          suffixIcon: SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: SvgPicture.asset('assets/images/calendar.svg'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final now = DateTime.now();
    final initial =
        isStartDate ? (_startDate ?? now) : (_endDate ?? _startDate ?? now);
    final firstDate =
        isStartDate ? DateTime(2000) : (_startDate ?? DateTime(2000));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;

    setState(() {
      if (isStartDate) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _pickSubPlanDate(int index) async {
    final now = DateTime.now();
    final current = _subPlans[index].dueDate ?? _startDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _subPlans[index].dueDate = picked;
    });
  }

  String _dateOnly(DateTime date) => date.toIso8601String().split('T').first;

  String _requestDate(DateTime date) {
    return DateTime(date.year, date.month, date.day).toUtc().toIso8601String();
  }

  void validateAndAddPlan(BuildContext context) {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    if (_startDate == null || _endDate == null) {
      _showError('Please choose start and end date');
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      _showError('End date must be after start date');
      return;
    }

    final subPlanBodies = <CreateSubPlanRequestBody>[];
    for (var i = 0; i < _subPlans.length; i++) {
      final input = _subPlans[i];
      if (input.isEmpty) continue;
      if (!input.isValid) {
        _showError('Please complete Sub Plan ${i + 1}');
        return;
      }
      subPlanBodies.add(
        CreateSubPlanRequestBody(
          title: input.titleController.text.trim(),
          description: input.descriptionController.text.trim(),
          dueDate: _requestDate(input.dueDate!),
          notes: input.notesController.text.trim(),
        ),
      );
    }

    context.read<PlanCubit>().addPlanV2(
          body: CreatePlanRequestBody(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            startDate: _requestDate(_startDate!),
            endDate: _requestDate(_endDate!),
            notes: _notesController.text.trim(),
            subPlans: subPlanBodies,
          ),
        );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.tr(context: context))),
    );
  }
}

class _SubPlanInput {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();
  DateTime? dueDate;

  bool get isEmpty =>
      titleController.text.trim().isEmpty &&
      descriptionController.text.trim().isEmpty &&
      notesController.text.trim().isEmpty &&
      dueDate == null;

  bool get isValid =>
      titleController.text.trim().isNotEmpty &&
      descriptionController.text.trim().isNotEmpty &&
      dueDate != null;

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();
  }
}

class _SubPlanCard extends StatelessWidget {
  const _SubPlanCard({
    required this.index,
    required this.input,
    required this.onPickDate,
    this.onRemove,
  });

  final int index;
  final _SubPlanInput input;
  final VoidCallback onPickDate;
  final VoidCallback? onRemove;

  String _dateOnly(DateTime date) => date.toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'Sub Plan'.tr(context: context)} ${index + 1}',
                style: AppStylesManger.font14MediumBlack,
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          verticalSpace(8),
          CustomAppTextFormField(
            controller: input.titleController,
            hint: 'Sub plan title'.tr(context: context),
          ),
          verticalSpace(8),
          CustomAppTextFormField(
            controller: input.descriptionController,
            hint: 'Sub plan description'.tr(context: context),
            maxLines: 2,
          ),
          verticalSpace(8),
          CustomAppTextFormField(
            readOnly: true,
            onTap: onPickDate,
            hint: input.dueDate == null
                ? 'Choose due date...'.tr(context: context)
                : _dateOnly(input.dueDate!),
            suffixIcon: SizedBox(
              height: 24,
              width: 24,
              child: Center(
                child: SvgPicture.asset('assets/images/calendar.svg'),
              ),
            ),
          ),
          verticalSpace(8),
          CustomAppTextFormField(
            controller: input.notesController,
            hint: 'Sub plan notes'.tr(context: context),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
