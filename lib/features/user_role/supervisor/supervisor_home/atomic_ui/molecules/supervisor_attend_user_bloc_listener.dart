import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';

class SupervisorAttendUserBlocListener extends StatelessWidget {
  const SupervisorAttendUserBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetEmployeesDataCubit, GetEmployeesDataState>(
        listenWhen: (_, current) =>
            current is SupervisorAttendSomeEmployeeSuccess ||
            current is SupervisorAttendSomeEmployeeFailure ||
            current is SupervisorAttendSomeEmployeeLoading,
        listener: (context, state) {
          if (state is SupervisorAttendSomeEmployeeSuccess) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                  message: state.successMsg.tr(context: context)
                  // backgroundColor: Colors.red,
                  ),
            );
          } else if (state is SupervisorAttendSomeEmployeeFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.errorMsg.tr(context: context),
                // backgroundColor: Colors.red,
              ),
            );
          } else {
            customLoadingIndicator(context);
          }
        },
        child: const SizedBox.shrink());
  }
}
