import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../controllers/department_cubit/department_cubit.dart';

class EditDepartmentDialog extends StatefulWidget {
  const EditDepartmentDialog({
    super.key,
    required this.departmentId,
  });

  final int departmentId;

  @override
  State<EditDepartmentDialog> createState() => _EditDepartmentDialogState();
}

class _EditDepartmentDialogState extends State<EditDepartmentDialog> {
  @override
  void initState() {
    super.initState();
    context.read<DepartmentCubit>().editDepartmentNameController =
        TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Department'.tr(),
              style: AppStylesManger.font16BoldBlack,
            ),
            verticalSpace(20),
            TextField(
              controller:
                  context.read<DepartmentCubit>().editDepartmentNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Department Name'.tr(),
              ),
            ),
            verticalSpace(20),
            CustomAppButton(
              textButton: 'Edit'.tr(),
              buttonColor: ColorsManger.primaryColor,
              onPressed: () {
                context
                    .read<DepartmentCubit>()
                    .editDepartment(widget.departmentId);
              },
            ),
          ],
        ));
  }
}
