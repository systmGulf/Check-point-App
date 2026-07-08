import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../atoms/date_button_leave_request.dart';

class WorkflowSubmission extends StatefulWidget {
  const WorkflowSubmission({super.key});

  @override
  State<WorkflowSubmission> createState() => _WorkflowSubmissionState();
}

class _WorkflowSubmissionState extends State<WorkflowSubmission> {
  File? file;
  List<File>? files;

  final _controller = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
  }

  bool loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Workflow Submission'.tr(context: context)),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: DateButtonLeaveRequest(
                          placeholder: 'From'.tr(context: context),
                          dateField: LeaveRequestDateField.from,
                        )),
                        horizontalSpace(10),
                        Expanded(
                            child: DateButtonLeaveRequest(
                          placeholder: 'To'.tr(context: context),
                          dateField: LeaveRequestDateField.to,
                        )),
                      ],
                    ),
                    verticalSpace(10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.attach_file_outlined,
                        color: ColorsManger.primaryColor,
                      ),
                      title: Text(
                          'Pick Multiple Files'
                              .tr(context: context)
                              .tr(context: context),
                          style: AppStylesManger.font16BoldBlack),
                      trailing: AdvancedSwitch(
                        controller: _controller,
                        activeColor: ColorsManger.primaryColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                    verticalSpace(10),
                    Text('Action'.tr(context: context),
                        style: AppStylesManger.font16BoldBlack),
                    verticalSpace(10),
                    MaterialButton(
                        height: MediaQuery.of(context).size.height * 0.06,
                        minWidth: MediaQuery.of(context).size.height * 0.16,
                        color: Colors.blue[900],
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () async {
                          // setState(() {
                          //   loading = true;
                          // });
                          // try {
                          //   if (_checked == true) {
                          //     // FilePickerResult? result = await FilePicker
                          //     //     .platform
                          //     //     .pickFiles(allowMultiple: true);
                          //     if (result != null) {
                          //       setState(() {
                          //         files = result.paths
                          //             .map((path) => File(path!))
                          //             .toList();

                          //         loading = false;
                          //       });
                          //     } else {
                          //       showTopSnackBar(
                          //         Overlay.of(context),
                          //          CustomSnackBar.error(
                          //           message: 'No file selected'.tr(context: context),
                          //           // backgroundColor: Colors.red,
                          //         ),
                          //       );
                          //       setState(() {
                          //         loading = false;
                          //       });
                          //     }
                          //   } else {
                          //     FilePickerResult? result =
                          //         await FilePicker.platform.pickFiles();

                          //     if (result != null) {
                          //       setState(() {
                          //         file = File(result.files.single.path!);

                          //         loading = false;
                          //       });
                          //     } else {
                          //       showTopSnackBar(
                          //         Overlay.of(context),
                          //          CustomSnackBar.error(
                          //           message: 'No file selected'.tr(context: context),
                          //           // backgroundColor: Colors.red,
                          //         ),
                          //       );
                          //       setState(() {
                          //         loading = false;
                          //       });
                          //     }
                          //   }
                          // } on Exception catch (e) {
                          //   showTopSnackBar(
                          //     Overlay.of(context),
                          //     CustomSnackBar.error(message: e.toString()
                          //         // backgroundColor: Colors.red,
                          //         ),
                          //   );
                          //   setState(() {
                          //     loading = false;
                          //   });
                          // }
                        },
                        child: IntrinsicWidth(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.file_open,
                              ),
                              horizontalSpace(10),
                              Text('Pick File'.tr(context: context)),
                            ],
                          ),
                        )),
                    verticalSpace(10),
                    file != null || files != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Files'.tr(context: context),
                                  style: AppStylesManger.font16BoldBlack),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(file != null
                                    ? file!.path
                                    : files!.map((e) => e.path).toString()),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    verticalSpace(10),
                    CustomAppTextFormField(
                        controller: TextEditingController(),
                        hint: 'Remark'.tr(context: context)),
                    verticalSpace(10),
                    const DateButtonLeaveRequest(),
                    verticalSpace(20),
                    CustomAppButton(
                      onPressed: () {},
                      textButton: 'Submit'.tr(context: context),
                      buttonColor: ColorsManger.primaryColor,
                    ),
                  ]),
            ),
          ),
        ));
  }
}
