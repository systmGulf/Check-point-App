import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/styles/colors.dart';
import '../atoms/available_surveys_tap.dart';
import '../atoms/employee_surveys_tab.dart';

class SurveysScreen extends StatefulWidget {
  const SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SurveysCubit>()
        ..getAllSurveys()
        ..getEmployeeSurveys();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            indicatorColor: ColorsManger.primaryColor,
            labelColor: ColorsManger.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Available Surveys'),
              Tab(text: 'My Surveys'),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 300,
              maxHeight: MediaQuery.of(context).size.height - 250,
            ),
            child: BlocListener<SurveysCubit, GetSurveysState>(
              listenWhen: (previous, current) =>
                  current is SubmitSurveySuccessState ||
                  current is SubmitSurveyFailureState,
              listener: (context, state) {
                if (state is SubmitSurveySuccessState) {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.success(
                      message:
                          "Survey submitted successfully".tr(context: context),
                    ),
                  );
                  context.read<SurveysCubit>().getEmployeeSurveys();
                } else if (state is SubmitSurveyFailureState) {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.error(
                      message: state.errorMessage.tr(context: context),
                    ),
                  );
                }
              },
              child: BlocBuilder<SurveysCubit, GetSurveysState>(
                builder: (context, state) {
                  return TabBarView(
                    children: [
                      AvailableSurveysTab(state: state),
                      EmployeeSurveysTab(state: state),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
