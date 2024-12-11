import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../controller/attendence/attendence_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';

class CheckOutAuthBlocListener extends StatelessWidget {
  const CheckOutAuthBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceCubit, AttendanceState>(
      listenWhen: (previous, current) =>
          current is AttendanceOutLoading ||
          current is AttendanceOutedDone ||
          current is AttendanceOutError ||
          current is AuthenticationFailed,
      listener: (context, state) {
        if (state is AttendanceOutLoading) {
          customLoadingIndicator(context);
        }
        if (state is AttendanceOutedDone) {
          context.pop();
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Check Out Success'.tr(context: context),
            ),
          );
        }

        if (state is AttendanceOutError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
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
