// // lib/providers/hostel_provider.dart

// import 'package:brando_app/helper/shared_preference.dart';
// import 'package:brando_app/models/hostel_model.dart';
// import 'package:brando_app/services/location/location_service.dart';
// import 'package:flutter/foundation.dart';

// enum HostelState { idle, loading, success, error }

// class HostelProvider extends ChangeNotifier {
//   final HostelService _service = HostelService.instance;

//   // ─── State ───────────────────────────────────────────────────────────────
//   HostelState _state = HostelState.idle;
//   List<HostelModel> _hostels = [];
//   String? _errorMessage;
//   int _totalCount = 0;
//   String _selectedCategory = 'ALL';

//   // ─── Filtered State ───────────────────────────────────────────────────────
//   String _selectedType = 'ALL'; // 'ALL', 'AC', 'NON-AC'

//   // ─── Getters ─────────────────────────────────────────────────────────────
//   HostelState get state => _state;
//   List<HostelModel> get hostels => _filteredHostels;
//   List<HostelModel> get allHostels => _hostels;
//   String? get errorMessage => _errorMessage;
//   int get totalCount => _totalCount;
//   bool get isLoading => _state == HostelState.loading;
//   bool get hasError => _state == HostelState.error;
//   String get selectedType => _selectedType;
//   String get selectedCategory => _selectedCategory;

//   // ─── Filter by AC / NON-AC based on sharings[].type ──────────────────────
//   List<HostelModel> get _filteredHostels {
//     List<HostelModel> result = _hostels;

//     // Filter by category
//     if (_selectedCategory != 'ALL') {
//       result = result.where((h) => h.categoryId.name == _selectedCategory).toList();
//     }

//     // Filter by AC / NON-AC based on sharings array
//     if (_selectedType != 'ALL') {
//       result = result.where((h) {
//         return h.sharings.any(
//           (sharing) => sharing.type.toUpperCase() == _selectedType.toUpperCase(),
//         );
//       }).toList();
//     }

//     return result;
//   }

//   // ─── Filter by Type ───────────────────────────────────────────────────────
//   void setTypeFilter(String type) {
//     _selectedType = type;
//     notifyListeners();
//   }

//   void setCategoryFilter(String category) {
//     _selectedCategory = category;
//     notifyListeners();
//   }

//   // ─── Fetch Nearby Hostels ─────────────────────────────────────────────────
//   Future<void> fetchNearbyHostels() async {
//     final userId = AppPreferences.getUserId();
//     if (userId == null) {
//       _setError('User not logged in');
//       return;
//     }

//     _setState(HostelState.loading);

//     try {
//       final response = await _service.getNearbyHostels(userId);
//       _hostels = response.hostels;
//       _totalCount = response.count;
//       _setState(HostelState.success);
//     } catch (e) {
//       _setError(e.toString());
//     }
//   }

//   // ─── Update Location and Fetch Hostels ───────────────────────────────────
//   Future<void> updateLocationAndFetch({
//     required double latitude,
//     required double longitude,
//   }) async {
//     final userId = AppPreferences.getUserId();
//     if (userId == null) {
//       _setError('User not logged in');
//       return;
//     }

//     _setState(HostelState.loading);

//     try {
//       final response = await _service.updateLocationAndFetchHostels(
//         userId: userId,
//         latitude: latitude,
//         longitude: longitude,
//       );
//       _hostels = response.hostels;
//       _totalCount = response.count;
//       _setState(HostelState.success);
//     } catch (e) {
//       _setError(e.toString());
//     }
//   }

//   // ─── Update Location Only ────────────────────────────────────────────────
//   Future<void> updateLocation({
//     required double latitude,
//     required double longitude,
//   }) async {
//     final userId = AppPreferences.getUserId();
//     if (userId == null) {
//       _setError('User not logged in');
//       return;
//     }

//     try {
//       await _service.updateLocation(
//         userId: userId,
//         latitude: latitude,
//         longitude: longitude,
//       );
//     } catch (e) {
//       _setError(e.toString());
//     }
//   }

//   // ─── Clear ────────────────────────────────────────────────────────────────
//   void clearHostels() {
//     _hostels = [];
//     _totalCount = 0;
//     _errorMessage = null;
//     _state = HostelState.idle;
//     notifyListeners();
//   }

//   // ─── Helpers ──────────────────────────────────────────────────────────────
//   void _setState(HostelState state) {
//     _state = state;
//     _errorMessage = null;
//     notifyListeners();
//   }

//   void _setError(String message) {
//     _state = HostelState.error;
//     _errorMessage = message;
//     notifyListeners();
//   }
// }

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

  List<HostelModel> _recommendedHostels = [];

  String? _errorMessage;

  int _totalCount = 0;

  String _selectedCategory = 'ALL';

  // ─── Filtered State ───────────────────────────────────────────────────────
  String _selectedType = 'ALL';

  // ─── Getters ─────────────────────────────────────────────────────────────
  HostelState get state => _state;

  List<HostelModel> get hostels => _filteredHostels;

  List<HostelModel> get recommendedHostels => _filteredRecommendedHostels;

  List<HostelModel> get allHostels => _hostels;

  List<HostelModel> get allRecommendedHostels => _recommendedHostels;

  String? get errorMessage => _errorMessage;

  int get totalCount => _totalCount;

  bool get isLoading => _state == HostelState.loading;

  bool get hasError => _state == HostelState.error;

  String get selectedType => _selectedType;

  String get selectedCategory => _selectedCategory;

  // ─── Filter Nearby Hostels ───────────────────────────────────────────────
  List<HostelModel> get _filteredHostels {
    List<HostelModel> result = _hostels;

    // Category filter
    if (_selectedCategory != 'ALL') {
      result = result
          .where((h) => h.categoryId.name == _selectedCategory)
          .toList();
    }

    // AC / NON-AC filter
    if (_selectedType != 'ALL') {
      result = result.where((h) {
        return h.sharings.any(
          (sharing) =>
              sharing.type.toUpperCase() == _selectedType.toUpperCase(),
        );
      }).toList();
    }

    return result;
  }

  // ─── Filter Recommended Hostels ──────────────────────────────────────────
  List<HostelModel> get _filteredRecommendedHostels {
    List<HostelModel> result = _recommendedHostels;

    // Category filter
    if (_selectedCategory != 'ALL') {
      result = result
          .where((h) => h.categoryId.name == _selectedCategory)
          .toList();
    }

    // AC / NON-AC filter
    if (_selectedType != 'ALL') {
      result = result.where((h) {
        return h.sharings.any(
          (sharing) =>
              sharing.type.toUpperCase() == _selectedType.toUpperCase(),
        );
      }).toList();
    }

    return result;
  }

  // ─── Set Type Filter ─────────────────────────────────────────────────────
  void setTypeFilter(String type) {
    _selectedType = type;
    notifyListeners();
  }

  // ─── Set Category Filter ─────────────────────────────────────────────────
  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ─── Fetch Nearby Hostels ────────────────────────────────────────────────
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

  // ─── Fetch Recommended Hostels ───────────────────────────────────────────
  Future<void> fetchRecoHostels() async {
    final userId = AppPreferences.getUserId();

    if (userId == null) {
      _setError('User not logged in');
      return;
    }

    _setState(HostelState.loading);

    try {
      final response = await _service.getRecoHostels(userId);

      _recommendedHostels = response.hostels;

      _setState(HostelState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ─── Update Location & Fetch Both ────────────────────────────────────────
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

      _hostels = (response['nearby'] as NearbyHostelsResponse).hostels;

      _recommendedHostels =
          (response['recommended'] as NearbyHostelsResponse).hostels;

      _totalCount = (response['nearby'] as NearbyHostelsResponse).count;

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

    _recommendedHostels = [];

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
