import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/molecules/map_dialog.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';
import 'add_branch_bloc_listener.dart';

class AddBranchBottomSheet extends StatefulWidget {
  const AddBranchBottomSheet({super.key});

  @override
  State<AddBranchBottomSheet> createState() => _AddBranchBottomSheetState();
}

class _AddBranchBottomSheetState extends State<AddBranchBottomSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    BlocProvider.of<BranchCubit>(context).nameController =
        TextEditingController();

    BlocProvider.of<BranchCubit>(context).locationController =
        TextEditingController();

    BlocProvider.of<BranchCubit>(context).descriptionController =
        TextEditingController();
    BlocProvider.of<BranchCubit>(context).locationFrame.clear();
    super.initState();
  }

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
                      if (value!.isEmpty) {
                        return 'Branch Name Required'.tr(context: context);
                      }
                      return null;
                    },
                    controller:
                        BlocProvider.of<BranchCubit>(context).nameController,
                    hint: 'Branch Name'.tr(context: context)),
                verticalSpace(20),
                CustomAppTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Branch Description Required'
                            .tr(context: context);
                      }
                      return null;
                    },
                    controller: BlocProvider.of<BranchCubit>(context)
                        .descriptionController,
                    hint: 'Branch Description'.tr(context: context)),
                verticalSpace(20),
                CustomAppTextFormField(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: false,
                      context: context,
                      builder: (builder) {
                        return BlocProvider.value(
                          value: BlocProvider.of<BranchCubit>(context),
                          child: const MapDialog(),
                        );
                      },
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  readOnly: true,
                  suffixIcon: const Icon(Icons.location_on),
                  controller: TextEditingController(),
                  hint: BlocProvider.of<BranchCubit>(context)
                              .locationController
                              .text ==
                          ''
                      ? 'Select Branch Location'.tr(context: context)
                      : 'Branch Location Defined'.tr(context: context),
                ),
                verticalSpace(20),
                CustomAppTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Branch Location Required'.tr(context: context);
                      }
                      return null;
                    },
                    controller: BlocProvider.of<BranchCubit>(context)
                        .locationController,
                    hint: 'Branch Location'.tr(context: context)),
                verticalSpace(20),
                CustomAppButton(
                  buttonColor: ColorsManger.primaryColor,
                  textButton: 'Save'.tr(context: context),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (BlocProvider.of<BranchCubit>(context)
                              .locationFrame
                              .isEmpty ||
                          BlocProvider.of<BranchCubit>(context)
                                  .locationFrame
                                  .length <
                              2) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.info(
                            message: 'Please Select Right Location'
                                .tr(context: context),
                          ),
                        );
                      } else {
                        BlocProvider.of<BranchCubit>(context).addBranch();
                      }
                    }
                  },
                ),
                verticalSpace(20),
                const AddBranchBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
