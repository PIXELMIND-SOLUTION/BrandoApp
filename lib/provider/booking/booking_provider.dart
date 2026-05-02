// // lib/features/booking/providers/booking_provider.dart

// import 'package:brando_app/models/booking_model.dart';
// import 'package:brando_app/services/booking/booking_service.dart';
// import 'package:flutter/foundation.dart';

// enum BookingStatus { idle, loading, success, error }

// class BookingProvider extends ChangeNotifier {
//   final BookingService _bookingService;

//   BookingProvider({BookingService? bookingService})
//       : _bookingService = bookingService ?? BookingService();

//   BookingStatus _status = BookingStatus.idle;
//   BookingRequestModel? _bookingRequest;
//   String? _errorMessage;

//   BookingStatus get status => _status;
//   BookingRequestModel? get bookingRequest => _bookingRequest;
//   String? get errorMessage => _errorMessage;

//   bool get isLoading => _status == BookingStatus.loading;
//   bool get isSuccess => _status == BookingStatus.success;
//   bool get hasError => _status == BookingStatus.error;

//   Future<void> sendBookingRequest({
//     required String userId,
//     required String hostelId,
//   }) async {
//     _setStatus(BookingStatus.loading);
//     _errorMessage = null;

//     try {
//       _bookingRequest = await _bookingService.sendBookingRequest(
//         userId: userId,
//         hostelId: hostelId,
//       );
//       _setStatus(BookingStatus.success);
//     } catch (e) {
//       _errorMessage = e.toString().replaceFirst('Exception: ', '');
//       _setStatus(BookingStatus.error);
//     }
//   }

//   void reset() {
//     _status = BookingStatus.idle;
//     _bookingRequest = null;
//     _errorMessage = null;
//     notifyListeners();
//   }

//   void _setStatus(BookingStatus status) {
//     _status = status;
//     notifyListeners();
//   }
// }

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
  BookingRequestModel? _booking;
  String? _errorMessage;

  final Set<String> _submittedHostelIds = {};

  BookingStatus get status => _status;
  BookingRequestModel? get booking => _booking;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == BookingStatus.loading;
  bool get isSuccess => _status == BookingStatus.success;
  bool get hasError => _status == BookingStatus.error;

  bool isHostelSubmitted(String hostelId) =>
      _submittedHostelIds.contains(hostelId);

  Future<void> createBooking({
    required String hostelId,
    required String userId,
    required String roomType,
    required String shareType,
    required String bookingType,
    required String startDate,
    bool isTrue = true,
  }) async {
    _setStatus(BookingStatus.loading);
    _errorMessage = null;

    try {
      _booking = await _bookingService.createBooking(
        hostelId: hostelId,
        userId: userId,
        roomType: roomType,
        shareType: shareType,
        bookingType: bookingType,
        startDate: startDate,
        isTrue: isTrue,
      );
      _submittedHostelIds.add(hostelId);
      _setStatus(BookingStatus.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(BookingStatus.error);
    }
  }

  void reset() {
    _status = BookingStatus.idle;
    _booking = null;
    _errorMessage = null;
    _submittedHostelIds.clear();

    notifyListeners();
  }

  void _setStatus(BookingStatus status) {
    _status = status;
    notifyListeners();
  }
}
