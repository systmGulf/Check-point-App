import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import 'add_plan_bloc_listener.dart';

class AddPlanBottomSheet extends StatefulWidget {
  const AddPlanBottomSheet({super.key});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  @override
  initState() {
    super.initState();
    context.read<PlanCubit>().noteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                )),
            Text(
              'Set Plan'.tr(context: context),
              style: AppStylesManger.font16BoldBlack,
            ),
            verticalSpace(5),
            Row(
              children: [
                Align(
                        alignment: AlignmentDirectional.centerStart,
                  child: Text('Date of plan'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                context.read<PlanCubit>().planDate != '0'
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : const SizedBox(),
              ],
            ),
            verticalSpace(10),
            CustomAppTextFormField(
              validator: (va) {
                return null;
              },
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                ).then((value) {
                  if (value != null) {
                    if (!context.mounted) return;
                    context.read<PlanCubit>().planDate =
                        DateFormat('yyyy-MM-dd')
                            .format(value)
                            .toString()
                            .substring(0, 10);
                    setState(() {});
                  }
                });
              },
              readOnly: true,
              hintStyle: const TextStyle(
                color: Color(0xFF7F7F7F),
                fontSize: 14,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                height: 0.10,
                letterSpacing: 0.20,
              ),
              hint: context.read<PlanCubit>().planDate == '0'
                  ? 'choose due date...'.tr(context: context)
                  : context.read<PlanCubit>().planDate,
              suffixIcon: SizedBox(
                  height: 24,
                  width: 24,
                  child: Center(
                      child: SvgPicture.asset('assets/images/calendar.svg'))),
            ),
            verticalSpace(10),
            Align(
                alignment: AlignmentDirectional.centerStart,
              child: Text('Note'.tr(context: context),
                  style: AppStylesManger.font12RegularGrey),
            ),
            verticalSpace(10),
            CustomAppTextFormField(
                controller: context.read<PlanCubit>().noteController,
                maxLines: 3,
                hint: 'Note'.tr(context: context)),
            verticalSpace(10),
            CustomAppButton(
              onPressed: () {
                validateAndAddPlan(context);
              },
              textButton: 'Add'.tr(context: context),
              buttonColor: ColorsManger.primaryColor,
            ),
            const AddPlanBlocListener()
          ],
        ),
      ),
    );
  }

  void validateAndAddPlan(BuildContext context) {
    context.read<PlanCubit>().addPlan();
  }
}
