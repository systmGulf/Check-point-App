import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

import '../../../../../../core/styles/colors.dart';
import '../../controller/attendence/attendence_cubit.dart';

class CheckOutBlocBuilder extends StatelessWidget {
  const CheckOutBlocBuilder({super.key, required this.area});
  final String area;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      buildWhen: (previous, current) =>
          current is AttendanceIneDone ||
          current is AttendanceOutedDone ||
          current is AttendanceIneLoading ||
          current is AttendanceOutLoading ||
          current is AuthenticationInitial,
      builder: (context, state) {
        bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
        return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SwipeButton.expand(
              height: 60.h,
              thumb: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(isRtl ? 3.14 : 0),
                child: const Icon(
                  Icons.double_arrow_rounded,
                  color: Colors.white,
                ),
              ),
              activeThumbColor: ColorsManger.primaryColor,
              activeTrackColor: Colors.grey.shade300,
              onSwipe: () {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  context.read<AttendanceCubit>().attend(
                        typeAttendance: 'check_out',
                        area: area,
                      );
                });
              },
              child: Text(
                "Swipe to Check out".tr(
                  context: context,
                ),
                style: TextStyle(
                  color: ColorsManger.primaryColor,
                ),
              ),
            ));
      },
    );
  }
}
