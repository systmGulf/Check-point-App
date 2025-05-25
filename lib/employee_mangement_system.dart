import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/dependency%D9%80injection/register%D9%80factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/widgets/permission_screen.dart';
import 'features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';

class HrManagementSystem extends StatefulWidget {
  const HrManagementSystem({super.key});

  @override
  State<HrManagementSystem> createState() => _HrManagementSystemState();
}

class _HrManagementSystemState extends State<HrManagementSystem>
    with WidgetsBindingObserver {
  bool _allPermissionsGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
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
    if (!_allPermissionsGranted) {
      // Show permission screen if permissions are not granted
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
      child: BlocProvider(
        create: (context) => getIt<LeaveApplicationCubit>(),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
              fontFamily: 'Cairo', scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
