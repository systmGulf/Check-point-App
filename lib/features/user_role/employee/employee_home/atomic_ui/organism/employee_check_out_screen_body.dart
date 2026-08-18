import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/enums/attendance_type_enum.dart';
import '../molecules/custom_checking_screen_app_bar.dart';
import 'attendance_map_bottom_sheet.dart';
import 'check_out_auth_bloc_listener.dart';
import 'customer_map_screen.dart';
import 'office_map_screen.dart';
import 'site_map_screen.dart';

class EmployeeCheckOutScreenBody extends StatefulWidget {
  const EmployeeCheckOutScreenBody({
    super.key,
    required this.checkType,
    required this.attendanceType,
  });
  final AttendanceTypeEnum attendanceType;
  final String checkType;

  @override
  State<EmployeeCheckOutScreenBody> createState() =>
      _EmployeeCheckOutScreenBodyState();
}

class _EmployeeCheckOutScreenBodyState
    extends State<EmployeeCheckOutScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedByWidgetType(
          widgetType: WidgetAnimationType.container,
          child: widget.checkType == "Office"
              ? OfficeMapScreen(
                  attendanceType: widget.attendanceType,
                )
              : widget.checkType == "Customer"
                  ? CustomerMapScreen(
                      attendanceType: widget.attendanceType,
                    )
                  : SiteMapScreen(
                      attendanceType: widget.attendanceType,
                    ),
        ),
        AttendanceMapBottomSheet(
            area: widget.checkType,
            attendanceType: widget.attendanceType,
            widget: widget.checkType),
        CustomCheckingScreenAppBar(
          text: 'Check Out'.tr(),
          onGpsPressed: () {
            if (widget.checkType == "Office") {
              context.read<AttendanceCubit>().getUserBranch();
            } else {
              context.read<AttendanceCubit>().loadTrackingStatus();
            }
          },
        ),
        const CheckOutAuthBlocListener(),
      ],
    );
  }
}
