import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<dynamic> buildChangeLanguageBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (cnx) {
        return IntrinsicHeight(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    context.setLocale(const Locale('en', 'US'));
                    Navigator.pop(context);
                  },
                  title: const Text('English'),
                ),
                ListTile(
                  onTap: () {
                    context.setLocale(const Locale('ar', 'AE'));
                    Navigator.pop(context);
                  },
                  title: const Text('العربية'),
                )
              ],
            ),
          ),
        );
      });
}
