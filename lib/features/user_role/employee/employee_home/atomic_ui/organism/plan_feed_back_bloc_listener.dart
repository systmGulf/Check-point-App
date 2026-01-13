import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/common/image_picker_base_64.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../core/widgets/pick_image_from_gallary_or_camera_widget.dart';
import '../../controller/attendence/attendence_cubit.dart';

class PlanFeedBackBottomSheet extends StatefulWidget {
  const PlanFeedBackBottomSheet({super.key, required this.customerplanId});
  final int customerplanId;

  @override
  State<PlanFeedBackBottomSheet> createState() =>
      _PlanFeedBackBottomSheetState();
}

class _PlanFeedBackBottomSheetState extends State<PlanFeedBackBottomSheet> {
  initState() {
    context.read<AttendanceCubit>().getFeedBackStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              BlocBuilder<AttendanceCubit, AttendanceState>(
                buildWhen: (previous, current) =>
                    current is PickImageSuccess || current is PickImageLoading,
                builder: (context, state) {
                  if (state is PickImageLoading) {
                    return Skeletonizer(
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(
                                color: ColorsManger.primaryColor, width: 1),
                          ),
                          title: Text(
                            'Pick Image Done'.tr(
                              context: context,
                            ),
                            style: AppStylesManger.font16BoldBlack,
                          ),
                          leading: const Icon(Icons.check),
                          onTap: () async {},
                        ),
                      ),
                    );
                  } else if (state is PickImageSuccess) {
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                              color: ColorsManger.primaryColor, width: 1),
                        ),
                        title: Text(
                          'Pick Image Done'.tr(
                            context: context,
                          ),
                          style: AppStylesManger.font16BoldBlack,
                        ),
                        leading: const Icon(Icons.check),
                        onTap: () async {},
                      ),
                    );
                  } else {
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                              color: ColorsManger.primaryColor, width: 1),
                        ),
                        title: Text(
                          'Pick Image'.tr(
                            context: context,
                          ),
                          style: AppStylesManger.font16BoldBlack,
                        ),
                        leading: const Icon(Icons.image),
                        onTap: () async {
                          selectImageDialog(
                              context: context,
                              SelectedGalleryAction: () async {
                                await context
                                    .read<AttendanceCubit>()
                                    .doPickImage(
                                      source: ImagePickSource.gallery,
                                    )
                                    .then((value) {
                                  context.pop();
                                });
                              },
                              SelectedCameraAction: () async {
                                await context
                                    .read<AttendanceCubit>()
                                    .doPickImage(
                                      source: ImagePickSource.camera,
                                    )
                                    .then((value) {
                                  context.pop();
                                });
                              });
                        },
                      ),
                    );
                  }
                },
              ),
              BlocBuilder<AttendanceCubit, AttendanceState>(
                buildWhen: (previous, current) {
                  return current is GetFeedBackStatusSuccessState ||
                      current is GetFeedBackStatusLoadingState ||
                      current is GetFeedBackStatusFailureState;
                },
                builder: (context, state) {
                  return switch (state) {
                    GetFeedBackStatusLoadingState() => Center(
                        child: CircularProgressIndicator(),
                      ),
                    GetFeedBackStatusSuccessState(:final status) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: Colors.red,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: Center(
                          child: DropdownButton(
                              isExpanded: true,
                              underline: const SizedBox(),
                              iconDisabledColor: ColorsManger.primaryColor,
                              icon: const Icon(Icons.arrow_drop_down),
                              style: AppStylesManger.font16BoldBlack,
                              borderRadius: BorderRadius.circular(4.r),
                              dropdownColor: Colors.white,
                              elevation: 0,
                              iconSize: 30.sp,
                              focusColor: ColorsManger.primaryColor,
                              hint: Text(
                                  'Select Feedback Type'.tr(context: context)),
                              items: status
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style:
                                              AppStylesManger.font16BoldBlack,
                                        ),
                                      ))
                                  .toList(),
                              value: context.read<AttendanceCubit>().planStatus,
                              selectedItemBuilder: (context) => status
                                  .map((e) => Text(
                                        e,
                                        style: AppStylesManger.font16BoldBlack,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                context.read<AttendanceCubit>().planStatus =
                                    value.toString();
                                setState(() {});
                              }),
                        ),
                      ),
                    GetFeedBackStatusFailureState(:final error) => Text(error),
                    _ => Container(),
                  };
                },
              ),
              verticalSpace(20),
              CustomAppTextFormField(
                controller:
                    context.read<AttendanceCubit>().planFeedbackController,
                hint: 'Feedback'.tr(context: context),
                maxLines: 5,
              ),
              verticalSpace(20),
              BlocBuilder<AttendanceCubit, AttendanceState>(
                  buildWhen: (previous, current) =>
                      current is AddPlanFeedbackLoading ||
                      current is AddPlanFeedbackError ||
                      current is AddPlanFeedbackDone,
                  builder: (context, state) {
                    if (state is AddPlanFeedbackLoading) {
                      return Skeletonizer(
                        child: CustomAppButton(
                          textButton: 'Submit'.tr(context: context),
                          buttonColor: ColorsManger.primaryColor,
                          onPressed: () {},
                        ),
                      );
                    } else {
                      return CustomAppButton(
                        textButton: 'Submit'.tr(context: context),
                        buttonColor: ColorsManger.primaryColor,
                        onPressed: () {
                          context
                              .read<AttendanceCubit>()
                              .addPlanFeedback(
                                  CustomerId: widget.customerplanId)
                              .then((value) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              context.read<AttendanceCubit>().attend(
                                    typeAttendance: 'check_out',
                                    area: 'Office',
                                  );
                            });
                            context
                                .read<AttendanceCubit>()
                                .planFeedbackController
                                .clear();
                          });
                        },
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
