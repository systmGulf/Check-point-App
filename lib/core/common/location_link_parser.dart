import 'dart:async';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationLinkParser {
  /// Attempts to parse a [LatLng] from a string input.
  /// The input can be raw coordinates ("30.044, 31.235"),
  /// a Google Maps URL, or a shortened link (e.g., maps.app.goo.gl).
  static Future<LatLng?> parseLocation(String input) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    // 1. Try parsing directly from text / URL patterns
    LatLng? parsed = _extractCoordinatesFromText(trimmed);
    if (parsed != null) return parsed;

    // 2. If it's an HTTP/HTTPS URL (e.g. goo.gl or maps.app.goo.gl), resolve redirect
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 4);
        final request = await client.getUrl(Uri.parse(trimmed));
        request.followRedirects = true;
        request.maxRedirects = 5;
        final response = await request.close();
        final redirectLocation = response.headers.value(HttpHeaders.locationHeader);
        final finalUrl = response.redirects.isNotEmpty
            ? response.redirects.last.location.toString()
            : (redirectLocation ?? trimmed);
        client.close();

        if (finalUrl.isNotEmpty) {
          parsed = _extractCoordinatesFromText(finalUrl);
          if (parsed != null) return parsed;
        }
      } catch (_) {
        // Ignore network errors during link resolution
      }
    }

    return null;
  }

  static LatLng? _extractCoordinatesFromText(String text) {
    // Pattern 1: @latitude,longitude (e.g. @30.044421,31.235712)
    final atPattern = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
    final atMatch = atPattern.firstMatch(text);
    if (atMatch != null) {
      final lat = double.tryParse(atMatch.group(1)!);
      final lng = double.tryParse(atMatch.group(2)!);
      if (lat != null && lng != null) return LatLng(lat, lng);
    }

    // Pattern 2: Query parameters like q=30.044421,31.235712 or ll=... or destination=... or center=...
    final queryPattern =
        RegExp(r'[?&](?:q|ll|destination|center)=(-?\d+\.\d+),(-?\d+\.\d+)');
    final queryMatch = queryPattern.firstMatch(text);
    if (queryMatch != null) {
      final lat = double.tryParse(queryMatch.group(1)!);
      final lng = double.tryParse(queryMatch.group(2)!);
      if (lat != null && lng != null) return LatLng(lat, lng);
    }

    // Pattern 3: URL path segments like /place/30.044421,31.235712 or /dir/30.044421,31.235712
    final pathPattern =
        RegExp(r'/(?:place|dir)/[^/]*?(-?\d+\.\d+),(-?\d+\.\d+)');
    final pathMatch = pathPattern.firstMatch(text);
    if (pathMatch != null) {
      final lat = double.tryParse(pathMatch.group(1)!);
      final lng = double.tryParse(pathMatch.group(2)!);
      if (lat != null && lng != null) return LatLng(lat, lng);
    }

    // Pattern 4: Simple raw coordinates "30.044421, 31.235712" or "30.044421 31.235712"
    final rawPattern =
        RegExp(r'^#?\s*(-?\d+\.\d+)\s*[\s,]\s*(-?\d+\.\d+)\s*$');
    final rawMatch = rawPattern.firstMatch(text);
    if (rawMatch != null) {
      final lat = double.tryParse(rawMatch.group(1)!);
      final lng = double.tryParse(rawMatch.group(2)!);
      if (lat != null && lng != null) return LatLng(lat, lng);
    }

    // Pattern 5: Any pair of decimal numbers lat,lng anywhere in text if looks like valid coords
    final generalPattern =
        RegExp(r'(-?\d{1,2}\.\d+)\s*,\s*(-?\d{1,3}\.\d+)');
    final generalMatch = generalPattern.firstMatch(text);
    if (generalMatch != null) {
      final lat = double.tryParse(generalMatch.group(1)!);
      final lng = double.tryParse(generalMatch.group(2)!);
      if (lat != null && lng != null) {
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          return LatLng(lat, lng);
        }
      }
    }

    return null;
  }
}
