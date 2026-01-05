import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';

class AddPoliceBlocListener extends StatelessWidget {
  const AddPoliceBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
      listenWhen: (previous, current) =>
          current is AddPoliceSuccess ||
          current is AddPoliceFailure ||
          current is AddPoliceLoading ||
          current is RemoveAssignPolicySuccessState,
      listener: (context, state) {
        if (state is AddPoliceSuccess) {
          context.pop();
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Police Added Successfully'.tr(context: context),
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
        } else {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
