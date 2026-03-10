class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'http://31.97.206.144:2003';

  static const String apiPrefix = '/api';

  static const String sendOtp = '$apiPrefix/auth/send-otp';
  static const String verifyOtp = '$apiPrefix/auth/verify-otp';
  static const String updateLocation = '$apiPrefix/auth/update-location';
  static const String updateProfile = '$apiPrefix/auth/update-profile';
  static const String nearbyHostels = '$apiPrefix/auth/nearby-hostels';
  static const String addtowishlist = '$apiPrefix/auth/wishlist/toggle';
  static const String getmywishlist = '$apiPrefix/auth/wishlist';
  static const String createbooking ='$apiPrefix/auth/createBooking';

  static const String sendOtpUrl = '$baseUrl$sendOtp';
  static const String verifyOtpUrl = '$baseUrl$verifyOtp';
  static const String updateLocationUrl = '$baseUrl$updateLocation';
  static const String updateProfileUrl = '$baseUrl$updateProfile';
  static const String addtowishlisturl = '$baseUrl$addtowishlist';
  static const String getwishlisturl = '$baseUrl$getmywishlist';
  static String nearbyHostelsUrl(String userId) =>
      '$baseUrl$nearbyHostels/$userId';

  static String getUserProfileUrl(String userId) =>
      '$baseUrl$apiPrefix/auth/user/$userId';

  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeJson = 'application/json';
  static const String bearerPrefix = 'Bearer ';

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}
