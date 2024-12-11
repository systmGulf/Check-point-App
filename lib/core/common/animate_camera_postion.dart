import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

LatLng animateCameraPosition(
  LocationData locationData,
  GoogleMapController? googleMapController,
) {
  final latLng = LatLng(locationData.latitude!, locationData.longitude!);
  final cameraPosition = CameraPosition(target: latLng, zoom: 17.5);
  if (googleMapController != null) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }
  return latLng;
}
