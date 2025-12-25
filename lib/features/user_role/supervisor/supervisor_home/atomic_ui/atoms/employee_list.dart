import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../molecules/supervisor_get_all_employees_bloc_builder.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              
              horizontalSpace(MediaQuery.of(context).size.width * 0.05),
              Text('Name'.tr(context: context),
                  style: AppStylesManger.font18RegulerBlack),
              const Spacer(),
              Text('attend'.tr(context: context),
                  style: AppStylesManger.font11clamgrey400weight.copyWith(
                    color: ColorsManger.primaryColor,
                  )),
              horizontalSpace(MediaQuery.of(context).size.width * 0.03),
              Text('Preview'.tr(context: context),
                  style: AppStylesManger.font11clamgrey400weight.copyWith(
                    color: ColorsManger.primaryColor,
                  )),
              horizontalSpace(MediaQuery.of(context).size.width * 0.03),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: ColorsManger.primaryColor,
        ),
        const SupervisorGetAllEmployeesBlocBuilder(),
      ],
    );
  }
}
