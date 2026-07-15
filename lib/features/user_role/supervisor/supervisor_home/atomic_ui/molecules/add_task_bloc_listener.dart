import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

class AddTaskBlocListener extends StatelessWidget {
  const AddTaskBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listenWhen: (previous, current) =>
          current is AddTaskLoading ||
          current is AddTaskError ||
          current is AddTaskSuccess,
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          Navigator.pop(context);
          Navigator.pop(context, state.createdTask);

          buildSnackBar(context,
              customSnackBar: CustomSnackBar.success(
                  message: "Task added successfully".tr()));
        } else if (state is AddTaskError) {
          Navigator.pop(context);
          buildSnackBar(context,
              customSnackBar:
                  CustomSnackBar.error(message: state.errorMessage));
        } else {
          customLoadingIndicator(context);
        }
      },
      child: Container(),
    );
  }
}
