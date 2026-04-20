import 'dart:io';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/submit_hostel_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class HostelBookingService {
  final Dio _dio;

  HostelBookingService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: Duration(
                milliseconds: ApiConstants.connectTimeoutMs,
              ),
              receiveTimeout: Duration(
                milliseconds: ApiConstants.receiveTimeoutMs,
              ),
            ),
          );

  Future<HostelBookingResponseModel> submitBooking({
    required String userId,
    required String hostelId,
    required HostelBookingRequestModel request,
  }) async {
    try {
      final token = AppPreferences.getAuthToken();

      final formData = FormData.fromMap({
        'name': request.name,
        'mobileNumber': request.mobileNumber,
        'roomNo': request.roomNo,
        'roomType': request.roomType,
        'shareType': request.shareType,
        'email': request.email,
        'aadharCardImage': await _toMultipartFile(request.aadharCardImagePath),
        'panCardImage': await _toMultipartFile(request.panCardImagePath),
        'profileImage': await _toMultipartFile(request.profileImagePath),
      });

      final response = await _dio.post(
        ApiConstants.hostelBookingUrl(userId, hostelId),
        data: formData,
        options: Options(
          headers: {
            if (token != null)
              ApiConstants.authorizationHeader:
                  '${ApiConstants.bearerPrefix}$token',
          },
        ),
      );

      print('Status Codeeeeeeeeeeeeeeeeee for submit booking: ${response.statusCode}');

      print('Response Bodyyyyyyyyyyyyyyyyyyyy for submit booking : ${response.data}');

      return HostelBookingResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Booking failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<MultipartFile> _toMultipartFile(String filePath) async {
    final file = File(filePath);
    final fileName = file.path.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();

    final contentType = switch (ext) {
      'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      _ => MediaType('image', 'jpeg'),
    };

    return MultipartFile.fromFile(
      filePath,
      filename: fileName,
      contentType: contentType,
    );
  }
}
