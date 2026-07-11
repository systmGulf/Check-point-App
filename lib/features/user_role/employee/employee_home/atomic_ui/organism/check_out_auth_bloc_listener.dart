import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controller/attendence/attendence_cubit.dart';

class CheckOutAuthBlocListener extends StatelessWidget {
  const CheckOutAuthBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceCubit, AttendanceState>(
      listenWhen: (previous, current) =>
          current is AttendanceOutLoading ||
          current is AttendanceOutedDone ||
          current is AttendanceOutError ||
          current is NoShiftAssigned,
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
              message: 'Check Out Success'.tr(),
            ),
          );
          FlutterBackgroundService().invoke('stop');
        }

        if (state is AttendanceOutError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is NoShiftAssigned) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message:
                  'No shift is assigned to this employee yet. Please contact your admin.'
                      .tr(),
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
