import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';
import '../../controller/leave_application/leave_application_cubit.dart';
import '../molecules/custom_floating_action_button_widget.dart';
import '../molecules/employee_more_option_drawer.dart';
import '../organism/employee_custom_drawer.dart';
import '../organism/employee_home_screen_body.dart';

import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:hr_management_system_package/core/common_methods/local_notifications_service.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendRandomFeatureReminder();
    });
  }

  void _sendRandomFeatureReminder() {
    final random = Random();
    final locale = EasyLocalization.of(context)?.locale.languageCode ?? 'en';
    
    final List<Map<String, String>> englishReminders = [
      {
        'title': 'Request Leaves Easily 🌴',
        'body': 'Did you know you can submit your leave requests directly from the app?',
      },
      {
        'title': 'Track Your Attendance ⏰',
        'body': 'Don\'t forget to check-in/out of the office to keep your records accurate!',
      },
      {
        'title': 'Check Your Tasks 📝',
        'body': 'Stay on top of your schedule! Review your assigned tasks in the drawer.',
      },
      {
        'title': 'Public Holidays 📅',
        'body': 'Want to check upcoming holidays? View the Public Holidays tab under Leaves.',
      }
    ];

    final List<Map<String, String>> arabicReminders = [
      {
        'title': 'طلب الإجازات بسهولة 🌴',
        'body': 'هل تعلم أنه يمكنك تقديم طلبات إجازتك مباشرة من التطبيق؟',
      },
      {
        'title': 'تتبع حضورك وانصرافك ⏰',
        'body': 'لا تنسَ تسجيل حضورك وانصرافك اليوم للحفاظ على دقة سجلاتك!',
      },
      {
        'title': 'تحقق من مهامك 📝',
        'body': 'كن على اطلاع بجدولك! راجع مهامك اليومية من القائمة الجانبية.',
      },
      {
        'title': 'الإجازات الرسمية 📅',
        'body': 'هل تريد معرفة الإجازات القادمة؟ تفقد تبويب الإجازات الرسمية في صفحة الإجازات.',
      }
    ];

    final reminders = (locale == 'ar') ? arabicReminders : englishReminders;
    final chosen = reminders[random.nextInt(reminders.length)];
    
    LocalNotificationService.showBasicNotification(
      title: chosen['title']!,
      massBody: chosen['body']!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButtonWidget(),
      endDrawer: const Drawer(
        child: EmployeeCustomDrawer(),
      ),
      drawer: Drawer(
        child: BlocProvider(
          create: (context) => LeaveApplicationCubit(
            employeeRepo: getIt<EmployeeActionRepo>(),
            odooTimeOffService: getIt<OdooTimeOffService>(),
          ),
          child: const EmployeeMoreOptionDrawer(),
        ),
      ),
      key: scaffoldKey,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              icon: CircleAvatar(
                  backgroundColor: ColorsManger.primaryColor,
                  radius: 20,
                  child: const Icon(Icons.person, color: Colors.white))),
        ],
        leading: GestureDetector(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: const Icon(Icons.menu)),
        backgroundColor: Colors.white,
      ),
      body: const EmployeeHomeScreenBody(),
    );
  }
}
