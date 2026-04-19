import 'package:employee_mangement/core/style/app_colors.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_dropdown_field.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_request_asset_form_skeleton.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_request_asset_note_field.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_cubit.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EmployeeRequestAssetFormBody extends StatefulWidget {
  const EmployeeRequestAssetFormBody({super.key});

  @override
  State<EmployeeRequestAssetFormBody> createState() =>
      EmployeeRequestAssetFormBodyState();
}

class EmployeeRequestAssetFormBodyState
    extends State<EmployeeRequestAssetFormBody> {
  late final TextEditingController noteController;
  String? selectedAssetId;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeAssetsCubit, EmployeeAssetsState>(
      listenWhen: (previous, current) =>
          previous.isRequestSubmitted != current.isRequestSubmitted ||
          previous.submitErrorMessage != current.submitErrorMessage,
      listener: (context, state) {
        if (state.submitErrorMessage != null &&
            state.submitErrorMessage!.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.submitErrorMessage!,
            ),
          );
        }
        if (state.isRequestSubmitted) {
          context.read<EmployeeAssetsCubit>().clearRequestSubmissionFlag();
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        if (state.isLoadingAssets && state.assets.isEmpty) {
          return const EmployeeRequestAssetFormSkeleton();
        }

        if (state.errorMessage != null && state.assets.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 36),
                  const SizedBox(height: 12),
                  Text(state.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<EmployeeAssetsCubit>().loadAssets(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select an asset',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              EmployeeAssetDropdownField(
                assets: state.assets,
                selectedAssetId: selectedAssetId,
                onChanged: (value) {
                  setState(() {
                    selectedAssetId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Request note',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              EmployeeRequestAssetNoteField(controller: noteController),
              const SizedBox(height: 16),
              CustomAppButton(
                textButton: state.isSubmittingRequest
                    ? 'Submitting...'
                    : 'Submit request',
                buttonColor: AppColors.black,
                onPressed: state.isSubmittingRequest
                    ? null
                    : () => submitRequest(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void submitRequest(BuildContext context) {
    final note = noteController.text.trim();
    if (selectedAssetId == null || selectedAssetId!.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: 'Please select an asset',
        ),
      );
      return;
    }
    if (note.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: 'Please enter a note',
        ),
      );
      return;
    }

    context.read<EmployeeAssetsCubit>().submitAssetRequest(
          employeeId: ApiConstant.employeeId,
          assetId: selectedAssetId!,
          note: note,
        );
  }
}
