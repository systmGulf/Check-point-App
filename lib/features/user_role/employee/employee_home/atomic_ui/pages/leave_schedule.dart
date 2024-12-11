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

class LeaveSchedule extends StatefulWidget {
  const LeaveSchedule({super.key});

  @override
  State<LeaveSchedule> createState() => _LeaveScheduleState();
}

class _LeaveScheduleState extends State<LeaveSchedule> {
  late TextEditingController reasonController;
  late TextEditingController remarkController;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    reasonController =
        BlocProvider.of<LeaveApplicationCubit>(context).reasonController;
    remarkController =
        BlocProvider.of<LeaveApplicationCubit>(context).remarkController;
    super.initState();
  }

  @override
  void dispose() {
    reasonController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(
          context,
          'Leave Schedule'.tr(context: context),
          [
            IconButton(
                onPressed: () {
                  context.pushName(Routes.myLeaveRequestsScreen,
                      arguments: 'LeaveSchedule');
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('For a while',
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                Row(
                  children: [
                    Expanded(
                        child: DateButtonLeaveRequest(
                      text: 'From'.tr(
                        context: context,
                      ),
                    )),
                    horizontalSpace(10),
                    Expanded(
                        child: DateButtonLeaveRequest(
                      text: 'To'.tr(
                        context: context,
                      ),
                    )),
                  ],
                ),
                verticalSpace(10),
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text('Reason', style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                CustomAppTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Reason Required'.tr(
                          context: context,
                        );
                      }
                      return null;
                    },
                    controller: reasonController,
                    maxLines: 5,
                    hint: 'Reason * (200 Chaaracters Max)'.tr(
                      context: context,
                    )),
                verticalSpace(10),
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text('Remark', style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                CustomAppTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Remark Required'
                            .tr(
                              context: context,
                            )
                            .tr(
                              context: context,
                            );
                      }
                      return null;
                    },
                    controller: remarkController,
                    hint: 'Remark'.tr(
                      context: context,
                    )),
                verticalSpace(10),
                verticalSpace(20),
                CustomAppButton(
                  onPressed: () {
                    validateAndSubmitLeaveRequest();
                  },
                  textButton: 'Submit'.tr(
                    context: context,
                  ),
                  buttonColor: ColorsManger.primaryColor,
                ),
                const CreateLeaveApplicationBlocListener(
                  requestType: "Leave Schedule",
                )
              ]),
            ),
          ),
        ));
  }

  validateAndSubmitLeaveRequest() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LeaveApplicationCubit>(context)
          .sendRequestToSupervisor(type: "LeaveSchedule");
    }
  }
}
