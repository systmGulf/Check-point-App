import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../molecules/edit_department_dialog.dart';

class DepartmentItem extends StatelessWidget {
  const DepartmentItem({
    super.key,
    required this.departmentName,
    this.onTap,
    required this.departmentId,
  });
  final String departmentName;
  final int departmentId;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: AppConatinerDecoration(),
        child: Row(
          children: [
            Text(
              departmentName,
              style: AppStylesManger.font16BoldBlack,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                buildDeleteAlertDialog(context,
                    title: 'Delete Department'.tr(context: context),
                    message: 'Are you sure you want to delete this department?'
                        .tr(context: context), onYes: () {
                  context.pop();
                  context
                      .read<DepartmentCubit>()
                      .deleteDepartment(departmentId);
                });
              },
              icon: SizedBox(
                  height: 24,
                  width: 24,
                  child: Center(
                      child:
                          SvgPicture.asset('assets/images/delete_icon.svg'))),
              color: Colors.red,
            ),
            horizontalSpace(10),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                      child: BlocProvider.value(
                          value: context.read<DepartmentCubit>(),
                          child: EditDepartmentDialog(
                              departmentId: departmentId))),
                );
              },
              icon: SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/edit.svg',
                    color: ColorsManger.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
