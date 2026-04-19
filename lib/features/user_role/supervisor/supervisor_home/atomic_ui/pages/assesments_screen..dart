import 'package:employee_mangement/core/base/async_value.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/assesment/cubit/assesment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assesment_model/assesment_input_model/assesment_input_model.dart';

import '../../../../../../core/routing/routes.dart';

class AssessmentsScreen extends StatelessWidget {
  const AssessmentsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, "Assessments"),
      body: BlocBuilder<AssesmentCubit, AsyncValue<AssesmentState>>(
        builder: (context, state) {
          return switch (state) {
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            AsyncFailure(:final msg) => Center(child: Text(msg)),
            AsyncSuccess(:final value) => value.assesmentModelList.isEmpty
                ? const Center(child: Text("No assessments found"))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                    itemCount: value.assesmentModelList.length,
                    separatorBuilder: (_, __) => verticalSpace(10),
                    itemBuilder: (context, index) {
                      final assesment = value.assesmentModelList[index];
                      final title = assesment.assessment?.title ?? "Assessment";
                      final description =
                          assesment.assessment?.description ?? "No description";
                      final minutes = assesment.assessment?.minutes ?? 0;
                      final questionsCount =
                          assesment.assessment?.questions?.length ?? 0;

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.pushName(
                          Routes.assesmentScreen,
                          arguments: {
                            "id": assesment.assessmentId,
                            "cubit": context.read<AssesmentCubit>(),
                            "employeeAssessmentId": assesment.id,
                          },
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ],
                                ),
                                verticalSpace(6),
                                Text(
                                  description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 13,
                                  ),
                                ),
                                verticalSpace(10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _InfoChip(
                                      icon: Icons.timer_outlined,
                                      label: "$minutes min",
                                    ),
                                    _InfoChip(
                                      icon: Icons.quiz_outlined,
                                      label: "$questionsCount questions",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            _ => Container(),
          };
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF374151)),
          horizontalSpace(6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class AssessmentDetailsScreen extends StatefulWidget {
  final String assessmentId;
  final String employeeAssessmentId;
  final AssesmentCubit cubit;

  const AssessmentDetailsScreen(
      {super.key,
      required this.assessmentId,
      required this.cubit,
      required this.employeeAssessmentId});

  @override
  State<AssessmentDetailsScreen> createState() =>
      _AssessmentDetailsScreenState();
}

class _AssessmentDetailsScreenState extends State<AssessmentDetailsScreen> {
  final Map<int, int> selectedAnswers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    widget.cubit.getAssesmentById(widget.assessmentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: buildCustomAppBar(context, "Your Assessment"),
        body: BlocListener<AssesmentCubit, AsyncValue<AssesmentState>>(
          listener: (context, state) {
            switch (state) {
              case AsyncSuccess(:final value):
                switch (value) {
                  case SubmitAssesmentSuccessState():
                    setState(() => _isSubmitting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Submitted Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.pushName(Routes.employeeHomeScreen);
                    break;
                  case SubmitAssesmentFailureState(:final msg):
                    setState(() => _isSubmitting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        backgroundColor: Colors.red,
                      ),
                    );
                    break;
                  default:
                    break;
                }
                break;
              default:
                break;
            }
          },
          child: BlocBuilder<AssesmentCubit, AsyncValue<AssesmentState>>(
            builder: (context, state) {
              return switch (state) {
                AsyncLoading() =>
                  const Center(child: CircularProgressIndicator()),
                AsyncSuccess(:final value) => switch (value) {
                    GeetAssesmentByIdLoadingState() =>
                      const Center(child: CircularProgressIndicator()),
                    GetAssesmentByIdFailureState(:final msg) =>
                      Center(child: Text(msg)),
                    GetAssesmentByIdSuccessState(:final assesment) =>
                      _buildAssessmentContent(assesment),
                    _ => const SizedBox(),
                  },
                AsyncFailure(:final msg) => Center(child: Text(msg)),
                _ => const SizedBox(),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentContent(assesment) {
    final assessment = assesment.assessment;
    final questions = assessment?.questions ?? [];
    final totalQuestions = questions.length;
    final answeredQuestions = selectedAnswers.length;
    final progress =
        totalQuestions == 0 ? 0.0 : answeredQuestions / totalQuestions;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            itemCount: questions.length + 1,
            separatorBuilder: (_, __) => verticalSpace(10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment?.title ?? "Assessment",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if ((assessment?.description ?? '')
                          .trim()
                          .isNotEmpty) ...[
                        verticalSpace(6),
                        Text(
                          assessment!.description!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                      verticalSpace(12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(
                            icon: Icons.quiz_outlined,
                            label: "$totalQuestions questions",
                          ),
                          _InfoChip(
                            icon: Icons.timer_outlined,
                            label: "${assessment?.minutes ?? 0} min",
                          ),
                        ],
                      ),
                      verticalSpace(12),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: const Color(0xFFE5E7EB),
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                          horizontalSpace(10),
                          Text(
                            "$answeredQuestions/$totalQuestions",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              final qIndex = index - 1;
              final question = questions[qIndex];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question ${qIndex + 1}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalSpace(6),
                    Text(
                      question.text ?? "",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    verticalSpace(10),
                    ...List.generate(question.options?.length ?? 0, (oIndex) {
                      final option = question.options?[oIndex];
                      final isSelected = selectedAnswers[qIndex] == oIndex;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _OptionTile(
                          text: option?.text ?? "",
                          isSelected: isSelected,
                          onTap: _isSubmitting
                              ? null
                              : () {
                                  setState(() {
                                    selectedAnswers[qIndex] = oIndex;
                                  });
                                },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: CustomAppButton(
              textButton: _isSubmitting
                  ? "Submitting..."
                  : "Submit ($answeredQuestions/$totalQuestions)",
              buttonColor: const Color(0xFF4F46E5),
              onPressed: _isSubmitting ? null : _submit,
            ),
          ),
        ),
      ],
    );
  }

  SnackBar _buildNotEnoughAnswersWarning() {
    return const SnackBar(
      content: Text("Please answer all questions"),
      backgroundColor: Colors.orange,
    );
  }

  void _submit() {
    final state = widget.cubit.state;
    if (state is! AsyncSuccess<AssesmentState>) return;

    final value = state.value;
    if (value is! GetAssesmentByIdSuccessState) return;

    final totalQuestions = value.assesment.assessment?.questions?.length ?? 0;

    if (selectedAnswers.length < totalQuestions) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildNotEnoughAnswersWarning(),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final answers = selectedAnswers.entries.map((entry) {
      return AnswerModel(
        questionIndex: entry.key,
        selectedOptionIndex: entry.value,
      );
    }).toList();

    final request = AssesmentInputModel(
      employeeAssessmentId: widget.employeeAssessmentId,
      answers: answers,
    );

    widget.cubit.submitAssesment(request);
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 20,
              color: isSelected
                  ? const Color(0xFF4F46E5)
                  : const Color(0xFF9CA3AF),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF312E81)
                      : const Color(0xFF111827),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
