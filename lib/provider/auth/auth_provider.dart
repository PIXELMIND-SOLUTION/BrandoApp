import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/user_model.dart';
import 'package:brando_app/services/auth/auth_services.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus { idle, loading, otpSent, verified, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService.instance;


  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  String? _preOtpToken;
  String? _authToken;
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  // ─── Getters ──────────────────────────────────────────────────────────────

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get preOtpToken => _preOtpToken;
  String? get authToken => _authToken;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _status == AuthStatus.loading;

  // ─── Init (call on app start) ─────────────────────────────────────────────

  Future<void> init() async {
    await AppPreferences.init();
    _isLoggedIn = AppPreferences.isLoggedIn();
    _authToken = AppPreferences.getAuthToken();

    final userId = AppPreferences.getUserId();
    final mobile = AppPreferences.getMobileNumber();
    if (userId != null && mobile != null) {
      _currentUser = UserModel(id: userId, mobileNumber: mobile);
    }

    _status = _isLoggedIn ? AuthStatus.verified : AuthStatus.idle;
    notifyListeners();
  }

  // ─── Send OTP ─────────────────────────────────────────────────────────────

  Future<void> sendOtp(String mobileNumber) async {
    _setLoading();

    try {
      final response = await _authService.sendOtp(mobileNumber);

      _preOtpToken = response.token;
      await AppPreferences.setPreOtpToken(response.token);
      await AppPreferences.setMobileNumber(mobileNumber);

      _status = AuthStatus.otpSent;
      _errorMessage = null;
    } on AuthException catch (e) {
      print('AuthException caught: ${e.message}');
      _setError(e.message);
    } catch (e) {
      print('Unknown error: $e');
      _setError('Something went wrong. Please try again.');
    }

    notifyListeners();
  }

  // ─── Verify OTP ───────────────────────────────────────────────────────────

  Future<void> verifyOtp(String otp) async {
    final token = _preOtpToken ?? AppPreferences.getPreOtpToken();

    if (token == null) {

       print('tokeeeeeeeeeeeeeeeeeeeeeeennnnnnnnnnnn $token');

      _setError('Session expired. Please request OTP again.');
      notifyListeners();
      return;
    }

    _setLoading();

    try {
      final response = await _authService.verifyOtp(token: token, otp: otp);

      _authToken = response.token;
      _currentUser = response.user;
      _isLoggedIn = true;

      await AppPreferences.setAuthToken(response.token);
      await AppPreferences.setUserId(response.user.id);
      await AppPreferences.setMobileNumber(response.user.mobileNumber);
      await AppPreferences.setLoggedIn(true);
      await AppPreferences.removePreOtpToken();

      _status = AuthStatus.verified;
      _errorMessage = null;
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (_) {
      _setError('Verification failed. Please try again.');
    }

    notifyListeners();
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await AppPreferences.clearAll();

    _status = AuthStatus.idle;
    _errorMessage = null;
    _preOtpToken = null;
    _authToken = null;
    _currentUser = null;
    _isLoggedIn = false;

    notifyListeners();
  }

  // ─── Reset error ──────────────────────────────────────────────────────────

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _isLoggedIn ? AuthStatus.verified : AuthStatus.idle;
    }
    notifyListeners();
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
  }
}
