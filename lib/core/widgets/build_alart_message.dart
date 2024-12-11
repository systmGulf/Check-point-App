import 'package:easy_localization/easy_localization.dart';
import '../helpers/extention.dart';
import '../styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> buildAlertDialog(BuildContext context,
    {required String title, message, required void Function()? onYes}) {
  return showDialog(
      context: context,
      builder: (cnx1) => CupertinoAlertDialog(
            title: Text(title.tr()),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: onYes,
                  child: Text(
                    'Yes'.tr(context: context),
                    style: AppStylesManger.font16BoldBlack
                        .copyWith(color: Colors.blue),
                  )),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  'Close'.tr(context: context),
                  style: AppStylesManger.font16BoldBlack
                      .copyWith(color: Colors.blue),
                ),
              )
            ],
          ));
}
