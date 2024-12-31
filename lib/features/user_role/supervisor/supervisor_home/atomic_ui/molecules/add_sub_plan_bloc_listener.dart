import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';

class AddPlanSubBlocListener extends StatelessWidget {
  const AddPlanSubBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanCubit, PlanState>(
      listenWhen: (previous, current) =>
          current is SetSubPlanError ||
          current is SetSubPlanLoading ||
          current is SetSubPlanSuccess,
      listener: (context, state) {
        if (state is SetSubPlanError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is SetSubPlanSuccess) {
          context.pop();
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Sub plan added successfully".tr(context: context),
            ),
          );
        } else if (state is SetSubPlanLoading) {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
