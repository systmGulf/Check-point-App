import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/core/widgets/custom_app_text_form_field.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/feedback/feedback_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/feedback/feedback_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/feedbacks/add_feedback_request_body.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddFeedbackScreen extends StatefulWidget {
  const AddFeedbackScreen({super.key});

  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedbackCubit>();

    return Scaffold(
      appBar: buildCustomAppBar(context, "Add Feedback"),
      body: BlocListener<FeedbackCubit, FeedbackState>(
        listener: (context, state) {
          if (state is AddFeedbackSuccessState) {
            Navigator.of(context).pop(true);
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'Feedback added successfully'.tr(context: context),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              CustomAppTextFormField(
                controller: subjectController,
                hint: "Subject",
              ),
              CustomAppTextFormField(
                controller: messageController,
                hint: "Message",
                maxLines: 6,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() => rating = index + 1);
                    },
                    icon: Icon(
                      Icons.star,
                      color: index < rating ? Colors.amber : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              CustomAppButton(
                textButton: "Submit",
                buttonColor: ColorsManger.primaryColor,
                onPressed: () {
                  cubit.addFeedback(
                    AddFeedbackRequest(
                        subject: subjectController.text,
                        message: messageController.text,
                        rating: rating,
                        employeeId: ApiConstant.employeeId),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
