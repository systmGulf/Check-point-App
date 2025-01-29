import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:hr_management_system_package/core/dependecy_injection/employee_service_locator.dart';
import 'package:hr_management_system_package/employee/data/models/employee_leave_requests_models/track_user_request_body.dart';
import 'package:hr_management_system_package/employee/data/repo/employee_attendance_repo/employee_attendance_repo.dart';
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
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}


Future<bool> handleLocationPermissionAndGPS() async {
  // Request location permissions
  if (!await _requestLocationPermission()) {
    return false;
  }

  // Check if GPS is enabled
  if (!await _isGPSEnabled()) {
    // Prompt the user to enable GPS
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
      } else {
      
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
      } else {
      
      }
      return false;
    }
  }

  return true;
}

Future<bool>  _isGPSEnabled() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }
  return true;
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
   setUpServiceLocator();
   ApiConstant.employeeId =
              await SecureCache.getFromCache(key: 'employeeId');
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stop').listen((event) {
      service.stopSelf();
    });
  }
  Timer.periodic(const Duration(minutes: 1), (timer) async {
     
      Position? position;
        try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Failed to get location: $e');
    }
    if (position != null) {
      log('${position.latitude} , ${position.longitude}');
       getIt<EmployeeAttendanceRepo>()..trackEmployeeLocation(trackUserRequestBody: TrackUserRequestBody(
      employeeId: ApiConstant.employeeId,
      coordinates: [
        {
      "latitude": position.latitude,
      "longitude": position.longitude 
    }
      ],
     ));
    }
  });
 
  service.on('stop').listen((event) async {
    service.stopSelf();
  });
}
