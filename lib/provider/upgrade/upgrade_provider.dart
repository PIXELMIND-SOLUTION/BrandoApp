import 'package:brando_app/models/upgrade_model.dart';
import 'package:brando_app/services/upgrade/upgrade_service.dart';
import 'package:flutter/foundation.dart';


enum UpgradeBookingStatus { idle, loading, success, error }

class UpgradeBookingProvider extends ChangeNotifier {
  final UpgradeBookingService _service;

  UpgradeBookingProvider({UpgradeBookingService? service})
      : _service = service ?? UpgradeBookingService();

  UpgradeBookingStatus _status = UpgradeBookingStatus.idle;
  UpgradeBookingResponse? _response;
  String? _errorMessage;

  // Form state
  String _roomType = 'AC';
  String _shareType = '2-sharing';
  String _bookingType = 'monthly';
  bool _isTrue = true;

  // Getters
  UpgradeBookingStatus get status => _status;
  UpgradeBookingResponse? get response => _response;
  String? get errorMessage => _errorMessage;
  UpgradedBooking? get upgradedBooking => _response?.booking;

  String get roomType => _roomType;
  String get shareType => _shareType;
  String get bookingType => _bookingType;
  bool get isTrue => _isTrue;

  bool get isLoading => _status == UpgradeBookingStatus.loading;
  bool get isSuccess => _status == UpgradeBookingStatus.success;
  bool get hasError => _status == UpgradeBookingStatus.error;

  // Setters
  void setRoomType(String value) {
    _roomType = value;
    notifyListeners();
  }

  void setShareType(String value) {
    _shareType = value;
    notifyListeners();
  }

  void setBookingType(String value) {
    _bookingType = value;
    notifyListeners();
  }

  void setIsTrue(bool value) {
    _isTrue = value;
    notifyListeners();
  }

  Future<void> upgradeBooking({
    required String bookingId,
    String? token,
  }) async {
    _status = UpgradeBookingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = UpgradeBookingRequest(
        roomType: _roomType,
        shareType: _shareType,
        bookingType: _bookingType,
        isTrue: _isTrue.toString(),
      );

      _response = await _service.upgradeBooking(
        bookingId: bookingId,
        request: request,
        token: token,
      );

      _status = UpgradeBookingStatus.success;
    } catch (e) {
      _status = UpgradeBookingStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  void reset() {
    _status = UpgradeBookingStatus.idle;
    _response = null;
    _errorMessage = null;
    notifyListeners();
  }
}