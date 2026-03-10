// import 'package:brando_app/models/wishlist_model.dart';
// import 'package:brando_app/services/wishlist/wishlist_service.dart';
// import 'package:flutter/foundation.dart';


// enum WishlistStatus { idle, loading, success, error }

// class WishlistProvider extends ChangeNotifier {
//   final WishlistService _service = WishlistService.instance;


//   WishlistStatus _status = WishlistStatus.idle;
//   WishlistStatus get status => _status;

//   List<WishlistItem> _wishlistItems = [];
//   List<WishlistItem> get wishlistItems => List.unmodifiable(_wishlistItems);

//   int get wishlistCount => _wishlistItems.length;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   bool _isTogglingWishlist = false;
//   bool get isTogglingWishlist => _isTogglingWishlist;

//   final Map<String, bool> _wishlistStateMap = {};


//   bool isWishlisted(String hostelId) => _wishlistStateMap[hostelId] ?? false;

//   // ─── Toggle Wishlist ──────────────────────────────────────────────────────

//   Future<void> toggleWishlist(String hostelId) async {
//     if (_isTogglingWishlist) return;

//     // Optimistic update
//     final previousState = _wishlistStateMap[hostelId] ?? false;
//     _wishlistStateMap[hostelId] = !previousState;
//     _isTogglingWishlist = true;
//     notifyListeners();

//     try {
//       final response = await _service.toggleWishlist(hostelId: hostelId);

//       _wishlistStateMap[hostelId] = response.isWishlisted;

//       if (response.isWishlisted) {
//         if (response.wishlist != null &&
//             !_wishlistItems.any((w) => w.hostelId == hostelId)) {
//           _wishlistItems.add(response.wishlist!);
//         }
//       } else {
//         _wishlistItems.removeWhere(
//           (w) => w.hostelId == hostelId || w.hostel?.id == hostelId,
//         );
//       }

//       _clearError();
//     } catch (e) {
//       _wishlistStateMap[hostelId] = previousState;
//       _setError(e.toString().replaceFirst('Exception: ', ''));
//     } finally {
//       _isTogglingWishlist = false;
//       notifyListeners();
//     }
//   }

//   // ─── Fetch Wishlist ───────────────────────────────────────────────────────

//   Future<void> fetchWishlist() async {
//     _setStatus(WishlistStatus.loading);

//     try {
//       final response = await _service.getMyWishlist();
//       _wishlistItems = response.wishlist;

//       _wishlistStateMap.clear();
//       for (final item in _wishlistItems) {
//         final hostelId = item.hostel?.id ?? item.hostelId;
//         if (hostelId != null && hostelId.isNotEmpty) {
//           _wishlistStateMap[hostelId] = true;
//         }
//       }

//       _clearError();
//       _setStatus(WishlistStatus.success);
//     } catch (e) {
//       _setError(e.toString().replaceFirst('Exception: ', ''));
//       _setStatus(WishlistStatus.error);
//     }
//   }


//   void removeItemLocally(String hostelId) {
//     _wishlistItems.removeWhere(
//       (w) => w.hostel?.id == hostelId || w.hostelId == hostelId,
//     );
//     _wishlistStateMap[hostelId] = false;
//     notifyListeners();
//   }


//   void clearWishlist() {
//     _wishlistItems.clear();
//     _wishlistStateMap.clear();
//     _status = WishlistStatus.idle;
//     _errorMessage = null;
//     notifyListeners();
//   }


//   void _setStatus(WishlistStatus status) {
//     _status = status;
//     notifyListeners();
//   }

//   void _setError(String message) {
//     _errorMessage = message;
//   }

//   void _clearError() {
//     _errorMessage = null;
//   }
// }






















import 'package:brando_app/models/wishlist_model.dart';
import 'package:brando_app/services/wishlist/wishlist_service.dart';
import 'package:flutter/foundation.dart';


enum WishlistStatus { idle, loading, success, error }

class WishlistProvider extends ChangeNotifier {
  final WishlistService _service = WishlistService.instance;

  // ─── State ────────────────────────────────────────────────────────────────

  WishlistStatus _status = WishlistStatus.idle;
  WishlistStatus get status => _status;

  List<WishlistItem> _wishlistItems = [];
  List<WishlistItem> get wishlistItems => List.unmodifiable(_wishlistItems);

  int get wishlistCount => _wishlistItems.length;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isTogglingWishlist = false;
  bool get isTogglingWishlist => _isTogglingWishlist;

  /// Tracks hostelId → isWishlisted for instant UI feedback
  final Map<String, bool> _wishlistStateMap = {};

  // ─── Check Wishlist State ─────────────────────────────────────────────────

  /// Returns true if the hostel is currently wishlisted.
  bool isWishlisted(String hostelId) => _wishlistStateMap[hostelId] ?? false;

  // ─── Toggle Wishlist ──────────────────────────────────────────────────────

  /// Optimistically toggles the local state and syncs with the server.
  Future<void> toggleWishlist(String hostelId) async {
    if (_isTogglingWishlist) return;

    // Optimistic update
    final previousState = _wishlistStateMap[hostelId] ?? false;
    _wishlistStateMap[hostelId] = !previousState;
    _isTogglingWishlist = true;
    notifyListeners();

    try {
      final response = await _service.toggleWishlist(hostelId: hostelId);

      // Sync with server truth
      _wishlistStateMap[hostelId] = response.isWishlisted;

      if (response.isWishlisted) {
        // Fetch full wishlist so hostel details are available for the UI
        await fetchWishlist();
      } else {
        // Remove instantly from local list — no need to re-fetch
        _wishlistItems.removeWhere(
          (w) => w.hostelId == hostelId || w.hostel?.id == hostelId,
        );
      }

      _clearError();
    } catch (e) {
      // Rollback optimistic update on failure
      _wishlistStateMap[hostelId] = previousState;
      _setError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _isTogglingWishlist = false;
      notifyListeners();
    }
  }

  // ─── Fetch Wishlist ───────────────────────────────────────────────────────

  Future<void> fetchWishlist() async {
    _setStatus(WishlistStatus.loading);

    try {
      final response = await _service.getMyWishlist();
      _wishlistItems = response.wishlist;

      // Rebuild the state map from fetched data
      _wishlistStateMap.clear();
      for (final item in _wishlistItems) {
        final hostelId = item.hostel?.id ?? item.hostelId;
        if (hostelId != null && hostelId.isNotEmpty) {
          _wishlistStateMap[hostelId] = true;
        }
      }

      _clearError();
      _setStatus(WishlistStatus.success);
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
      _setStatus(WishlistStatus.error);
    }
  }

  // ─── Remove Item Locally (e.g. after swipe-to-delete) ────────────────────

  void removeItemLocally(String hostelId) {
    _wishlistItems.removeWhere(
      (w) => w.hostel?.id == hostelId || w.hostelId == hostelId,
    );
    _wishlistStateMap[hostelId] = false;
    notifyListeners();
  }

  // ─── Clear Wishlist (on logout) ───────────────────────────────────────────

  void clearWishlist() {
    _wishlistItems.clear();
    _wishlistStateMap.clear();
    _status = WishlistStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────

  void _setStatus(WishlistStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
  }

  void _clearError() {
    _errorMessage = null;
  }
}