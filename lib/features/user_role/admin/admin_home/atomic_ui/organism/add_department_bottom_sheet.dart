import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import 'add_department_bloc_listener.dart';

class AddDepartmentBottomSheet extends StatefulWidget {
  const AddDepartmentBottomSheet({super.key});

  @override
  State<AddDepartmentBottomSheet> createState() =>
      _AddDepartmentBottomSheetState();
}

class _AddDepartmentBottomSheetState extends State<AddDepartmentBottomSheet> {
  @override
  void initState() {
    BlocProvider.of<DepartmentCubit>(context).addDepartmentController =
        TextEditingController();
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: IntrinsicHeight(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              children: [
                CustomAppTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Department Name'
                            .tr(context: context);
                      }
                      return null;
                    },
                    controller: BlocProvider.of<DepartmentCubit>(context)
                        .addDepartmentController,
                    hint: 'Department Name'.tr(context: context)),
                verticalSpace(20),
                CustomAppButton(
                  buttonColor: ColorsManger.primaryColor,
                  textButton: 'Save'.tr(context: context),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<DepartmentCubit>(context).addDepartment();
                    }
                  },
                ),
                const AddDepartmentBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
