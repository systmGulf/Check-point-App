import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/dependency%D9%80injection/register%D9%80factory.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/widgets/permission_screen.dart';
import 'features/user_role/employee/employee_home/controller/attendence/attendence_cubit.dart';
import 'features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import 'core/improvements/dynamic_theme_cubit.dart';

class CheckPointApp extends StatefulWidget {
  const CheckPointApp({super.key});

  @override
  State<CheckPointApp> createState() => _CheckPointAppState();
}

class _CheckPointAppState extends State<CheckPointApp>
    with WidgetsBindingObserver {
  bool _allPermissionsGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!Platform.isIOS) {
      _checkPermissions();
    }
  }

  @override
  void dispose() {
    _clearSharedPreferences();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _clearSharedPreferences();
    }
  }

  Future<void> _clearSharedPreferences() async {
    FlutterBackgroundService().invoke('stop');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      AttendanceCubit.trackingEnabledKey,
      false,
    );
    SecureCache.deleteFromCacheByKey(key: 'token');
    SecureCache.deleteFromCacheByKey(key: 'username');
    SecureCache.deleteFromCacheByKey(key: 'departmentId');
    SecureCache.deleteFromCacheByKey(key: 'position');
  }

  Future<void> _checkPermissions() async {
    final locationStatus = await Permission.locationAlways.isGranted;
    final batteryOptimizationStatus =
        await Permission.ignoreBatteryOptimizations.isGranted;

    if (locationStatus && batteryOptimizationStatus) {
      setState(() {
        _allPermissionsGranted = true;
      });
    } else {
      setState(() {
        _allPermissionsGranted = false;
      });
    }
  }

  Future<void> _openPermissionSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (!_allPermissionsGranted && !Platform.isIOS) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: PermissionScreen(
            onRetry: _checkPermissions,
            onOpenSettings: _openPermissionSettings,
          ),
        ),
      );
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<LeaveApplicationCubit>()),
          BlocProvider(create: (context) => DynamicThemeCubit()),
        ],
        child: BlocBuilder<DynamicThemeCubit, DynamicThemeState>(
          builder: (context, themeState) {
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData(
                  fontFamily: 'Cairo',
                  scaffoldBackgroundColor: ColorsManger.scaffoldBackgroundColor,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: themeState.primaryColor,
                    brightness: Brightness.light,
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: ColorsManger.scaffoldBackgroundColor,
                    foregroundColor: ColorsManger.lightblack,
                    surfaceTintColor: Colors.transparent,
                  ),
                ),
                debugShowCheckedModeBanner: false,
                initialRoute: Routes.splash,
                onGenerateRoute: AppRouter.onGenerateRoute,
              ),
            );
          },
        ),
      ),
    );
  }
}
