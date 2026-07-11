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
  const AddShiftBottomSheet({
    super.key,
    this.shiftId,
    this.initialName,
  });

  final int? shiftId;
  final String? initialName;

  bool get isEdit => shiftId != null;

  @override
  State<AddShiftBottomSheet> createState() => _AddShiftBottomSheetState();
}

class _AddShiftBottomSheetState extends State<AddShiftBottomSheet> {
  @override
  initState() {
    super.initState();
    final cubit = context.read<ShiftsAndPolicesCubit>();
    cubit.shiftNameController.text = widget.initialName ?? '';
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          child: Form(
            key: formKey,
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
              Text(
                widget.isEdit
                    ? 'Edit Shift'.tr()
                    : 'Add Shift'.tr(),
              ),
              verticalSpace(20.h),
              CustomAppTextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Shift Name Required'.tr();
                    }
                    return null;
                  },
                  controller:
                      context.read<ShiftsAndPolicesCubit>().shiftNameController,
                  hint: 'Shift Name'.tr()),
              verticalSpace(20.h),
              CustomAppButton(
                textButton: widget.isEdit
                    ? 'Save'.tr()
                    : 'Add Shift'.tr(),
                buttonColor: ColorsManger.primaryColor,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (widget.isEdit) {
                      context
                          .read<ShiftsAndPolicesCubit>()
                          .editShift(id: widget.shiftId!);
                    } else {
                      context.read<ShiftsAndPolicesCubit>().addShift();
                    }
                  }
                },
              ),
              AddShiftBlocListener(
                addSuccessMessage:
                    'Shift Added Successfully'.tr(),
                editSuccessMessage:
                    'Shift Updated Successfully'.tr(),
              )
            ]),
          )),
    );
  }
}
