import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_management_system_package/core/common_methods/local_notifications_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeServiceBackground() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
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

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, prompt the user to enable them.
   

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
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Fetch current location
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Failed to get location: $e');
    }

    // Add log with timestamp and location info
    final log = preferences.getStringList('log') ?? <String>[];
    final currentTime = DateTime.now().toIso8601String();
    final locationInfo = position != null
        ? 'Lat: ${position.latitude}, Lon: ${position.longitude}'
        : 'Location not available';

    log.add('$currentTime - $locationInfo');
    await preferences.setStringList('log', log);
   LocalNotificationService.showbasicNotification(title: 'location', massBody: 'time now is  ${currentTime.substring(0, 10)} and your location is $locationInfo  ', );
  
    service.invoke(
      'update',
      {
        "current_date": currentTime,
        "location": locationInfo,
      },
    );
  });
}