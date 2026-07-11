import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';

import '../helpers/extention.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

Future<dynamic> AskAdminToChangeDeviceIdDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(
            Icons.lock_outline,
            color: Colors.red,
          ),
          Text(
            ' Login Access Denied'.tr(),
            style: AppStylesManger.font15BoldBlack,
          ),
        ],
      ),
      content: Text(
        'This Account id registered with another device do you want to ask admin to move the account to this device'
            .tr(),
        style: AppStylesManger.font14RegularBlack,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: CustomAppButton(
                textButton: "Send to admin",
                buttonColor: ColorsManger.grey,
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  'Cancel'.tr(),
                  style: AppStylesManger.font15BoldRed,
                )),
          ],
        )
      ],
    ),
  );
}
