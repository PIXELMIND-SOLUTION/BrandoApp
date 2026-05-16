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
    required String bookingId,
    required HostelBookingRequestModel request,
  }) async {
    try {
      final token = AppPreferences.getAuthToken();

      final url = ApiConstants.submitBookingFormUrl(userId, bookingId);

      /// Create FormData
      final formData = FormData();

      /// Add text fields
      formData.fields.addAll([
        MapEntry('name', request.name),
        MapEntry('mobileNumber', request.mobileNumber),
        MapEntry('roomNo', request.roomNo),
        MapEntry('emergencyNumber', request.emergencyNumber),
        // Add bookingType and totalAmount
        MapEntry('bookingType', request.bookingType),
        MapEntry('totalAmount', request.totalAmount.toString()),
      ]);

      /// Optional fields
      if (request.email?.isNotEmpty == true) {
        formData.fields.add(MapEntry('email', request.email!));
      }

      if (request.roomType?.isNotEmpty == true) {
        formData.fields.add(MapEntry('roomType', request.roomType!));
      }

      if (request.shareType?.isNotEmpty == true) {
        formData.fields.add(MapEntry('shareType', request.shareType!));
      }

      /// Aadhar images (multiple)
      if (request.aadharCardImage.isNotEmpty) {
        for (int i = 0; i < request.aadharCardImage.length; i++) {
          String path = request.aadharCardImage[i];
          formData.files.add(
            MapEntry('aadharCardImage', await _toMultipartFile(path)),
          );
        }
      }

      /// PAN images (multiple)
      if (request.panCardImage.isNotEmpty) {
        for (int i = 0; i < request.panCardImage.length; i++) {
          String path = request.panCardImage[i];
          formData.files.add(
            MapEntry('panCardImage', await _toMultipartFile(path)),
          );
        }
      }

      /// Profile image
      if (request.profileImage.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await _toMultipartFile(request.profileImage),
          ),
        );
      }

      /// Debug logs
      print('=== Submitting Booking Request ===');
      print('URL: $url');
      print('User ID: $userId');
      print('Booking ID: $bookingId');
      print('Token present: ${token != null}');
      print('Name: ${request.name}');
      print('Mobile: ${request.mobileNumber}');
      print('Room No: ${request.roomNo}');
      print('Emergency: ${request.emergencyNumber}');
      print('Room Type: ${request.roomType}');
      print('Share Type: ${request.shareType}');
      print('Booking Type: ${request.bookingType}'); // Added
      print('Total Amount: ${request.totalAmount}'); // Added
      print('Aadhar Images count: ${request.aadharCardImage.length}');
      print('PAN Images count: ${request.panCardImage.length}');
      print('Profile Image: ${request.profileImage}');

      print('====== FILES SENT ======');
      for (var file in formData.files) {
        print('${file.key} -> ${file.value.filename}');
      }
      print('====== FORM FIELDS ======');
      for (var field in formData.fields) {
        print('${field.key}: ${field.value}');
      }
      print('========================');

      /// API Call
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              ApiConstants.authorizationHeader:
                  '${ApiConstants.bearerPrefix}$token',
          },
        ),
      );

      print('Status Code [submitBooking]: ${response.statusCode}');
      print('Response Body [submitBooking]: ${response.data}');

      return HostelBookingResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);

      print('❌ DioException in submitBooking: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');

      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Unexpected error in submitBooking: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;

      if (data is Map) {
        return data['message'] ??
            data['error'] ??
            e.message ??
            'Booking failed';
      }

      return data.toString();
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';

      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      default:
        return e.message ?? 'Booking failed. Please try again.';
    }
  }

  Future<MultipartFile> _toMultipartFile(String filePath) async {
    final file = File(filePath);

    /// Check file exists
    if (!await file.exists()) {
      throw Exception('File does not exist: $filePath');
    }

    final fileName = file.path.split('/').last;

    final ext = fileName.split('.').last.toLowerCase();

    final contentType = _getContentType(ext);

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      filename: fileName,
      contentType: contentType,
    );

    print(
      '✅ Created MultipartFile: '
      '$fileName '
      '(${contentType.mimeType})',
    );

    return multipartFile;
  }

  MediaType _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');

      case 'png':
        return MediaType('image', 'png');

      case 'webp':
        return MediaType('image', 'webp');

      case 'gif':
        return MediaType('image', 'gif');

      case 'bmp':
        return MediaType('image', 'bmp');

      default:
        return MediaType('image', 'jpeg');
    }
  }
}
