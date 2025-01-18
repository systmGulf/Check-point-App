import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';

import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../organism/police_screen_body.dart';

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
        .getPoliceByShiftId(shiftId: widget.ShiftId, isLoading: true);
        context.read<ShiftsAndPolicesCubit>().shiftId = widget.ShiftId;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Police'.tr(context: context)),
        floatingActionButton: CustomFloatingActionButton(text: 'Add Police'.tr(context: context), onTap: (){
           showDialog(
              context: context,
              builder: (_) => FromToTimePicker(
                onTab: (from, to) {
                  log("${from.hour}:${from.minute} ${from.period.name}");
                  context.read<ShiftsAndPolicesCubit>().year = DateTime.now().year.toString();
                  context.read<ShiftsAndPolicesCubit>().mounth = DateTime.now().month.toString();
                  context.read<ShiftsAndPolicesCubit>().clockInTime ="${from.hour.toString().padLeft(2, '0')}:${from.minute}0:00";
                  context.read<ShiftsAndPolicesCubit>().clockOutTime ="${to.hour.toString().padLeft(2, '0')}:${to.minute}0:00";
                  context
                      .read<ShiftsAndPolicesCubit>()
                      .addPolice();
                  Navigator.pop(context);
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
        }),
        body:PoliceScreenBody ()
        );
  }
}
