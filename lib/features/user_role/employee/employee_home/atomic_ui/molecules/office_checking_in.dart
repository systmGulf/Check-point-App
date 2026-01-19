import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/formate_hours.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../atoms/checking_home_container.dart';

class CheckInOrCheckOutWidget extends StatelessWidget {
  const CheckInOrCheckOutWidget({
    super.key,
    required this.attendType,
  });
  final String attendType;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: const Duration(seconds: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              context.pushName(Routes.employeeCheckInScreen,
                  arguments: attendType);
            },
            child: CheckingHomeContainer(
              time: ApiConstant.employeeCheckinTime == ''
                  ? formatHour('00:00')
                  : formatHour(ApiConstant.employeeCheckinTime),
              iconColor: Colors.black,
              color: Color.fromARGB(255, 170, 236, 192),
              image: 'assets/images/tap.png',
              string: 'Check In'.tr(
                context: context,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.pushName(Routes.employeeCheckOutScreen,
                  arguments: attendType);
            },
            child: CheckingHomeContainer(
              time: ApiConstant.employeeCheckoutTime == ''
                  ? formatHour('00:00')
                  : formatHour(ApiConstant.employeeCheckoutTime),
              iconColor: Colors.black,
              color: Color.fromARGB(255, 230, 108, 99),
              image: 'assets/images/tap.png',
              string: 'Check Out'.tr(
                context: context,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
