import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';

class AddPoliceBlocListener extends StatelessWidget {
  const AddPoliceBlocListener({
    super.key,
    required this.addSuccessMessage,
    required this.editSuccessMessage,
  });

  final String addSuccessMessage;
  final String editSuccessMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
      listenWhen: (previous, current) =>
          current is AddPoliceSuccess ||
          current is EditPoliceSuccess ||
          current is AddPoliceFailure ||
          current is EditPoliceFailure ||
          current is AddPoliceLoading ||
          current is EditPoliceLoading ||
          current is RemoveAssignPolicySuccessState ||
          current is AssignPoliceError ||
          current is DeletePoliceError,
      listener: (context, state) {
        if (state is DeletePoliceError) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
          context.pop();
        }
        if (state is AssignPoliceError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        }
        if (state is AddPoliceSuccess) {
          context.pop();
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: addSuccessMessage,
            ),
          );
        }
        if (state is EditPoliceSuccess) {
          context.pop();
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: editSuccessMessage,
            ),
          );
        }
        if (state is RemoveAssignPolicySuccessState) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: state.message,
            ),
          );
        } else if (state is AddPoliceFailure) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is EditPoliceFailure) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is AddPoliceLoading || state is EditPoliceLoading) {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
