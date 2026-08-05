import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
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
    this.checkInTime,
    this.checkOutTime,
    this.onTypeChanged,
  });

  final String attendType;
  final String? checkInTime;
  final String? checkOutTime;
  final Function(String)? onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveCheckIn =
        (checkInTime != null && checkInTime!.isNotEmpty && checkInTime != 'null')
            ? checkInTime!
            : ApiConstant.employeeCheckinTime;

    final effectiveCheckOut =
        (checkOutTime != null && checkOutTime!.isNotEmpty && checkOutTime != 'null')
            ? checkOutTime!
            : ApiConstant.employeeCheckoutTime;

    return FadeInRight(
      duration: const Duration(seconds: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              context.pushName(
                Routes.employeeCheckInScreen,
                arguments: attendType,
              );
            },
            child: CheckingHomeContainer(
              time: effectiveCheckIn.isEmpty || effectiveCheckIn == 'null'
                  ? formatHour('00:00')
                  : formatHour(effectiveCheckIn),
              iconColor: Colors.black,
              color: const Color.fromARGB(255, 170, 236, 192),
              image: 'assets/images/tap.png',
              string: 'Check In'.tr(
                context: context,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.pushName(
                Routes.employeeCheckOutScreen,
                arguments: attendType,
              );
            },
            child: CheckingHomeContainer(
              time: effectiveCheckOut.isEmpty || effectiveCheckOut == 'null'
                  ? formatHour('00:00')
                  : formatHour(effectiveCheckOut),
              iconColor: Colors.black,
              color: const Color.fromARGB(255, 230, 108, 99),
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
