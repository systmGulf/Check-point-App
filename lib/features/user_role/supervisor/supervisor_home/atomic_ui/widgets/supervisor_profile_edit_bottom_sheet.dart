import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/employee_profile_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/update_employee_profile_request_body.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../contoller/employee_profile_cubit/employee_profile_cubit.dart';

class SupervisorProfileEditBottomSheet extends StatefulWidget {
  const SupervisorProfileEditBottomSheet({
    super.key,
    required this.profile,
  });

  final EmployeeProfileValue profile;

  @override
  State<SupervisorProfileEditBottomSheet> createState() =>
      _SupervisorProfileEditBottomSheetState();
}

class _SupervisorProfileEditBottomSheetState
    extends State<SupervisorProfileEditBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController arabicFirstNameController;
  late final TextEditingController arabicLastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController nationalityController;
  late final TextEditingController streetController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final personal = widget.profile.personalInfo;
    final contact = widget.profile.contactInfo;

    firstNameController =
        TextEditingController(text: personal?.firstName ?? '');
    lastNameController = TextEditingController(text: personal?.lastName ?? '');
    arabicFirstNameController =
        TextEditingController(text: personal?.arabicFirstName ?? '');
    arabicLastNameController =
        TextEditingController(text: personal?.arabicLastName ?? '');
    emailController = TextEditingController(text: contact?.email ?? '');
    phoneController = TextEditingController(text: contact?.phone ?? '');
    nationalityController =
        TextEditingController(text: personal?.nationality ?? '');
    streetController =
        TextEditingController(text: contact?.address?.street ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    arabicFirstNameController.dispose();
    arabicLastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalityController.dispose();
    streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Update Profile',
                      style: AppStylesManger.font16BoldBlack),
                  const Spacer(),
                  IconButton(
                    onPressed: isSaving ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              verticalSpace(8),
              CustomAppTextFormField(
                hint: 'First Name',
                controller: firstNameController,
                validator: _requiredValidator,
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                hint: 'Last Name',
                controller: lastNameController,
                validator: _requiredValidator,
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                hint: 'Arabic First Name',
                controller: arabicFirstNameController,
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                hint: 'Arabic Last Name',
                controller: arabicLastNameController,
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                hint: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _requiredValidator,
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                hint: 'Phone',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: _requiredValidator,
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                hint: 'Nationality',
                controller: nationalityController,
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                hint: 'Street',
                controller: streetController,
              ),
              verticalSpace(14),
              CustomAppButton(
                textButton: isSaving ? 'Saving...' : 'Save Changes',
                buttonColor: Colors.white,
                onPressed: isSaving ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required field';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() {
      isSaving = true;
    });

    final personal = widget.profile.personalInfo;
    final contact = widget.profile.contactInfo;
    final spec = widget.profile.employeeSpecification;
    final address = contact?.address;

    final body = UpdateEmployeeProfileRequestBody(
      personalInfo: EmployeePersonalInfoRequest(
        firstName: firstNameController.text.trim(),
        arabicFirstName: arabicFirstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        arabicLastName: arabicLastNameController.text.trim(),
        dateOfBirth: personal?.dateOfBirth,
        nationality: nationalityController.text.trim(),
        gender: personal?.gender,
        maritalStatus: personal?.maritalStatus,
        nationalId: personal?.nationalId,
      ),
      contactInfo: EmployeeContactInfoRequest(
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: EmployeeAddressRequest(
          countryName: address?.countryName,
          cityName: address?.cityName,
          street: streetController.text.trim(),
          postalCode: address?.postalCode,
        ),
      ),
      status: widget.profile.status,
      code: widget.profile.code,
      employmentType: widget.profile.employmentType,
      employeeSpecification: EmployeeSpecificationRequest(
        jobTitle: spec?.jobTitle,
        yearOfExperience: spec?.yearOfExperience,
        organizationUnitName: spec?.organizationUnitName,
        hiringDate: spec?.hiringDate,
        managerName: spec?.managerName,
        department: ApiConstant.departmentId.trim().isNotEmpty
            ? ApiConstant.departmentId.trim()
            : (spec?.organizationUnitName ?? ''),
      ),
      gradeDetails: null,
      historyDto: const EmployeeHistoryDtoRequest(),
    );

    final error =
        await context.read<EmployeeProfileCubit>().updateEmployeeProfile(
              employeeId: widget.profile.id,
              body: body,
            );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        isSaving = false;
      });
      buildSnackBar(
        context,
        customSnackBar: CustomSnackBar.error(
          message: error,
        ),
      );
      return;
    }

    await context.read<EmployeeProfileCubit>().getEmployeeProfile(
          employeeId: widget.profile.id,
        );

    if (!mounted) return;
    Navigator.pop(context);
    buildSnackBar(
      context,
      customSnackBar: const CustomSnackBar.success(
        message: 'Profile updated successfully',
      ),
    );
  }
}
