import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controller/leave_application/leave_application_cubit.dart';
import '../atoms/date_button_leave_request.dart';
import '../organism/create_leave_application_bloc_listiner.dart';

class IncidentTeam extends StatefulWidget {
  const IncidentTeam({super.key});

  @override
  State<IncidentTeam> createState() => _IncidentTeamState();
}

class _IncidentTeamState extends State<IncidentTeam> {
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
        appBar:
            buildCustomAppBar(context, 'Incident Team'.tr(context: context)),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(children: [
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
                  child: Text('who'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
                  buildWhen: (previous, current) =>
                      current is GetEmployeesByDepartmentIdFailure ||
                      current is GetEmployeesByDepartmentIdSuccess ||
                      current is GetEmployeesByDepartmentIdLoading,
                  builder: (context, state) {
                    if (state is GetEmployeesByDepartmentIdSuccess) {
                      return DropdownButtonFormField(
                          icon: SizedBox(
                              width: 24,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/arrow_down.svg',
                                  color: Colors.orange,
                                ),
                              )),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: ColorsManger.primaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 0,
                                  borderSide: BorderSide(
                                    color: ColorsManger.primaryColor,
                                  ))),
                          initialValue: state.employees.data![0].id,
                          menuMaxHeight: 200.h,
                          padding: EdgeInsets.symmetric(horizontal: 0.w),
                          items: state.employees.data!
                              .map((e) => DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    value: e.id,
                                    child: Text(e.name ?? ''),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            BlocProvider.of<LeaveApplicationCubit>(context)
                                .employeeId = value.toString();
                            setState(() {});
                          });
                    } else if (state is GetEmployeesByDepartmentIdLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: ColorsManger.primaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: ColorsManger.primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide())),
                            initialValue: null,
                            items: const [],
                            onChanged: (value) {}),
                      );
                    } else if (state is GetEmployeesByDepartmentIdFailure) {
                      return Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            verticalSpace(10),
                            Text(
                              state.error,
                              style: AppStylesManger.font14RedularRed,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
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
                        return 'Please enter reason'.tr();
                      }
                      return null;
                    },
                    maxLines: 5,
                    hint:
                        'Reason * (200 Chaaracters Max)'.tr(context: context)),
                verticalSpace(10),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Remark'.tr(context: context),
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(10),
                CustomAppTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter remark'.tr();
                      }
                      return null;
                    },
                    controller: remarkController,
                    hint: 'Remark'.tr(context: context)),
                verticalSpace(10),
                CustomAppButton(
                  onPressed: () {
                    validateAndSubmitLeaveRequest();
                  },
                  textButton: 'Submit'.tr(context: context),
                  buttonColor: ColorsManger.primaryColor,
                ),
                const CreateLeaveApplicationBlocListener(
                  requestType: "Icident Team",
                )
              ]),
            ),
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
