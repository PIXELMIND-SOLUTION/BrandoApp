// lib/providers/hostel_provider.dart

import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/hostel_model.dart';
import 'package:brando_app/services/location/location_service.dart';
import 'package:flutter/foundation.dart';


enum HostelState { idle, loading, success, error }

class HostelProvider extends ChangeNotifier {
  final HostelService _service = HostelService.instance;

  // ─── State ───────────────────────────────────────────────────────────────
  HostelState _state = HostelState.idle;
  List<HostelModel> _hostels = [];
  String? _errorMessage;
  int _totalCount = 0;

  // ─── Filtered State ───────────────────────────────────────────────────────
  String _selectedType = 'ALL'; // 'ALL', 'AC', 'NON-AC'

  // ─── Getters ─────────────────────────────────────────────────────────────
  HostelState get state => _state;
  List<HostelModel> get hostels => _filteredHostels;
  List<HostelModel> get allHostels => _hostels;
  String? get errorMessage => _errorMessage;
  int get totalCount => _totalCount;
  bool get isLoading => _state == HostelState.loading;
  bool get hasError => _state == HostelState.error;
  String get selectedType => _selectedType;

  List<HostelModel> get _filteredHostels {
    if (_selectedType == 'ALL') return _hostels;
    return _hostels.where((h) => h.type == _selectedType).toList();
  }

  // ─── Filter by Type ───────────────────────────────────────────────────────
  void setTypeFilter(String type) {
    _selectedType = type;
    notifyListeners();
  }

  // ─── Fetch Nearby Hostels ─────────────────────────────────────────────────
  Future<void> fetchNearbyHostels() async {
    final userId = AppPreferences.getUserId();
    if (userId == null) {
      _setError('User not logged in');
      return;
    }

    _setState(HostelState.loading);

    try {
      final response = await _service.getNearbyHostels(userId);
      _hostels = response.hostels;
      _totalCount = response.count;
      _setState(HostelState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ─── Update Location and Fetch Hostels ───────────────────────────────────
  Future<void> updateLocationAndFetch({
    required double latitude,
    required double longitude,
  }) async {
    final userId = AppPreferences.getUserId();
    if (userId == null) {
      _setError('User not logged in');
      return;
    }

    _setState(HostelState.loading);

    try {
      final response = await _service.updateLocationAndFetchHostels(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
      );
      _hostels = response.hostels;
      _totalCount = response.count;
      _setState(HostelState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ─── Update Location Only ────────────────────────────────────────────────
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    final userId = AppPreferences.getUserId();
    if (userId == null) {
      _setError('User not logged in');
      return;
    }

    try {
      await _service.updateLocation(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ─── Clear ────────────────────────────────────────────────────────────────
  void clearHostels() {
    _hostels = [];
    _totalCount = 0;
    _errorMessage = null;
    _state = HostelState.idle;
    notifyListeners();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  void _setState(HostelState state) {
    _state = state;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _state = HostelState.error;
    _errorMessage = message;
    notifyListeners();
  }
}