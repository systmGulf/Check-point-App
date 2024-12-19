import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import 'add_shift_bloc_listener.dart';

class AddShiftBottomSheet extends StatefulWidget {
  const AddShiftBottomSheet({super.key});

  @override
  State<AddShiftBottomSheet> createState() => _AddShiftBottomSheetState();
}

class _AddShiftBottomSheetState extends State<AddShiftBottomSheet> {
  late TextEditingController shiftNameController;
  @override
  initState() {
    super.initState();
    shiftNameController =
        context.read<ShiftsAndPolicesCubit>().shiftNameController;
  }

  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(children: [
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                )),
            verticalSpace(20.h),
            CustomAppTextFormField(
                controller: shiftNameController,
                hint: 'Shift Name'.tr(context: context)),
            verticalSpace(20.h),
            CustomAppButton(
              textButton: 'Add Shift'.tr(context: context),
              buttonColor: ColorsManger.primaryColor,
              onPressed: () {
                context.read<ShiftsAndPolicesCubit>().addShift();
              },
            ),
            AddShiftBlocListener()
          ])),
    );
  }
}
