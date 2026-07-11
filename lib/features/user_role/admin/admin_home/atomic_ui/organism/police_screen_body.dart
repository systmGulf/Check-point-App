import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/error_widget.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/colors.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../molecules/build_add_police_time_dialog.dart';
import '../molecules/police_item.dart';
import 'add_police_bloc_listener.dart';

class PoliceScreenBody extends StatelessWidget {
  const PoliceScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ListView(
        children: [
          BlocBuilder<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
            buildWhen: (previous, current) =>
                current is GetPoliceByShiftIDLoading ||
                current is GetPoliceByShiftIDSuccess ||
                current is GetPoliceByShiftIDError,
            builder: (context, state) {
              if (state is GetPoliceByShiftIDLoading) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.5,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorsManger.primaryColor,
                      strokeWidth: 2,
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              } else if (state is GetPoliceByShiftIDSuccess) {
                return state.policeResponse.value!.data!.isEmpty
                    ? NoDataFound()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.policeResponse.value!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInUp(
                              child: PoliceItem(
                                employees: state.policeResponse.value!
                                        .data![index].employees ??
                                    [],
                                policeId: state.policeResponse.value!
                                        .data![index].id ??
                                    00,
                                year: state
                                    .policeResponse.value!.data![index].year
                                    .toString(),
                                month: state
                                    .policeResponse.value!.data![index].month
                                    .toString(),
                                timeIn: state.policeResponse.value!.data![index]
                                    .clockInTime
                                    .toString()
                                    .substring(0, 5),
                                timeOut: state.policeResponse.value!
                                    .data![index].clockOutTime
                                    .toString()
                                    .substring(0, 5),
                                onDeleteEmployee: (employeeId) {
                                  context
                                      .read<ShiftsAndPolicesCubit>()
                                      .removeAssignPolicy(
                                        policeId: state.policeResponse.value
                                                ?.data?[index].id ??
                                            0,
                                        employeeId: employeeId,
                                      );
                                },
                                onEdit: () {
                                  buildAddPoliceTimeDialog(
                                    context,
                                    policeId: state
                                        .policeResponse.value!.data![index].id,
                                    initialMonth: state.policeResponse.value!
                                        .data![index].month
                                        ?.toString(),
                                    initialYear: state
                                        .policeResponse.value!.data![index].year
                                        ?.toString(),
                                    initialClockInTime: state.policeResponse
                                        .value!.data![index].clockInTime,
                                    initialClockOutTime: state.policeResponse
                                        .value!.data![index].clockOutTime,
                                  );
                                },
                              ),
                            ),
                          );
                        });
              } else if (state is GetPoliceByShiftIDError) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: CustomErrorWidget(
                    onRetry: () => context
                        .read<ShiftsAndPolicesCubit>()
                        .getPoliceByShiftId(shiftId: 1, isLoading: true),
                    error: state.error,
                  ),
                );
              } else {
                return NoDataFound();
              }
            },
          ),
          AddPoliceBlocListener(
            addSuccessMessage: 'Police Added Successfully'.tr(context: context),
            editSuccessMessage:
                'Police Updated Successfully'.tr(context: context),
          ),
        ],
      ),
    );
  }
}
