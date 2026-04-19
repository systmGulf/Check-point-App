import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/available_surveys_card_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/empty_surveys_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_state.dart';
import 'package:flutter/material.dart';

class AvailableSurveysTab extends StatelessWidget {
  final GetSurveysState state;

  const AvailableSurveysTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      GetSurveysLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      GetSurveysFailureState() => const NoDataFound(),
      GetSurveysSuccessState(surveyResponseModel: final model) =>
        model.value.isEmpty
            ? const EmptySurveysWidget(
                icon: Icons.assignment,
                title: 'No surveys available',
                subtitle: 'Check back later for new surveys',
              )
            : ListView.builder(
                shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: model.value.length,
                itemBuilder: (context, index) {
                  final survey = model.value[index];
                  return AvailableSurveyCard(survey: survey);
                },
              ),
      _ => const SizedBox.shrink(),
    };
  }
}
