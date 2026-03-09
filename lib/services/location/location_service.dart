// lib/services/hostel_service.dart

import 'dart:convert';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/hostel_model.dart';
import 'package:http/http.dart' as http;

class HostelService {
  HostelService._();
  static final HostelService instance = HostelService._();

  Map<String, String> get _headers => {
    ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
    if (AppPreferences.getAuthToken() != null)
      ApiConstants.authorizationHeader:
          '${ApiConstants.bearerPrefix}${AppPreferences.getAuthToken()}',
  };

  // ─── Update User Location ────────────────────────────────────────────────

  Future<UpdateLocationResponse> updateLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(ApiConstants.updateLocationUrl),
            headers: _headers,
            body: jsonEncode({
              'userId': userId,
              'latitude': latitude,
              'longitude': longitude,
            }),
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectTimeoutMs));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      print('Response status code for update location ${response.statusCode}');
      print(
        'Response bodyyyyyyyyyyyyyyyy for update location ${response.body}',
      );

      if (response.statusCode == 200 && data['success'] == true) {
        return UpdateLocationResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Failed to update location');
      }
    } catch (e) {
      throw Exception('Update location error: $e');
    }
  }

  // ─── Fetch Nearby Hostels ────────────────────────────────────────────────

  Future<NearbyHostelsResponse> getNearbyHostels(String userId) async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConstants.nearbyHostelsUrl(userId)),
            headers: _headers,
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectTimeoutMs));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      print(
        'Response status code for get hostelssssssssssssss ${response.statusCode}',
      );
      print(
        'Response bodyyyyyyyyyyyyyyyy for get hostelssssssssssss ${response.body}',
      );

      if (response.statusCode == 200 && data['success'] == true) {
        return NearbyHostelsResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch nearby hostels');
      }
    } catch (e) {
      throw Exception('Nearby hostels error: $e');
    }
  }

  // ─── Update Location + Fetch Hostels in one call ─────────────────────────

  Future<NearbyHostelsResponse> updateLocationAndFetchHostels({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    await updateLocation(
      userId: userId,
      latitude: latitude,
      longitude: longitude,
    );
    return getNearbyHostels(userId);
  }
}
