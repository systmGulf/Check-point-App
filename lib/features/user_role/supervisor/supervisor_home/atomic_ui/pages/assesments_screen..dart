import 'package:employee_mangement/core/base/async_value.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
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
      appBar: AppBar(title: const Text("Assessments")),
      body: BlocBuilder<AssesmentCubit, AsyncValue<AssesmentState>>(
        builder: (context, state) {
          return switch (state) {
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            AsyncFailure(:final msg) => Center(child: Text(msg)),
            AsyncSuccess(:final value) => value.assesmentModelList.isEmpty
                ? const Center(child: Text("No Assessments"))
                : ListView.builder(
                    itemCount: value.assesmentModelList.length,
                    itemBuilder: (context, index) {
                      final assesment = value.assesmentModelList[index];

                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: ListTile(
                          title: Text(assesment.assessment?.title ?? ""),
                          subtitle:
                              Text("${assesment.assessment?.minutes} min"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => context.pushName(
                            Routes.assesmentScreen,
                            arguments: {
                              "id": assesment.assessmentId,
                              "cubit": context.read<AssesmentCubit>(),
                              "employeeAssessmentId": assesment.id,
                            },
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
        appBar: AppBar(title: const Text("Your Assessment")),
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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: assesment.assessment?.questions?.length ?? 0,
            itemBuilder: (context, qIndex) {
              final question = assesment.assessment?.questions?[qIndex];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${qIndex + 1}. ${question?.text}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        question?.options?.length ?? 0,
                        (oIndex) {
                          final option = question?.options?[oIndex];
                          return RadioListTile<int>(
                            value: oIndex,
                            groupValue: selectedAnswers[qIndex],
                            title: Text(option?.text ?? ""),
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    setState(
                                        () => selectedAnswers[qIndex] = value!);
                                  },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text("Submit"),
          ),
        ),
      ],
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
        const SnackBar(
          content: Text("Please answer all questions"),
          backgroundColor: Colors.orange,
        ),
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
