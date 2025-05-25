import 'package:easy_localization/easy_localization.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../atoms/drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDrawerListViewItems extends StatefulWidget {
  const EmployeeDrawerListViewItems({super.key});

  @override
  State<EmployeeDrawerListViewItems> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EmployeeDrawerListViewItems> {
  final ValueNotifier<bool> _controller = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    SecureCache.getFromCache(key: 'notification').then((value) {
      if (value == 'Subscribe') {
        _controller.value = true;
      } else {
        _controller.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      GestureDetector(
        onTap: () async {
          if (!await launchUrl(Uri.parse('https://systmgulf.com/'))) {
            throw Exception('Could not launch ');
          }
        },
        child: ActiveDrawerItem(
          text: 'My Organization'.tr(context: context),
          icon: Icons.business,
        ),
      ),
      GestureDetector(
        onTap: () {
          context.pushName(Routes.employeeChangePasswordScreen);
        },
        child: ActiveDrawerItem(
          text: 'Change Password'.tr(context: context),
          icon: Icons.lock_reset_rounded,
        ),
      ),
      GestureDetector(
        onTap: () {
          context.pushName(Routes.employeeAttendanceHistoryScreen);
        },
        child: ActiveDrawerItem(
          text: 'Attendance Report'.tr(context: context),
          icon: Icons.insert_chart_outlined,
        ),
      ),
      GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (cnx) {
              return IntrinsicHeight(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          EasyLocalization.of(context)!
                              .setLocale(const Locale('en', 'US'));
                          Navigator.pop(context);
                        },
                        title: const Text('English'),
                      ),
                      ListTile(
                        onTap: () {
                          EasyLocalization.of(context)!
                              .setLocale(const Locale('ar', 'AE'));
                          Navigator.pop(context);
                        },
                        title: const Text('العربية'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: ActiveDrawerItem(
          text: 'Change Language'.tr(context: context),
          icon: Icons.language,
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.notification_important_outlined,
          color: Colors.indigo,
          size: 20,
        ),
        title: Text(
          'Notification'.tr(context: context),
          style: AppStylesManger.font15BoldBlack,
        ),
        trailing: AdvancedSwitch(
          initialValue: _controller.value,
          onChanged: (value) async {
            if (value == true) {
              await SecureCache.insertToCache(
                key: 'notification',
                value: 'Subscribe',
              );
              // await FirebaseMessaging.instance.subscribeToTopic('notification');
            } else {
              await SecureCache.insertToCache(
                key: 'notification',
                value: 'Unsubscribe',
              );
              // await FirebaseMessaging.instance
              //     .unsubscribeFromTopic('notification');
            }
          },
          controller: _controller,
          activeColor: Colors.red,
        ),
      ),
    ];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return items[index];
      },
      itemCount: items.length,
    );
  }
}
