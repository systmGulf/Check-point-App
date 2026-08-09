import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:hr_management_system_package/core/dependecy_injection/service_locator.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/track_user_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeServiceBackground() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      autoStartOnBoot: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

Future<bool> handleLocationPermissionAndGPS() async {
  if (!await _requestLocationPermission()) {
    return false;
  }

  if (!await _isGPSEnabled()) {
    return false;
  }

  return true;
}

Future<bool> _requestLocationPermission() async {
  var status = await Permission.locationWhenInUse.status;
  if (!status.isGranted) {
    status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }
  }

  status = await Permission.locationAlways.status;
  if (!status.isGranted) {
    status = await Permission.locationAlways.request();
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }
  }

  return true;
}

Future<bool> _isGPSEnabled() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  return serviceEnabled;
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  try {
    ApiConstant.employeeId = await SecureCache.getFromCache(key: 'employeeId');
    ApiConstant.token = await SecureCache.getFromCache(key: 'token');
  } catch (_) {
    ApiConstant.employeeId = '';
    ApiConstant.token = '';
  }

  setUpServiceLocator();

  bool running = true;
  Timer? locationTimer;

  service.on('get_status').listen((event) {
    service.invoke('service_status', {'running': running});
  });

  service.on('stop').listen((event) {
    running = false;
    locationTimer?.cancel();
    service.invoke('service_status', {'running': running});
    service.stopSelf();
  });

  locationTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (!running) {
      timer.cancel();
      return;
    }

    try {
      if (ApiConstant.employeeId.isEmpty) {
        ApiConstant.employeeId =
            await SecureCache.getFromCache(key: 'employeeId');
      }

      if (ApiConstant.token.isEmpty) {
        ApiConstant.token = await SecureCache.getFromCache(key: 'token');
        DioFactory.addDioHeaders();
      }

      if (ApiConstant.employeeId.isEmpty || ApiConstant.token.isEmpty) {
        return;
      }

      final hasLocationAccess = await handleLocationPermissionAndGPS();
      if (!hasLocationAccess) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final result =
          await getIt<EmployeeAttendanceRepo>().trackEmployeeLocation(
        trackUserRequestBody: TrackUserRequestBody(
          employeeId: ApiConstant.employeeId,
          coordinates: [
            {"latitude": position.latitude, "longitude": position.longitude}
          ],
        ),
      );

      result.fold(
        (failure) => service.invoke(
          'tracking_error',
          {'message': failure.message, 'code': failure.code},
        ),
        (_) {},
      );
    } catch (e) {
      final failure = ErrorHandler.handle(e).failure;
      service.invoke(
        'tracking_error',
        {'message': failure.message, 'code': failure.code},
      );
    }
  });
}
