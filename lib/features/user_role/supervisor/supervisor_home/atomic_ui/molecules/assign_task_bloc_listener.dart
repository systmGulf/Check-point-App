import 'package:easy_localization/easy_localization.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';

class AssignTaskBlocListener extends StatelessWidget {
  const AssignTaskBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listenWhen: (previous, current) =>
          current is AssignTaskLoading ||
          current is AssignTaskError ||
          current is AssignTaskSuccess,
      listener: (context, state) {
        if (state is AssignTaskSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Task assigned successfully".tr(context: context),
            ),
          );
        } else if (state is AssignTaskError) {
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.errorMessage,
            ),
          );
        } else {
          customLoadingIndicator(context);
        }
      },
      child: Container(),
    );
  }
}
