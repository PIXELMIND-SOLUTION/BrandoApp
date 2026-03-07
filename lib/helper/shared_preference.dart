import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();

  static SharedPreferences? _prefs;

  // Keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyPreOtpToken = 'pre_otp_token';
  static const String _keyUserId = 'user_id';
  static const String _keyMobileNumber = 'mobile_number';
  static const String _keyIsLoggedIn = 'is_logged_in';

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    assert(_prefs != null, 'AppPreferences.init() must be called before use.');
    return _prefs!;
  }

  // ─── Auth Token (post-verify) ────────────────────────────────────────────

  static Future<bool> setAuthToken(String token) =>
      _instance.setString(_keyAuthToken, token);

  static String? getAuthToken() => _instance.getString(_keyAuthToken);

  static Future<bool> removeAuthToken() => _instance.remove(_keyAuthToken);

  // ─── Pre-OTP Token (from send-otp response) ──────────────────────────────

  static Future<bool> setPreOtpToken(String token) =>
      _instance.setString(_keyPreOtpToken, token);

  static String? getPreOtpToken() => _instance.getString(_keyPreOtpToken);

  static Future<bool> removePreOtpToken() => _instance.remove(_keyPreOtpToken);

  // ─── User Info ───────────────────────────────────────────────────────────

  static Future<bool> setUserId(String userId) =>
      _instance.setString(_keyUserId, userId);

  static String? getUserId() => _instance.getString(_keyUserId);

  static Future<bool> setMobileNumber(String mobile) =>
      _instance.setString(_keyMobileNumber, mobile);

  static String? getMobileNumber() => _instance.getString(_keyMobileNumber);

  // ─── Login State ─────────────────────────────────────────────────────────

  static Future<bool> setLoggedIn(bool value) =>
      _instance.setBool(_keyIsLoggedIn, value);

  static bool isLoggedIn() => _instance.getBool(_keyIsLoggedIn) ?? false;

  // ─── Clear All (Logout) ──────────────────────────────────────────────────

  static Future<bool> clearAll() => _instance.clear();
}