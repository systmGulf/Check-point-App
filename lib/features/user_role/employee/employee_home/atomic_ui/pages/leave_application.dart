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

class LeaveApplication extends StatefulWidget {
  const LeaveApplication({super.key});

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  late TextEditingController reasonController;
  late TextEditingController remarkController;
  GlobalKey<FormState> fromkey = GlobalKey();

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
          'Leave Aplication'.tr(context: context),
          [
            IconButton(
                onPressed: () {
                  context.pushName(Routes.myLeaveRequestsScreen,
                      arguments: 'LeaveRequest');
                },
                icon: const Icon(Icons.explore))
          ],
        ),
        body: Form(
          key: fromkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ListView(children: [
              verticalSpace(15),
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
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Reason Required'.tr(context: context);
                    }
                    return null;
                  },
                  controller: reasonController,
                  hint: 'Reason * (200 Chaaracters Max)'.tr(context: context)),
              verticalSpace(10),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Remark'.tr(context: context),
                    style: AppStylesManger.font12RegularGrey),
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Remark Required'.tr(context: context);
                    }
                    return null;
                  },
                  controller: remarkController,
                  hint: 'Remark'.tr(context: context)),
              verticalSpace(20),
              CustomAppButton(
                onPressed: () {
                  validateAndSubmitLeaveRequest();
                },
                textButton: 'Submit'.tr(context: context),
                buttonColor: ColorsManger.primaryColor,
              ),
              const CreateLeaveApplicationBlocListener(
                requestType: "Leave Request",
              )
            ]),
          ),
        ));
  }

  validateAndSubmitLeaveRequest() {
    if (fromkey.currentState!.validate()) {
      BlocProvider.of<LeaveApplicationCubit>(context)
          .sendRequestToSupervisor(type: "LeaveRequest");
    }
  }
}
