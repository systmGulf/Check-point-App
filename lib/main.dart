import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/dependency%D9%80injection/register%D9%80factory.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/core/common_methods/local_notifications_service.dart';
import 'package:hr_management_system_package/core/common_methods/track_user_in_background.dart';
import 'package:hr_management_system_package/core/dependecy_injection/service_locator.dart';
import 'package:hr_management_system_package/env/env.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/common/bloc_observer.dart';
import 'employee_mangement_system.dart';

Future<void> initializeServices() async {
  // await Firebase.initializeApp();
  // await FcmNotificationService.init();
  await LocalNotificationService.init();
  await Permission.storage.request();
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  await initializeServiceBackground();
  setUpServiceLocator();
  registerFactory();
  Bloc.observer = AppBlocObserver();
  await Permission.manageExternalStorage.request();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

Future<void> runMainApp() async {
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AE')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const HrManagementSystem(),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.ignoreBatteryOptimizations.request();
  PermissionStatus locationStatus =
      await Permission.locationWhenInUse.request();
  if (!locationStatus.isGranted && !Platform.isIOS) {
    openAppSettings();
  }

  if (kReleaseMode) {
     currentEnvironment = EnvironmentType.prod;
      await initializeServices();
      await runMainApp();
  } else {
    currentEnvironment = EnvironmentType.dev;
    await initializeServices();
    await runMainApp();
  }
}
