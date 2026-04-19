import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/surveys_questions_dialog.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/surveys_reponse_model.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';

class AvailableSurveyCard extends StatelessWidget {
  final SurveyModel survey;

  const AvailableSurveyCard({super.key, required this.survey});

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
            Text(
              survey.title,
              style: AppStylesManger.font16BoldBlack,
            ),
            const SizedBox(height: 8),
            Text(
              survey.description,
              style: AppStylesManger.font14BoldBlack,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.quiz, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Questions: ${survey.questions.length}',
                  style: AppStylesManger.font14BoldBlack,
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today,
                    size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Due: ${_formatDate(survey.endDate)}',
                  style: AppStylesManger.font14BoldBlack,
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomAppButton(
              textButton: 'Start Survey',
              buttonColor: ColorsManger.primaryColor,
              onPressed: () => showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<SurveysCubit>(),
                  child: SurveyQuestionsDialog(survey: survey),
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
