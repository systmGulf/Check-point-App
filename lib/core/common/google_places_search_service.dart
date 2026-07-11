import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GooglePlacesSearchService {
  static const String _apiKey = 'AIzaSyBmhmNVQufGCy8Iruka77zE4C0Uq2YpDDI';

  Future<List<GooglePlaceSuggestion>> autocomplete(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': _apiKey,
        'language': 'ar',
        'components': 'country:eg',
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final predictions = (json['predictions'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(
          (prediction) => GooglePlaceSuggestion(
            placeId: prediction['place_id'] as String? ?? '',
            description: prediction['description'] as String? ?? '',
          ),
        )
        .where((prediction) => prediction.placeId.isNotEmpty)
        .toList();

    return predictions;
  }

  Future<GooglePlaceLocation?> getPlaceLocation(String placeId) async {
    if (placeId.isEmpty) return null;

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'fields': 'geometry/location,formatted_address,name',
        'key': _apiKey,
        'language': 'ar',
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final result = json['result'] as Map<String, dynamic>?;
    final geometry = result?['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    final lat = (location?['lat'] as num?)?.toDouble();
    final lng = (location?['lng'] as num?)?.toDouble();

    if (lat == null || lng == null) return null;

    return GooglePlaceLocation(
      latLng: LatLng(lat, lng),
      address: result?['formatted_address'] as String? ??
          result?['name'] as String? ??
          '',
    );
  }
}

class GooglePlaceSuggestion {
  const GooglePlaceSuggestion({
    required this.placeId,
    required this.description,
  });

  final String placeId;
  final String description;
}

class GooglePlaceLocation {
  const GooglePlaceLocation({
    required this.latLng,
    required this.address,
  });

  final LatLng latLng;
  final String address;
}
