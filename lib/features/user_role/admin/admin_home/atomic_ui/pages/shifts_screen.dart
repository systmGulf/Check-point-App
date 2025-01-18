import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../molecules/get_shifts_bloc_builder.dart';
import '../organism/add_shifts_bottom_sheet.dart';

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(text: 'Add Shift'.tr(context: context), onTap: (){
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (BuildContext cnx) {
              return BlocProvider.value(
                value: context.read<ShiftsAndPolicesCubit>(),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: AddShiftBottomSheet(),
                ),
              );
            },
          );
      }),
      appBar: buildCustomAppBar(context, 'Shifts'.tr(context: context)),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: GetShiftsBlocBuilder()),
    );
  }
}
