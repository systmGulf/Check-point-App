import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/get_plan_by_employee_id_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../controller/attendence/attendence_cubit.dart';
import 'plan_feed_back_bloc_listener.dart';

class CheckOutBlocBuilder extends StatelessWidget {
  const CheckOutBlocBuilder(
      {super.key, required this.area, required this.customerPlans});
  final String area;
  final Data customerPlans;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
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
                if (area == "Office") {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    context.read<AttendanceCubit>().attend(
                          typeAttendance: 'check_out',
                          area: 'Office',
                        );
                  });
                } else {
                  print(
                      'Customer id For this plan is===================>${customerPlans.id}');
                  customerPlans.id != null
                      ? showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<AttendanceCubit>(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: PlanFeedBackBottomSheet(
                                  customerplanId: customerPlans.id ?? 00,
                                ),
                              ),
                            );
                          })
                      : buildSnackBar(context,
                          customSnackBar: CustomSnackBar.success(
                              message:
                                  "Tap on Customer to give feedback Please!👆"
                                      .tr(context: context)));
                }
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
