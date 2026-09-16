import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';

class NominatimService {
  static final Dio _dio = Dio();

  /// Gets the address from coordinates using OpenStreetMap Nominatim API
  static Future<String?> getAddressFromLatLng(LatLng coordinates) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': coordinates.latitude,
          'lon': coordinates.longitude,
          'format': 'json',
          'accept-language': 'ar', // Get address in Arabic
        },
        options: Options(
          headers: {
            'User-Agent': 'atoz_new_admin/1.0.0', // Required by OpenStreetMap policy
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['display_name'] != null) {
          return data['display_name'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Nominatim API error: $e');
      return null;
    }
  }
}
