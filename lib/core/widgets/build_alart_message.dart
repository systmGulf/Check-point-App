import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/styles.dart';

Future<dynamic> buildDeleteAlertDialog(
  BuildContext context, {
  required String title,
  required void Function()? onYes,
  message,
}) {
  return showModalBottomSheet(
      context: context,
      builder: (_) => IntrinsicHeight(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0XFFF3F3F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Divider(
                    indent: 177.w,
                    endIndent: 177.w,
                    thickness: 4,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x05000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFE4E6),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 12.33,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: const Color(0xFFFFF1F1),
                              ),
                              borderRadius: BorderRadius.circular(43.17),
                            ),
                          ),
                          child: SvgPicture.asset(
                              'assets/images/trash_icon.svg',
                              fit: BoxFit.fill),
                        ),
                        horizontalSpace(12),
                        Text(title,
                            textAlign: TextAlign.center,
                            style: AppStylesManger.font20Medium.copyWith(
                              color: Color(0xFF060708),
                            )),
                      ],
                    ),
                  ),
                  verticalSpace(8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 31.w),
                    child: SizedBox(
                      child: Text(message,
                          textAlign: TextAlign.center,
                          style: AppStylesManger.font14Medium.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF505762),
                          )),
                    ),
                  ),
                  verticalSpace(16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomAppButton(
                            buttonColor: Color(0xFFDF2727),
                            height: 59.h,
                            textButton: 'Cancel'.tr(),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        horizontalSpace(12),
                        Expanded(
                          child: InkWell(
                            onTap: onYes,
                            child: Container(
                              height: 59.h,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.w, color: Color(0xFFDF2727)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Text(title,
                                    style:
                                        AppStylesManger.font18SemiBold.copyWith(
                                      color: Color(0xFFDF2727),
                                    )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpace(16),
                ],
              ),
            ),
          ));
}

Future<dynamic> buildAlertDialog(
  BuildContext context, {
  required String title,
  required void Function()? onYes,
  message,
}) {
  return showDialog(
    context: context,
    builder: (cnx1) => CupertinoAlertDialog(
      title: Text(title.tr()),
      content: Text(message as String),
      actions: <Widget>[
        TextButton(
          onPressed: onYes,
          child: Text(
            'Yes'.tr(context: context),
            style: AppStylesManger.font16BoldBlack.copyWith(color: Colors.blue),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(cnx1);
          },
          child: Text(
            'Close'.tr(context: context),
            style: AppStylesManger.font16BoldBlack.copyWith(color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}
