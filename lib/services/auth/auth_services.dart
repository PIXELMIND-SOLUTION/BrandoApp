import 'dart:convert';
import 'dart:io';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
    ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
  };

  // Map<String, String> _authHeaders(String token) => {
  //   ..._headers,
  //   ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix}$token',
  // };

  Future<SendOtpResponse> sendOtp(String mobileNumber) async {
    try {
      final request = SendOtpRequest(mobileNumber: mobileNumber);

      final response = await _client
          .post(
            Uri.parse(ApiConstants.sendOtpUrl),
            headers: _headers,
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectTimeoutMs));

      final body = _parseBody(response);

      print('Response status code for send otp ${response.statusCode}');
      print('Response bodyyyyyyyyyyyyyy  for send otp ${response.body}');

      // print(object)

      if (response.statusCode == 200 && body['success'] == true) {
        return SendOtpResponse.fromJson(body);
      }

      throw AuthException(
        message: body['message'] as String? ?? 'Failed to send OTP',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw AuthException(message: 'No internet connection');
    } on HttpException {
      throw AuthException(message: 'Server error. Please try again');
    }
  }

  // ─── Verify OTP ───────────────────────────────────────────────────────────
  Future<VerifyOtpResponse> verifyOtp({
    required String token,
    required String otp,
  }) async {
    try {
      final request = VerifyOtpRequest(token: token, otp: otp);

      final response = await _client
          .post(
            Uri.parse(ApiConstants.verifyOtpUrl),
            headers: _headers,
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectTimeoutMs));

      final body = _parseBody(response);

      print(
        'Response status code for verifyyyyyyyyyyyy otp ${response.statusCode}',
      );
      print(
        'Response bodyyyyyyyyyyyyyy  for verifyyyyyyyyyyyyyy otp ${response.body}',
      );

      if (response.statusCode == 200 && body['success'] == true) {
        return VerifyOtpResponse.fromJson(body);
      }

      throw AuthException(
        message: body['message'] as String? ?? 'OTP verification failed',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw AuthException(message: 'No internet connection');
    } on HttpException {
      throw AuthException(message: 'Server error. Please try again');
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _parseBody(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw AuthException(message: 'Invalid response from server');
    }
  }

  void dispose() => _client.close();
}

// ─── Custom Exception ─────────────────────────────────────────────────────────

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({required this.message, this.statusCode});

  @override
  String toString() =>
      'AuthException: $message${statusCode != null ? ' (status: $statusCode)' : ''}';
}
