import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/core/widgets/custom_app_text_form_field.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_date_picker_model_sheet.dart';
import 'package:flutter/material.dart';

class CustomFilterAssetsRequests extends StatefulWidget {
  const CustomFilterAssetsRequests({super.key});

  @override
  State<CustomFilterAssetsRequests> createState() =>
      _CustomFilterAssetsRequestsState();
}

class _CustomFilterAssetsRequestsState
    extends State<CustomFilterAssetsRequests> {
  DateTime? selectedDate;

  void _openDatePicker(BuildContext context) async {
    final pickedDate = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return CustomDatePickerModelSheet(selectedDate: selectedDate);
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              Text("Filter", style: AppStylesManger.font16BoldBlack),
              const Spacer(),
              InkWell(
                onTap: () => context.pop(),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          Text(
            "Date".tr(context: context),
            style: AppStylesManger.font16BoldBlack,
          ),
          verticalSpace(8),
          GestureDetector(
            onTap: () => _openDatePicker(context),
            child: CustomAppTextFormField(
              readOnly: true,
              hint: selectedDate == null
                  ? "Pick a date".tr(context: context)
                  : DateFormat(
                      tr('yyyy-MM-dd', context: context),
                      context.locale.toString(),
                    ).format(selectedDate!),
              prefixIcon: GestureDetector(
                onTap: () => _openDatePicker(context),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: ColorsManger.primaryColorLight,
                ),
              ),
            ),
          ),
          verticalSpace(16),
          Row(
            spacing: 8,
            children: [
              Flexible(
                child: CustomAppButton(
                  textButton: "Clear All".tr(context: context),
                  buttonColor: Colors.white,
                  // borderColor: ColorsManger.lightPrimaryColor,
                  // textColor: ColorsManger.lightPrimaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                child: CustomAppButton(
                  textButton: "Submit".tr(context: context),
                  buttonColor: ColorsManger.primaryColorLight,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          verticalSpace(30),
        ],
      ),
    );
  }
}
