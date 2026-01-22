import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/get_plan_by_employee_id_model.dart';

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';
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
  GoogleMapController? _googleMapController;

  @override
  void initState() {
   
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  Data? customerPlans;
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
              : BlocBuilder<AttendanceCubit, AttendanceState>(
                  buildWhen: (previous, current) =>
                      current is GetCustomerAreaDone ||
                      current is GetCustomerAreaError ||
                      current is GetCustomerAreaLoading,
                  builder: (context, state) {
                    if (state is GetCustomerAreaDone) {
                      final today =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());

                      final matchingAreas =
                          state.customerArea.value!.data!.where((area) {
                        final planDate = DateFormat('yyyy-MM-dd').format(
                          area.plan!.planDate!,
                        );
                        return planDate == today;
                      }).toList();

                      if (matchingAreas.isNotEmpty) {
                        // log(matchingAreas[0].planDate.toString());
                        // BlocProvider.of<AttendanceCubit>(context)
                        //     .getPlanById(id: matchingAreas[0].id!);

                        return widget.checkType == "Customer"
                            ? CustomerMapScreen(
                                oncustomerChanged: (customer) {
                                  setState(() {
                                    customerPlans = customer;
                                  });
                                },
                                attendanceType: widget.attendanceType,
                              )
                            : SiteMapScreen(
                                attendanceType: widget.attendanceType,
                              );
                      }
                    }

                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: AnimatedByWidgetType(
                          widgetType: WidgetAnimationType.text,
                          child: Text(
                            'You Do Not Have ${widget.checkType} Plans'
                                .tr(context: context),
                            style: AppStylesManger.font15BoldRed.copyWith(
                              color: ColorsManger.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        AttendanceMapBottomSheet(
            customerPlans: customerPlans ?? Data(),
            area: widget.checkType,
            attendanceType: widget.attendanceType,
            widget: widget.checkType),
        CustomCheckingScreenAppBar(
          text: 'Check Out'.tr(context: context),
        ),
        const CheckOutAuthBlocListener(),
      ],
    );
  }
}
