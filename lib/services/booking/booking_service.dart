// lib/features/booking/services/booking_service.dart

import 'dart:convert';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/booking_model.dart';
import 'package:dio/dio.dart';

class BookingService {
  final Dio _dio;

  BookingService({Dio? dio}) : _dio = dio ?? Dio();

  Future<BookingRequestModel> sendBookingRequest({
    required String userId,
    required String hostelId,
  }) async {
    final token = AppPreferences.getAuthToken();

    if (token == null) {
      throw Exception('User is not authenticated.');
    }

    final url = ApiConstants.bookingRequestUrl(userId, hostelId);

    final response = await _dio.post(
      url,
      options: Options(
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
          ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix}$token',
        },
        sendTimeout: const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
      ),
    );


    print('Status codeeeeeeeeeeeeeeeeeeeeee: ${response.statusCode}');
        print('Status bodyyyyyyyyyy: ${response.data}');


    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;

    if (data['success'] == true && data['bookingRequest'] != null) {
      return BookingRequestModel.fromJson(
        data['bookingRequest'] as Map<String, dynamic>,
      );
    }

    throw Exception(data['message'] ?? 'Failed to send booking request.');
  }
}