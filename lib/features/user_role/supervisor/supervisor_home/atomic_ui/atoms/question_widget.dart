import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/surveys_reponse_model.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';

class QuestionWidget extends StatefulWidget {
  final SurveyQuestionModel question;
  final TextEditingController? controller;
  final Function(String) onAnswerChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    this.controller,
    required this.onAnswerChanged,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            '${widget.question.order}. ${widget.question.text}',
            style: AppStylesManger.font14BoldBlack,
          ),
          const SizedBox(height: 12),
          CustomAppTextFormField(
            controller: widget.controller,
            hint: 'Enter your answer',
            maxLines: 3,
            onChanged: widget.onAnswerChanged,
          ),
        ],
      ),
    );
  }
}
