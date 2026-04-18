import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controller/leave_application/leave_application_cubit.dart';
import '../atoms/date_button_leave_request.dart';
import '../organism/create_leave_application_bloc_listiner.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({
    super.key,
    required this.leaveTypeId,
    this.leaveTypeName,
  });
  final String leaveTypeId;
  final String? leaveTypeName;

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  late TextEditingController reasonController;
  late TextEditingController numberController;
  late TextEditingController emergencyEmailController;
  late TextEditingController emergencyPhoneController;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    reasonController =
        BlocProvider.of<LeaveApplicationCubit>(context).reasonController;
    numberController =
        BlocProvider.of<LeaveApplicationCubit>(context).numberController;
    emergencyEmailController = BlocProvider.of<LeaveApplicationCubit>(context)
        .emergencyEmailController;
    emergencyPhoneController = BlocProvider.of<LeaveApplicationCubit>(context)
        .emergencyPhoneController;

    super.initState();
  }

  @override
  void dispose() {
    reasonController.dispose();
    numberController.dispose();
    emergencyEmailController.dispose();
    emergencyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(
          context,
          'Leave Request'.tr(context: context),
          [
            IconButton(
                onPressed: () {
                  context.pushName(Routes.myLeaveRequestsScreen,
                      arguments: widget.leaveTypeId);
                },
                icon: const Icon(Icons.explore))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(children: [
                if ((widget.leaveTypeName ?? '').trim().isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F8FE),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: ColorsManger.primaryColor.withValues(alpha: .2),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: AppStylesManger.font12RegularGrey,
                        children: [
                          TextSpan(
                              text: '${'Leave Type'.tr(context: context)}: '),
                          TextSpan(
                            text: widget.leaveTypeName!.trim(),
                            style: AppStylesManger.font14BoldBlack.copyWith(
                              color: ColorsManger.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpace(10),
                ],
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('For a while'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                Row(
                  children: [
                    Expanded(
                        child: DateButtonLeaveRequest(
                      text: 'From'.tr(context: context),
                    )),
                    horizontalSpace(10),
                    Expanded(
                        child: DateButtonLeaveRequest(
                      text: 'To'.tr(context: context),
                    )),
                  ],
                ),
                verticalSpace(10),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Reason'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                CustomAppTextFormField(
                    controller: reasonController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Reason Required'.tr(context: context);
                      }
                      return null;
                    },
                    maxLines: 5,
                    hint:
                        'Reason * (200 Chaaracters Max)'.tr(context: context)),
                verticalSpace(10),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Number of days'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                CustomAppTextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Number Required'.tr(context: context);
                    }
                    return null;
                  },
                  hint: 'Enter Number'.tr(context: context),
                ),
                verticalSpace(10),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Emergency Email'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                CustomAppTextFormField(
                  controller: emergencyEmailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Emergency Email Required'.tr(context: context);
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email'.tr(context: context);
                    }
                    return null;
                  },
                  hint: 'Enter Emergency Email'.tr(context: context),
                ),
                verticalSpace(10),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Emergency Phone'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                CustomAppTextFormField(
                  controller: emergencyPhoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Emergency Phone Required'.tr(context: context);
                    }
                    return null;
                  },
                  hint: 'Enter Emergency Phone'.tr(context: context),
                ),
                verticalSpace(10),
                verticalSpace(20),
                CustomAppButton(
                  onPressed: () {
                    validateAndSubmitLeaveRequest();
                  },
                  textButton: 'Submit'.tr(),
                  buttonColor: ColorsManger.primaryColor,
                ),
                const CreateLeaveApplicationBlocListener(
                  requestType: "Claim Request",
                )
              ]),
            ),
          ),
        ));
  }

  validateAndSubmitLeaveRequest() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LeaveApplicationCubit>(context)
          .sendRequestToSupervisor(leaveTypeId: widget.leaveTypeId);
    }
  }
}
