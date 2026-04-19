import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/employee_survey_reponse_model.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class SurveyDetailsDialog extends StatelessWidget {
  final SurveySubmissionModel survey;

  const SurveyDetailsDialog({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              survey.surveyTitle,
              style: AppStylesManger.font18BoldBlack,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: survey.answers.length,
                itemBuilder: (context, index) {
                  final answer = survey.answers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorsManger.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}',
                          style: AppStylesManger.font11RegularBlack,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Answer: ${answer.answerText}',
                          style: AppStylesManger.font14BoldBlack,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
