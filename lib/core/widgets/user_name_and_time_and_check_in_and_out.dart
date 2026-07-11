import 'package:analog_clock/analog_clock.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../helpers/app_spaces.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

class UserNameAndTimeAndCheckInAndOutItem extends StatelessWidget {
  const UserNameAndTimeAndCheckInAndOutItem({
    super.key,
    required this.name,
    this.checkInTap,
    this.checkOutTap,
    required this.image,
  });
  final String name;
  final void Function()? checkInTap, checkOutTap;
  final String image;
  @override
  Widget build(BuildContext context) {
    final authTap = checkInTap ?? checkOutTap;
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
                  UserImage(imageUrl: image, height: 30),
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
      Spin(
        child: AnalogClock(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorsManger.primaryColor.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
              border: Border.all(width: 2.0, color: ColorsManger.primaryColor),
              color: Colors.white,
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
      ),
      verticalSpace(10),
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: authTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.fingerprint,
                              color: Colors.grey,
                            ),
                            horizontalSpace(5),
                            Text(
                                'Authentication'.tr(
                                  context: context,
                                ),
                                style: AppStylesManger.font15BoldrBlue),
                          ],
                        ),
                        Text(
                            'Authenticate attendance for'.tr(
                              context: context,
                            ),
                            style: AppStylesManger.font15BoldBlack),
                        ZoomIn(
                          child: Text(
                            dateFormat.format(DateTime.now()),
                            style: AppStylesManger.font15BoldBlack,
                          ),
                        ),
                        verticalSpace(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Colors.grey,
                            ),
                            horizontalSpace(5),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Shift'.tr(
                                        context: context,
                                      ),
                                      style: AppStylesManger.font15BoldrBlue),
                                  horizontalSpace(10),
                                  Expanded(
                                    child: ApiConstant.shiftName == '' ||
                                            ApiConstant.shiftName == "null"
                                        ? Text(
                                            'you are not assigned to any shift'
                                                .tr(),
                                            style: AppStylesManger
                                                .font15BoldBlack
                                                .copyWith(
                                              color: ColorsManger.primaryColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )
                                        : Text(
                                            '${ApiConstant.shiftName}'.tr(
                                              context: context,
                                            ),
                                            style:
                                                AppStylesManger.font15BoldBlack,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  horizontalSpace(12),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: ColorsManger.primaryColor,
                      border: Border.all(color: ColorsManger.primaryColor),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              ColorsManger.primaryColor.withValues(alpha: 0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/fingerprint.png',
                        color: Colors.white,
                        width: 58.w,
                        height: 58.h,
                        fit: BoxFit.fill),
                  )
                ],
              )),
        ),
      ),
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
