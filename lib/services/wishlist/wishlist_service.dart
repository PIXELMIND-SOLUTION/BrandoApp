import 'dart:convert';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/wishlist_model.dart';
import 'package:dio/dio.dart';

class WishlistService {
  WishlistService._();
  static final WishlistService instance = WishlistService._();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: ApiConstants.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeoutMs),
      headers: {ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson},
    ),
  );

  Map<String, String> get _authHeaders {
    final token = AppPreferences.getAuthToken();
    return {
      ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
      if (token != null)
        ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix}$token',
    };
  }

  // ─── Toggle Wishlist (Add / Remove) ───────────────────────────────────────

  Future<WishlistToggleResponse> toggleWishlist({
    required String hostelId,
  }) async {
    final userId = AppPreferences.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not logged in. Please log in and try again.');
    }

    try {
      final response = await _dio.post(
        ApiConstants.addtowishlisturl,
        data: jsonEncode({'userId': userId, 'hostelId': hostelId}),
        options: Options(headers: _authHeaders),
      );

      print(
        'Response status code for add to wishlist and remove from wishlist ${response.statusCode}',
      );

      print(
        'Response boddddddddyyyyyyyyyyyyyy  add to wishlist and remove from wishlist ${response.data}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return WishlistToggleResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw Exception(
        'Toggle wishlist failed with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ─── Get My Wishlist ──────────────────────────────────────────────────────

  Future<GetWishlistResponse> getMyWishlist() async {
    final userId = AppPreferences.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not logged in. Please log in and try again.');
    }

    // Build URL: base + /api/auth/wishlist/{userId}
    final url = '${ApiConstants.getwishlisturl}/$userId';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: _authHeaders),
      );

      print(
        'Response status code for get my wishlistttttt ${response.statusCode}',
      );
      print('Response bodyyyyyyyyyy for get my wishlistttttt ${response.data}');

      if (response.statusCode == 200) {
        return GetWishlistResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw Exception(
        'Get wishlist failed with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ─── Error Handler ────────────────────────────────────────────────────────

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Something went wrong.';
        if (statusCode == 401) return Exception('Unauthorized: $message');
        if (statusCode == 404) return Exception('Not found: $message');
        return Exception('Server error ($statusCode): $message');
      default:
        return Exception(e.message ?? 'An unexpected error occurred.');
    }
  }
}
