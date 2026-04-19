import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/surveys_details_dilog.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/employee_survey_reponse_model.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';


class CompletedSurveyCard extends StatelessWidget {
  final SurveySubmissionModel survey;

  const CompletedSurveyCard({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorsManger.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    survey.surveyTitle,
                    style: AppStylesManger.font16BoldBlack,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.quiz, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Questions: ${survey.answers.length}',
                  style: AppStylesManger.font14RegularBlack,
                ),
                const SizedBox(width: 16),
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Submitted: ${_formatDate(survey.submittedAt)}',
                  style: AppStylesManger.font14RegularBlack,
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => SurveyDetailsDialog(survey: survey),
              ),
              child: Text(
                'View Details',
                style: TextStyle(
                  color: ColorsManger.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}