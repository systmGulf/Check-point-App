import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/question_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/employee_survey_reponse_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/submit_survey_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/surveys_reponse_model.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../contoller/surveys/surveys_cubit.dart';

class SurveyQuestionsDialog extends StatefulWidget {
  final SurveyModel survey;

  const SurveyQuestionsDialog({super.key, required this.survey});

  @override
  State<SurveyQuestionsDialog> createState() => _SurveyQuestionsDialogState();
}

class _SurveyQuestionsDialogState extends State<SurveyQuestionsDialog> {
  final Map<String, TextEditingController> _answerControllers = {};
  final Map<String, String> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    for (var question in widget.survey.questions) {
      _answerControllers[question.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _answerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Dialog(
      backgroundColor: ColorsManger.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(
              widget.survey.title,
              style: AppStylesManger.font18BoldBlack,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.survey.questions.length,
                itemBuilder: (context, index) {
                  final question = widget.survey.questions[index];
                  return QuestionWidget(
                    question: question,
                    controller: _answerControllers[question.id],
                    onAnswerChanged: (value) {
                      _selectedOptions[question.id] = value;
                    },
                  );
                },
              ),
            ),
            BlocBuilder<SurveysCubit, GetSurveysState>(
              builder: (context, state) {
                final isLoading = state is SubmitSurveyLoadingState;
                return CustomAppButton(
                  textButton: isLoading ? 'Submitting...' : 'Submit Survey',
                  buttonColor: ColorsManger.primaryColor,
                  onPressed: isLoading ? null : () => _submitSurvey(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitSurvey(BuildContext context) async {
    final answers = <SurveyAnswerModel>[];

    for (var entry in _selectedOptions.entries) {
      answers.add(
        SurveyAnswerModel(
          questionId: entry.key,
          answerText: entry.value,
        ),
      );
    }

    final requestBody = SubmitSurveyRequestBody(
      surveyId: widget.survey.id,
      employeeId: ApiConstant.employeeId,
      answers: answers,
    );

    await context.read<SurveysCubit>().submitSurvey(requestBody: requestBody);
    Navigator.pop(context);
  }
}
