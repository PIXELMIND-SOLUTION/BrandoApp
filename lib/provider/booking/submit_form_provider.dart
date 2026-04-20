import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/submit_hostel_model.dart';
import 'package:brando_app/services/booking/submit_form_service.dart';
import 'package:flutter/foundation.dart';

enum BookingStatus { idle, loading, success, error }

class HostelBookingProvider extends ChangeNotifier {
  final HostelBookingService _service;

  HostelBookingProvider({HostelBookingService? service})
      : _service = service ?? HostelBookingService();

  BookingStatus _status = BookingStatus.idle;
  BookingDetails? _bookingDetails;
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────

  BookingStatus get status => _status;
  BookingDetails? get bookingDetails => _bookingDetails;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == BookingStatus.loading;
  bool get isSuccess => _status == BookingStatus.success;

  // ─── Submit Booking ───────────────────────────────────────────────────────

  Future<bool> submitBooking({
    required String hostelId,
    required HostelBookingRequestModel request,
  }) async {
    final userId = AppPreferences.getUserId();

    if (userId == null) {
      _setError('User not logged in. Please login again.');
      return false;
    }

    _setLoading();

    try {
      final response = await _service.submitBooking(
        userId: userId,
        hostelId: hostelId,
        request: request,
      );

      if (response.success) {
        _bookingDetails = response.booking;
        _status = BookingStatus.success;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  // ─── Reset ────────────────────────────────────────────────────────────────

  void reset() {
    _status = BookingStatus.idle;
    _bookingDetails = null;
    _errorMessage = null;
    notifyListeners();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _setLoading() {
    _status = BookingStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = BookingStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}