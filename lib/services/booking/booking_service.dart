import 'dart:convert';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/booking_model.dart';
import 'package:dio/dio.dart';

class BookingService {
  final Dio _dio;

  BookingService({Dio? dio}) : _dio = dio ?? Dio();

  Future<BookingRequestModel> createBooking({
    required String hostelId,
    required String userId,
    required String roomType,
    required String shareType,
    required String bookingType,
    required String startDate,
    bool isTrue = true,
  }) async {
    final token = AppPreferences.getAuthToken();

    if (token == null) {
      throw Exception('User is not authenticated.');
    }

    try {
      final payload = {
        'hostelId': hostelId,
        'userId': userId,
        'roomType': roomType,
        'shareType': shareType,
        'bookingType': bookingType,
        'startDate': startDate,
        'isTrue': isTrue,
      };

      // ✅ Print Payload
      print("Request Payload: ${jsonEncode(payload)}");

      final response = await _dio.post(
        ApiConstants.createBookingUrl,
        data: payload,
        options: Options(
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
            ApiConstants.authorizationHeader:
                '${ApiConstants.bearerPrefix}$token',
          },
          sendTimeout:
              const Duration(milliseconds: ApiConstants.connectTimeoutMs),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        ),
      );

      print("Status Code: ${response.statusCode}");

      // ✅ Print Full Response Body
      print("Response Body: ${response.data}");

      final data = response.data is String
          ? jsonDecode(response.data as String) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      if (data['success'] == true && data['booking'] != null) {
        return BookingRequestModel.fromJson(
          data['booking'] as Map<String, dynamic>,
        );
      }

      throw Exception(data['message'] ?? 'Failed to create booking.');
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData != null) {
        final body = responseData is String
            ? jsonDecode(responseData) as Map<String, dynamic>
            : responseData as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Booking failed.');
      }
      throw Exception('Network error. Please try again.');
    }
  }
}