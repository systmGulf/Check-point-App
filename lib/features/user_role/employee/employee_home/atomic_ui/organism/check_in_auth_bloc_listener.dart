import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controller/attendence/attendence_cubit.dart';

class CheckInAuthBlocListener extends StatelessWidget {
  const CheckInAuthBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceCubit, AttendanceState>(
      listenWhen: (previous, current) =>
          current is AttendanceIneLoading ||
          current is AttendanceInError ||
          current is AttendanceIneDone ||
          current is AuthenticationFailed,
      listener: (context, state) {
        if (state is AttendanceInError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        }
        if (state is AttendanceIneLoading) {
          customLoadingIndicator(context);
        }

        if (state is AttendanceIneDone) {
          context.pop();
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Check In Success'.tr(context: context),
            ),
          );
        } else if (state is AuthenticationFailed) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: 'Authentication Failed'.tr(context: context),
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
