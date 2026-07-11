import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssignPoliceToEmployeesLoadingSkeleton extends StatelessWidget {
  const AssignPoliceToEmployeesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CustomAppButton(
        buttonColor: ColorsManger.primaryColor,
        textButton: 'Add'.tr(),
        onPressed: () {},
      ),
    );
  }
}
