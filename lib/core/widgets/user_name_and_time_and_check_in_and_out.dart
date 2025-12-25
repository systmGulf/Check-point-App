import 'package:analog_clock/analog_clock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/app_spaces.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

class UserNameAndTimeAndCheckInAndOutItem extends StatelessWidget {
  const UserNameAndTimeAndCheckInAndOutItem({
    super.key,
    required this.name,
    this.checkInTap,
    this.checkOutTap, required this.image,
  });
  final String name;
  final void Function()? checkInTap, checkOutTap;
  final String image;
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());
    return Column(children: [
      Align(
          alignment: AlignmentDirectional.center,
          child: Column(
            children: [
              Row(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  UserImage(height: 30),
                  horizontalSpace(10),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: 'Hello, '.tr(),
                        style: AppStylesManger.font18RegulerBlack
                            .copyWith(color: ColorsManger.primaryColor)),
                    TextSpan(
                      text: name,
                      style: AppStylesManger.font18BoldBlack,
                    ),
                  ])),
                ],
              ),
              Text('Good Morning'.tr(), style: AppStylesManger.font15BoldBlack),
            ],
          )),
      verticalSpace(20),
      AnalogClock(
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: ColorsManger.primaryColor),
            color: Colors.transparent,
            shape: BoxShape.circle),
        width: 135.0,
        height: 135.0,
        isLive: true,
        hourHandColor: Colors.black,
        minuteHandColor: Colors.black,
        showSecondHand: true,
        numberColor: ColorsManger.primaryColor,
        showNumbers: true,
        showAllNumbers: true,
        textScaleFactor: 1.4,
        showTicks: true,
        showDigitalClock: false,
        datetime: DateTime.now(),
      ),
      verticalSpace(10),
      Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey,
                      ),
                      horizontalSpace(5),
                      Text(
                          'Attendance'.tr(
                            context: context,
                          ),
                          style: AppStylesManger.font15BoldrBlue),
                    ],
                  ),
                  Text(
                      'Set Attendance for'.tr(
                        context: context,
                      ),
                      style: AppStylesManger.font15BoldBlack),
                  Text(
                    dateFormat.format(DateTime.now()),
                    style: AppStylesManger.font15BoldBlack,
                  )
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green,
                child: Image.asset('assets/images/fingerprint.png',
                    color: Colors.white,
                    width: 58.w,
                    height: 58.h,
                    fit: BoxFit.fill),
              ),
            ],
          )),
      verticalSpace(10),
    ]);
  }
}

class DateUtil {
  static String formatDate(DateTime date) {
    String dateFormat = tr('date_format');
    return DateFormat(dateFormat).format(date);
  }
}
