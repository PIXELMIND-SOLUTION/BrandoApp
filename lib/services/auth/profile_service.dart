// lib/services/profile_service.dart

import 'dart:io';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/models/profile_model.dart';
import 'package:dio/dio.dart';

class ProfileService {
  ProfileService._();
  static final ProfileService instance = ProfileService._();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: ApiConstants.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeoutMs),
    ),
  );

  /// Fetch user profile by userId
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _dio.get(ApiConstants.getUserProfileUrl(userId));

      print('Response status code for get user profile ${response.statusCode}');
      print(
        'Response bodyyyyyyyyyyyyyyy for get user profile ${response.headers}',
      );

      // if (response.statusCode == 200 && response.data['success'] == true) {
      //   return UserProfileModel.fromJson(response.data['user']);
      // }

      if (response.statusCode == 200 && response.data['success'] == true) {
        // ADD THIS
        print('RAW USER JSON: ${response.data['user']}');
        print('USER JSON TYPE: ${response.data['user'].runtimeType}');
        print(
          'LOCATION TYPE: ${response.data['user']['location'].runtimeType}',
        );
        print('LOCATION DATA: ${response.data['user']['location']}');

        return UserProfileModel.fromJson(response.data['user']);
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch profile');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserProfileModel> updateProfile({
    required String userId,
    String? name,
    File? profileImage,
  }) async {
    try {
      print('uaerrrrrrrrrrrrrrrr iddddddddddddd $userId');
      final formData = FormData.fromMap({
        'userId': userId,
        if (name != null && name.isNotEmpty) 'name': name,
        if (profileImage != null)
          'profileImage': await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
          ),
      });


      final response = await _dio.put(
        ApiConstants.updateProfileUrl,
        data: formData,
      );
      print(
        'Response status code for updateeeeeeeeeee profile ${response.statusCode}',
      );
      print(
        'Response bodyyyyyyyyyyyyyyy for get user profile ${response.data}',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserProfileModel.fromJson(response.data['user']);
      }

      throw Exception(response.data['message'] ?? 'Failed to update profile');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        final msg = e.response?.data?['message'];
        return Exception(msg ?? 'Something went wrong. Please try again.');
    }
  }
}
