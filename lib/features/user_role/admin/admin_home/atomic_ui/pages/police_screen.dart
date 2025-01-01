import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/molecules/police_item.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';

class PoliceScreen extends StatefulWidget {
  const PoliceScreen({super.key, required this.ShiftId});
  final int ShiftId;

  @override
  State<PoliceScreen> createState() => _PoliceScreenState();
}

class _PoliceScreenState extends State<PoliceScreen> {
  @override
  @override
  void initState() {
    super.initState();
    context
        .read<ShiftsAndPolicesCubit>()
        .getPoliceByShiftId(shiftId: widget.ShiftId);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Police'.tr(context: context)),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManger.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => FromToTimePicker(
                onTab: (from, to) {
                  print(
                      '${"from".tr(context: context)} ${from} ${"to".tr(context: context)} $to');
                },
                dialogBackgroundColor: Color(0xFF121212),
                fromHeadlineColor: Colors.white,
                toHeadlineColor: Colors.white,
                upIconColor: Colors.white,
                downIconColor: Colors.white,
                timeBoxColor: Color(0xFF1E1E1E),
                timeHintColor: Colors.grey,
                timeTextColor: Colors.white,
                dividerColor: Color(0xFF121212),
                doneTextColor: Colors.white,
                dismissTextColor: Colors.white,
                defaultDayNightColor: Color(0xFF1E1E1E),
                defaultDayNightTextColor: Colors.white,
                colonColor: Colors.white,
                showHeaderBullet: true,
                headerText:
                    'Select Time Range to this police'.tr(context: context),
              ),
            );
          },
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              BlocBuilder<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
                buildWhen: (previous, current) =>
                    current is GetPoliceByShiftIDLoading ||
                    current is GetPoliceByShiftIDSuccess ||
                    current is GetPoliceByShiftIDError,
                builder: (context, state) {
                  if (state is GetPoliceByShiftIDLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetPoliceByShiftIDSuccess) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.policeResponse.value!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PoliceItem(
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
                              timeOut: state.policeResponse.value!.data![index]
                                  .clockOutTime
                                  .toString()
                                  .substring(0, 5),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('No Police'),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
