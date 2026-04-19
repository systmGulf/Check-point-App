import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/widgets/supervisor_profile_skill_dropdown_field.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/widgets/supervisor_profile_skill_rate_dropdown.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/employee_profile_cubit/employee_profile_skill_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SupervisorProfileAddSkillBottomSheet extends StatefulWidget {
  const SupervisorProfileAddSkillBottomSheet({
    super.key,
    required this.employeeId,
    required this.onSkillAdded,
  });

  final String employeeId;
  final VoidCallback onSkillAdded;

  @override
  State<SupervisorProfileAddSkillBottomSheet> createState() =>
      SupervisorProfileAddSkillBottomSheetState();
}

class SupervisorProfileAddSkillBottomSheetState
    extends State<SupervisorProfileAddSkillBottomSheet> {
  String? selectedSkillId;
  int selectedRate = 3;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeProfileSkillCubit, EmployeeProfileSkillState>(
      listenWhen: (previous, current) =>
          previous.isSkillAdded != current.isSkillAdded ||
          previous.submitErrorMessage != current.submitErrorMessage,
      listener: (context, state) {
        if (state.submitErrorMessage != null &&
            state.submitErrorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.submitErrorMessage!)));
        }

        if (state.isSkillAdded) {
          context.read<EmployeeProfileSkillCubit>().clearSkillAddedFlag();
          widget.onSkillAdded();
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
                    'Add Skill',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Skill',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (state.isLoadingSkills)
                    const SupervisorProfileSkillDropdownSkeleton()
                  else
                    SupervisorProfileSkillDropdownField(
                      skills: state.skills,
                      selectedSkillId: selectedSkillId,
                      onChanged: (value) {
                        setState(() {
                          selectedSkillId = value;
                        });
                      },
                    ),
                  const SizedBox(height: 14),
                  const Text(
                    'Rate',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SupervisorProfileSkillRateDropdown(
                    selectedRate: selectedRate,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedRate = value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomAppButton(
                    textButton:
                        state.isSubmitting ? 'Submitting...' : 'Add Skill',
                    buttonColor: Colors.black,
                    onPressed:
                        state.isSubmitting ? null : () => submit(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void submit(BuildContext context) {
    if (selectedSkillId == null || selectedSkillId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please choose a skill')));
      return;
    }

    context.read<EmployeeProfileSkillCubit>().addSkill(
          employeeId: widget.employeeId,
          skillId: selectedSkillId!,
          rate: selectedRate,
        );
  }
}

class SupervisorProfileSkillDropdownSkeleton extends StatelessWidget {
  const SupervisorProfileSkillDropdownSkeleton({super.key});

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
        child: const Text('Loading skills'),
      ),
    );
  }
}
