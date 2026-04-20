// lib/features/booking/providers/booking_provider.dart

import 'package:brando_app/models/booking_model.dart';
import 'package:brando_app/services/booking/booking_service.dart';
import 'package:flutter/foundation.dart';


enum BookingStatus { idle, loading, success, error }

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService;

  BookingProvider({BookingService? bookingService})
      : _bookingService = bookingService ?? BookingService();

  BookingStatus _status = BookingStatus.idle;
  BookingRequestModel? _bookingRequest;
  String? _errorMessage;

  BookingStatus get status => _status;
  BookingRequestModel? get bookingRequest => _bookingRequest;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == BookingStatus.loading;
  bool get isSuccess => _status == BookingStatus.success;
  bool get hasError => _status == BookingStatus.error;

  Future<void> sendBookingRequest({
    required String userId,
    required String hostelId,
  }) async {
    _setStatus(BookingStatus.loading);
    _errorMessage = null;

    try {
      _bookingRequest = await _bookingService.sendBookingRequest(
        userId: userId,
        hostelId: hostelId,
      );
      _setStatus(BookingStatus.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(BookingStatus.error);
    }
  }

  void reset() {
    _status = BookingStatus.idle;
    _bookingRequest = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(BookingStatus status) {
    _status = status;
    notifyListeners();
  }
}