import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';

class DeleteTaskBlocListener extends StatelessWidget {
  const DeleteTaskBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeTasksCubit, EmployeeTasksState>(
        listenWhen: (previous, current) =>
            current is DeleteEmployeeTaskError ||
            current is DeleteEmployeeTaskLoading ||
            current is DeleteEmployeeTaskSuccess,
        listener: (context, state) {
          if (state is DeleteEmployeeTaskSuccess) {
            buildSnackBar(context,
                customSnackBar: CustomSnackBar.success(
                    message: "Task deleted successfully".tr(context: context)));
          } else if (state is DeleteEmployeeTaskError) {
               
            buildSnackBar(context,
                customSnackBar:
                    CustomSnackBar.error(message: state.error));
          }  else  if (state is DeleteEmployeeTaskLoading) {
            

            // customLoadingIndicator(context);
          } 
        },
        child: SizedBox.shrink()
    );
  }
}