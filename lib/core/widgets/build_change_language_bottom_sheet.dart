import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';

Future<dynamic> buildChangeLanguageBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (cnx) {
        return IntrinsicHeight(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(15),
                Padding(
                  padding:  EdgeInsetsDirectional.only(end: 15.w),
                  child: Align(
                      alignment: AlignmentDirectional.topEnd,
                    child: IconButton( onPressed: () => Navigator.pop(context), icon:  Icon(Icons.close, color: ColorsManger.primaryColor,)))
                ),
                verticalSpace(15),
                Padding(
                  padding:  EdgeInsetsDirectional.only(start: 20.w),
                  child: Text("Select Language".tr(), style: AppStylesManger.font15BoldBlack,),
                ),
                verticalSpace(8),
                Padding(
                  padding:  EdgeInsetsDirectional.only(start: 20.w),
                  child: Text("What language do you Prefer?".tr(), style: AppStylesManger.font14RegularBlack,),
                ),
                verticalSpace(20),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ColorsManger.primaryColor,
                    child: Text("EN", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ),),
                  ),
                  onTap: () {
                    context.setLocale(const Locale('en', 'US'));
                    Navigator.pop(context);
                  },
                  title: const Text('English'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text("ع", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ),),
                  ),
                  onTap: () {
                    context.setLocale(const Locale('ar', 'AE'));
                    Navigator.pop(context);
                  },
                  title: const Text('العربية'),
                ),
                verticalSpace(20),
              ],
            ),
          ),
        );
      });
}
