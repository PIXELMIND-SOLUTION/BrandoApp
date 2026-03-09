// // lib/constants/api_constants.dart

// class ApiConstants {
//   ApiConstants._();

//   // Base URL
//   static const String baseUrl = 'http://31.97.206.144:2003';

//   // API Version / Prefix
//   static const String apiPrefix = '/api';

//   // ─── Auth Endpoints ──────────────────────────────────────────────────────
//   static const String sendOtp = '$apiPrefix/auth/send-otp';
//   static const String verifyOtp = '$apiPrefix/auth/verify-otp';
//   static const String updateLocation = '$apiPrefix/auth/update-location';

//   // ─── Hostel Endpoints ────────────────────────────────────────────────────
//   static const String nearbyHostels = '$apiPrefix/auth/nearby-hostels';

//   // ─── Full URLs (convenience) ─────────────────────────────────────────────
//   static const String sendOtpUrl = '$baseUrl$sendOtp';
//   static const String verifyOtpUrl = '$baseUrl$verifyOtp';
//   static const String updateLocationUrl = '$baseUrl$updateLocation';

//   // Dynamic URL builders
//   static String nearbyHostelsUrl(String userId) =>
//       '$baseUrl$nearbyHostels/$userId';

//   // ─── Headers ─────────────────────────────────────────────────────────────
//   static const String contentTypeHeader = 'Content-Type';
//   static const String authorizationHeader = 'Authorization';
//   static const String contentTypeJson = 'application/json';
//   static const String bearerPrefix = 'Bearer ';

//   // ─── Timeouts ────────────────────────────────────────────────────────────
//   static const int connectTimeoutMs = 15000;
//   static const int receiveTimeoutMs = 15000;
// }
















// lib/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'http://31.97.206.144:2003';

  // API Version / Prefix
  static const String apiPrefix = '/api';

  // ─── Auth Endpoints ──────────────────────────────────────────────────────
  static const String sendOtp        = '$apiPrefix/auth/send-otp';
  static const String verifyOtp      = '$apiPrefix/auth/verify-otp';
  static const String updateLocation = '$apiPrefix/auth/update-location';
  static const String updateProfile  = '$apiPrefix/auth/update-profile';  // ← NEW

  // ─── Hostel Endpoints ────────────────────────────────────────────────────
  static const String nearbyHostels = '$apiPrefix/auth/nearby-hostels';

  // ─── Full URLs (convenience) ─────────────────────────────────────────────
  static const String sendOtpUrl        = '$baseUrl$sendOtp';
  static const String verifyOtpUrl      = '$baseUrl$verifyOtp';
  static const String updateLocationUrl = '$baseUrl$updateLocation';
  static const String updateProfileUrl  = '$baseUrl$updateProfile';       // ← NEW

  // ─── Dynamic URL builders ────────────────────────────────────────────────
  static String nearbyHostelsUrl(String userId) =>
      '$baseUrl$nearbyHostels/$userId';

  static String getUserProfileUrl(String userId) =>                       // ← NEW
      '$baseUrl$apiPrefix/auth/user/$userId';

  // ─── Headers ─────────────────────────────────────────────────────────────
  static const String contentTypeHeader    = 'Content-Type';
  static const String authorizationHeader  = 'Authorization';
  static const String contentTypeJson      = 'application/json';
  static const String bearerPrefix         = 'Bearer ';

  // ─── Timeouts ────────────────────────────────────────────────────────────
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}