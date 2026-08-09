import 'package:location/location.dart';
import 'dart:async';

abstract class LocationService {
  static Location location = Location();

  static Future<bool> checkAndRequestLocationService() async {
    try {
      var isServiceEnabled = await location.serviceEnabled();
      if (!isServiceEnabled) {
        isServiceEnabled = await location.requestService();
      }

      return isServiceEnabled;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> checkAndRequestLocationPermission() async {
    try {
      var permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.deniedForever) {
        return false;
      }

      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
      }

      return permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.grantedLimited;
    } catch (_) {
      return false;
    }
  }

  static StreamSubscription<LocationData> getRealTimeLocation(
      void Function(LocationData)? onData) {
    return location.onLocationChanged.listen(onData);
  }

  static Future<LocationData?> getCurrentLocation() async {
    try {
      return await location.getLocation();
    } catch (_) {
      return null;
    }
  }

  static Future<bool> getLocationData() async {
    final isServiceEnabled = await checkAndRequestLocationService();
    final hasPermission = await checkAndRequestLocationPermission();
    return isServiceEnabled && hasPermission;
  }
}
