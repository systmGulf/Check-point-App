
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controller/attendence/attendence_cubit.dart';

class PlanFeedBackBottomSheet extends StatelessWidget {
  const PlanFeedBackBottomSheet({super.key, required this.customerplanId});
  final int customerplanId;

  @override
  Widget build(BuildContext context) {
    String? image = '';
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
                          context.read<AttendanceCubit>().doPickImage();
                        },
                      ),
                    );
                  }
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
                              .addPlanFeedback(CustomerId: customerplanId)
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
