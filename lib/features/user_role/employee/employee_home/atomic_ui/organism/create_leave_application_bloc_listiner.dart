import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controller/leave_application/leave_application_cubit.dart';

class CreateLeaveApplicationBlocListener extends StatelessWidget {
  const CreateLeaveApplicationBlocListener(
      {super.key, required this.requestType});
  final String requestType;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveApplicationCubit, LeaveApplicationState>(
      listenWhen: (state, current) =>
          current is AddLeaveApplicationSuccess ||
          current is AddLeaveApplicationFailure ||
          current is AddLeaveApplicationLoading,
      listener: (context, state) {
        if (state is AddLeaveApplicationSuccess) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Request submited successfully".tr(context: context),
            ),
          );
        } else if (state is AddLeaveApplicationFailure) {
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
