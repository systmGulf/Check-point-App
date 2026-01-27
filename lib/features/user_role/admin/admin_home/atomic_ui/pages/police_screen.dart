import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../molecules/build_add_police_time_dialog.dart';
import '../organism/police_screen_body.dart';

class PoliceScreen extends StatefulWidget {
  const PoliceScreen({super.key, required this.ShiftId});
  final int ShiftId;

  @override
  State<PoliceScreen> createState() => _PoliceScreenState();
}

class _PoliceScreenState extends State<PoliceScreen> {
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
        floatingActionButton: CustomFloatingActionButton(
            text: 'Add Police'.tr(context: context),
            onTap: () {
              buildAddPoliceTimeDialog(context);
            }),
        body: PoliceScreenBody());
  }
}
