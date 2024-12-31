import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';

class AddPlanBlocListener extends StatelessWidget {
  const AddPlanBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanCubit, PlanState>(
      listenWhen: (previous, current) =>
          current is AddPlanLoading ||
          current is AddPlanError ||
          current is AddPlanSuccess ||
          current is DeletePlanSuccess ||
          current is DeletePlanError,
      listener: (context, state) {
        if (state is AddPlanError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is AddPlanSuccess) {
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Plan added successfully".tr(context: context),
            ),
          );
        } else if (state is DeletePlanError) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is DeletePlanSuccess) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Plan deleted successfully".tr(context: context),
            ),
          );
        } else if (state is AddPlanLoading) {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
