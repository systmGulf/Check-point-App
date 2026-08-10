import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/common_methods/check_accessiable_area_service.dart';

void main() {
  group('CheckAccessibleAreaService', () {
    final service = CheckAccessibleAreaService();

    test('circle distance is zero for same point', () {
      final distance = service.checkAccessibleAreaForCircle(
        const LatLng(30.0444, 31.2357),
        const LatLng(30.0444, 31.2357),
      );

      expect(distance, 0);
    });

    test('circle distance is positive for different points', () {
      final distance = service.checkAccessibleAreaForCircle(
        const LatLng(30.0444, 31.2357),
        const LatLng(30.0500, 31.2400),
      );

      expect(distance, greaterThan(0));
    });

    test('polygon check returns true for point inside polygon', () async {
      final isInside = await service.checkAccessibleAreaForPolygon(
        const LatLng(30.0500, 31.2500),
        const [
          LatLng(30.0000, 31.2000),
          LatLng(30.1000, 31.2000),
          LatLng(30.1000, 31.3000),
          LatLng(30.0000, 31.3000),
        ],
      );

      expect(isInside, isTrue);
    });

    test('polygon check returns false for point outside polygon', () async {
      final isInside = await service.checkAccessibleAreaForPolygon(
        const LatLng(31.0000, 32.0000),
        const [
          LatLng(30.0000, 31.2000),
          LatLng(30.1000, 31.2000),
          LatLng(30.1000, 31.3000),
          LatLng(30.0000, 31.3000),
        ],
      );

      expect(isInside, isFalse);
    });
  });
}
