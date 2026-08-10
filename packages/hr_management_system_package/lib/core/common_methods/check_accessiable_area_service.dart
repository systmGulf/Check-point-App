import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class CheckAccessibleAreaService {
  double checkAccessibleAreaForCircle(
      LatLng customerLocation, LatLng currentUserLocation) {
    const double earthRadius = 6371000;
    double lat1 = customerLocation.latitude * pi / 180;
    double lon1 = customerLocation.longitude * pi / 180;
    double lat2 = currentUserLocation.latitude * pi / 180;
    double lon2 = currentUserLocation.longitude * pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  Future<bool> checkAccessibleAreaForPolygon(
    LatLng pointLatLong,
    List<LatLng> area,
  ) async {
    List<map_tool.LatLng> conventedPolyGonsPoints =
        area.map((e) => map_tool.LatLng(e.latitude, e.longitude)).toList();
    return map_tool.PolygonUtil.containsLocation(
        map_tool.LatLng(pointLatLong.latitude, pointLatLong.longitude),
        conventedPolyGonsPoints,
        false);
  }
}
