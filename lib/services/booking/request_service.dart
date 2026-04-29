import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/request_model.dart';
import 'package:http/http.dart' as http;

class BookingApiService {
  static const String _baseUrl = 'http://187.127.146.52:2003/api/auth';

  static Future<List<BookingRequest>> fetchMyBookings(String userId) async {
    final token = AppPreferences.getAuthToken();
    final uri = Uri.parse('$_baseUrl/mybookingrequest/$userId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('Response status code for get my bookings ${response.statusCode}');
    print('Response boddddddddddddddy for get my bookings ${response.body}');

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);

      // Handle both list and object responses
      List<dynamic> rawList;
      if (decoded is List) {
        rawList = decoded;
      } else if (decoded is Map) {
        rawList =
            decoded['data'] ??
            decoded['bookings'] ??
            decoded['requests'] ??
            decoded['result'] ??
            [];
      } else {
        rawList = [];
      }

      return rawList
          .map((e) => BookingRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load bookings. Status: ${response.statusCode}',
      );
    }
  }
}
