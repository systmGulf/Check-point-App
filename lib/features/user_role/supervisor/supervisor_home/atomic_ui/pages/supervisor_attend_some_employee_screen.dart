import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/employee_check_in_request_body.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../../../../../core/common/image_picker_base_64.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../employee/employee_home/atomic_ui/atoms/checking_home_container.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../molecules/supervisor_attend_user_bloc_listener.dart';

class SupervisorAttendSomeEmployeeScreen extends StatefulWidget {
  const SupervisorAttendSomeEmployeeScreen(
      {super.key, required this.getEmployeesValue});
  final EmployeeData getEmployeesValue;

  @override
  State<SupervisorAttendSomeEmployeeScreen> createState() =>
      _SupervisorAttendSomeEmployeeScreenState();
}

class _SupervisorAttendSomeEmployeeScreenState
    extends State<SupervisorAttendSomeEmployeeScreen> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: OverlayLoaderWithAppIcon(
        isLoading: true,
        appIcon: Image.asset(
          'assets/images/logo-w.png',
          height: 50,
          color: ColorsManger.primaryColor,
        ),
        circularProgressColor: ColorsManger.primaryColor,
        child: Container(),
      ),
      inAsyncCall: isloading,
      child: Scaffold(
        appBar: buildCustomAppBar(
            context, 'Attend Anther Employee'.tr(context: context)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpace(20),
            CircleAvatar(
                radius: 50,
                backgroundColor: ColorsManger.grey.withOpacity(0.4),
                child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            AssetImage('assets/images/app_logo.png')))),
            verticalSpace(15),
            Text(widget.getEmployeesValue.name!,
                style: AppStylesManger.font16BoldBlack),
            verticalSpace(15),
            Text(widget.getEmployeesValue.position!,
                style: AppStylesManger.font16BoldBlack),
            verticalSpace(15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            verticalSpace(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isloading = true;
                    });
                    final image = await ImagePickerHelper.pickImageBase64(
                      source: ImagePickSource.camera,
                    );
                    final now = DateTime.now().toUtc();

                    setState(() {
                      isloading = false;
                    });
                    context
                        .read<GetEmployeesDataCubit>()
                        .supervisorAttendSomeEmployeeCheckIn(
                            EmployeeCheckInRequestBody());
                  },
                  child: CheckingHomeContainer(
                    time: widget.getEmployeesValue.clockInTime ?? '09:00 AM',
                    iconColor: Colors.black,
                    color: ColorsManger.darkGreen,
                    image: 'assets/images/tap.png',
                    string: 'In'.tr(
                      context: context,
                    ),
                  ),
                ),
                horizontalSpace(10),
                GestureDetector(
                  onTap: () {
                    ImagePickerHelper.pickImageBase64(
                      source: ImagePickSource.camera,
                    ).then(
                      (value) {
                        context
                            .read<GetEmployeesDataCubit>()
                            .supervisorAttendSomeEmployeeCheckOut(
                                widget.getEmployeesValue.id!, value);
                      },
                    );
                  },
                  child: CheckingHomeContainer(
                    iconColor: Colors.black,
                    time: widget.getEmployeesValue.clockOutTime ?? '05:00 PM',
                    color: ColorsManger.primaryColor,
                    image: 'assets/images/tap.png',
                    string: 'Out'.tr(
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(30),
            Container(
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white,
                  ],
                  stops: const [0.7, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Image.asset('assets/images/Employee_login_image.png'),
            ),
            const SupervisorAttendUserBlocListener()
          ],
        ),
      ),
    );
  }
}
