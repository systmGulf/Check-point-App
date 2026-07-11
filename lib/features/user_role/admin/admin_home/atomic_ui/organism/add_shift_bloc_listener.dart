import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';

class AddShiftBlocListener extends StatelessWidget {
  const AddShiftBlocListener({
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
          current is AddShiftSuccess ||
          current is EditShiftSuccess ||
          current is AddShiftError ||
          current is EditShiftError ||
          current is AddShiftLoading ||
          current is EditShiftLoading,
      listener: (context, state) {
        if (state is AddShiftSuccess) {
          context.pop();
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: addSuccessMessage,
            ),
          );
        } else if (state is EditShiftSuccess) {
          context.pop();
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: editSuccessMessage,
            ),
          );
        } else if (state is AddShiftError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is EditShiftError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else {
          customLoadingIndicator(context);
        }
      },
      child: SizedBox.shrink(),
    );
  }
}
