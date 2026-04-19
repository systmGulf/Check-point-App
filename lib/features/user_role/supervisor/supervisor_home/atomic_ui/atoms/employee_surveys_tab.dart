import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/compeleted_surveys_card_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/empty_surveys_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_state.dart';
import 'package:flutter/material.dart';
class EmployeeSurveysTab extends StatelessWidget {
  final GetSurveysState state;

  const EmployeeSurveysTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      GetEmployeeSurveysLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      GetEmployeeSurveysFailureState() => const NoDataFound(),
      GetEmployeeSurveysSuccessState(employeeSurveyReponseModel: final model) =>
        model.value.isEmpty
            ? const EmptySurveysWidget(
                icon: Icons.assignment_turned_in,
                title: 'No surveys completed yet',
                subtitle: 'Complete surveys from the Available Surveys tab',
              )
            : ListView.builder(
                shrinkWrap: true, 
                physics: const NeverScrollableScrollPhysics(), // Add this
                padding: const EdgeInsets.all(12),
                itemCount: model.value.length,
                itemBuilder: (context, index) {
                  final survey = model.value[index];
                  return CompletedSurveyCard(survey: survey);
                },
              ),
      _ => const SizedBox.shrink(),
    };
  }
}