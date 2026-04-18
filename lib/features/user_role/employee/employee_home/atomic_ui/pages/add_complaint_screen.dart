import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/core/widgets/custom_app_text_form_field.dart';
import 'package:employee_mangement/core/widgets/custom_loading_indicator.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/complaints/complaints_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    context.read<ComplaintsCubit>().addComplaint(
          subject: _subjectController.text.trim(),
          description: _descriptionController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComplaintsCubit, ComplaintsState>(
      listenWhen: (previous, current) =>
          current is AddComplaintLoading ||
          current is AddComplaintSuccess ||
          current is AddComplaintFailureState,
      listener: (context, state) {
        if (state is AddComplaintLoading) {
          customLoadingIndicator(context);
        } else if (state is AddComplaintFailureState) {
          Navigator.of(context, rootNavigator: true).pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.error),
          );
        } else if (state is AddComplaintSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Complaint added successfully'.tr(context: context),
            ),
          );
          Navigator.of(context).pop(true);
          context.read<ComplaintsCubit>()..getComplaints();
        }
      },
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          'Add Complaint'.tr(context: context),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subject'.tr(context: context),
                    style: AppStylesManger.font12RegularGrey,
                  ),
                  verticalSpace(10),
                  CustomAppTextFormField(
                    controller: _subjectController,
                    hint: 'Enter subject'.tr(context: context),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Please enter subject'.tr(context: context);
                      }
                      return null;
                    },
                  ),
                  verticalSpace(16),
                  Text(
                    'Description'.tr(context: context),
                    style: AppStylesManger.font12RegularGrey,
                  ),
                  verticalSpace(10),
                  CustomAppTextFormField(
                    controller: _descriptionController,
                    hint: 'Enter description'.tr(context: context),
                    maxLines: 6,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Please enter description'.tr(context: context);
                      }
                      return null;
                    },
                  ),
                  verticalSpace(24),
                  CustomAppButton(
                    textButton: 'Submit Complaint'.tr(context: context),
                    buttonColor: ColorsManger.primaryColor,
                    onPressed: _submitComplaint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
