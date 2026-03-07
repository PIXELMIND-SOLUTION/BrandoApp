class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'http://31.97.206.144:2003';

  // API Version / Prefix
  static const String apiPrefix = '/api';

  // Auth Endpoints
  static const String sendOtp = '$apiPrefix/auth/send-otp';
  static const String verifyOtp = '$apiPrefix/auth/verify-otp';

  // Full URLs (convenience)
  static const String sendOtpUrl = '$baseUrl$sendOtp';
  static const String verifyOtpUrl = '$baseUrl$verifyOtp';

  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeJson = 'application/json';
  static const String bearerPrefix = 'Bearer ';

  // Timeouts
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}