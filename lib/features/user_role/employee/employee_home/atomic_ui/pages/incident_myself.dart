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

class IncidentMyself extends StatefulWidget {
  const IncidentMyself({super.key});

  @override
  State<IncidentMyself> createState() => _IncidentMyselfState();
}

class _IncidentMyselfState extends State<IncidentMyself> {
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
          'accident Myself'.tr(),
          [
            IconButton(
                onPressed: () {
                  context.pushName(Routes.myLeaveRequestsScreen,
                      arguments: 'Icident');
                },
                icon: const Icon(Icons.explore))
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('For a while'.tr(),
                    style: AppStylesManger.font12RegularGrey),
              ),
              verticalSpace(10),
              Row(
                children: [
                  Expanded(
                      child: DateButtonLeaveRequest(
                    placeholder: 'From'.tr(),
                    dateField: LeaveRequestDateField.from,
                  )),
                  horizontalSpace(10),
                  Expanded(
                      child: DateButtonLeaveRequest(
                    placeholder: 'To'.tr(),
                    dateField: LeaveRequestDateField.to,
                  )),
                ],
              ),
              verticalSpace(10),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Reason'.tr(),
                    style: AppStylesManger.font12RegularGrey),
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Reason'.tr();
                    }
                    return null;
                  },
                  controller: reasonController,
                  maxLines: 5,
                  hint: 'Reason * (200 Chaaracters Max)'.tr()),
              verticalSpace(10),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Remark'.tr(),
                    style: AppStylesManger.font12RegularGrey),
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Remark'.tr();
                    }
                    return null;
                  },
                  controller: remarkController,
                  hint: 'Remark'.tr()),
              verticalSpace(10),
              CustomAppButton(
                onPressed: () {
                  validateAndSubmitLeaveRequest();
                },
                textButton: 'Submit'.tr(),
                buttonColor: ColorsManger.primaryColor,
              ),
              const CreateLeaveApplicationBlocListener(
                requestType: "Icident Myself",
              )
            ]),
          ),
        ));
  }

  validateAndSubmitLeaveRequest() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LeaveApplicationCubit>(context)
          .sendRequestToSupervisor(type: "Icident");
    }
  }
}
