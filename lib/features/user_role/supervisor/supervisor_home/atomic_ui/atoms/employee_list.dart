import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../molecules/supervisor_get_all_employees_bloc_builder.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomAppTextFormField(
            onChanged: (value) {
              setState(() {
                query = value;
                log("query: $query");
              });
            },
            hint: "Search employee...".tr(context: context),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                Assets.SearchIconImage,
                height: 20,
                width: 20,
              ),
            ),
          ),
        ),
        verticalSpace(16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              horizontalSpace(MediaQuery.of(context).size.width * 0.05),
              Text(
                'Name'.tr(context: context),
                style: AppStylesManger.font16BoldBlack.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'attend'.tr(context: context),
                style: AppStylesManger.font16BoldBlack.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              horizontalSpace(MediaQuery.of(context).size.width * 0.03),
              Text(
                'Preview'.tr(context: context),
                style: AppStylesManger.font16BoldBlack.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              horizontalSpace(MediaQuery.of(context).size.width * 0.03),
            ],
          ),
        ),
        SupervisorGetAllEmployeesBlocBuilder(
          query: query,
        ),
      ],
    );
  }
}
