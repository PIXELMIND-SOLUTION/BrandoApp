class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://187.127.146.52:2003';

  static const String apiPrefix = '/api';

  static const String sendOtp = '$apiPrefix/auth/send-otp';
  static const String verifyOtp = '$apiPrefix/auth/verify-otp';
  static const String updateLocation = '$apiPrefix/auth/update-location';
  static const String updateProfile = '$apiPrefix/auth/update-profile';
  static const String nearbyHostels = '$apiPrefix/auth/nearby-hostels';

  static const String recHostels = '$apiPrefix/auth/recomended-hostels';
  static const String addtowishlist = '$apiPrefix/auth/wishlist/toggle';
  static const String getmywishlist = '$apiPrefix/auth/wishlist';

  static const String bookingRequest = '$apiPrefix/auth/booking-request';

  static String upgradeBookingUrl(String bookingId) =>
      '$baseUrl$apiPrefix/auth/upgradebooking/$bookingId';

  static String bookingRequestUrl(String userId, String hostelId) =>
      '$baseUrl$bookingRequest/$userId/$hostelId';

  static const String hostelBooking = '$apiPrefix/auth/hostel-booking';

  static String hostelBookingUrl(String userId, String hostelId) =>
      '$baseUrl$hostelBooking/$userId/$hostelId';

  static const String sendOtpUrl = '$baseUrl$sendOtp';
  static const String verifyOtpUrl = '$baseUrl$verifyOtp';
  static const String updateLocationUrl = '$baseUrl$updateLocation';
  static const String updateProfileUrl = '$baseUrl$updateProfile';
  static const String addtowishlisturl = '$baseUrl$addtowishlist';
  static const String getwishlisturl = '$baseUrl$getmywishlist';
  static String nearbyHostelsUrl(String userId) =>
      '$baseUrl$nearbyHostels/$userId';

  static String recHostelsUrl(String userId) => '$baseUrl$recHostels/$userId';

  static String getUserProfileUrl(String userId) =>
      '$baseUrl$apiPrefix/auth/user/$userId';

  static String submitBookingFormUrl(String userId, String bookingId) =>
      '$baseUrl$apiPrefix/auth/$userId/bookings/$bookingId/submit-form';

  static const String createBooking = '$apiPrefix/auth/createBooking';
  static const String createBookingUrl = '$baseUrl$createBooking';

  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeJson = 'application/json';
  static const String bearerPrefix = 'Bearer ';

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}
