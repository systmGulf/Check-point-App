import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../atoms/checking_home_container.dart';

class CheckInOrCheckOutWidget extends StatelessWidget {
  const CheckInOrCheckOutWidget({
    super.key,
    required this.attendType,
  });
  final String attendType;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            context.pushName(Routes.employeeCheckInScreen,
                arguments: attendType);
          },
          child: CheckingHomeContainer(
            iconColor: Colors.white,
            color: ColorsManger.darkGreen,
            image: 'assets/images/tap.png',
            string: 'In'.tr(
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
            iconColor: Colors.white,
            color: ColorsManger.primaryColor,
            image: 'assets/images/tap.png',
            string: 'Out'.tr(
              context: context,
            ),
          ),
        ),
      ],
    );
  }
}
