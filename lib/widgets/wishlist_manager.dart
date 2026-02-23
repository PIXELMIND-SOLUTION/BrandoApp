
import 'package:flutter/material.dart';

class WishlistManager {
  // Singleton instance
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;
  WishlistManager._internal();

  // ValueNotifier holds the list of favourite hostels
  final ValueNotifier<List<Map<String, dynamic>>> wishlist =
      ValueNotifier([]);

  /// Returns true if the hostel (matched by 'name') is in the wishlist.
  bool isFavourite(Map<String, dynamic> hostel) {
    return wishlist.value.any((h) => h['name'] == hostel['name']);
  }

  /// Adds or removes the hostel from the wishlist (toggle) and shows a SnackBar.
  void toggle(BuildContext context, Map<String, dynamic> hostel) {
    final current = List<Map<String, dynamic>>.from(wishlist.value);
    final bool alreadyFavourite = isFavourite(hostel);

    if (alreadyFavourite) {
      current.removeWhere((h) => h['name'] == hostel['name']);
    } else {
      current.add(hostel);
    }

    wishlist.value = current; // triggers ValueNotifier listeners

    // Show SnackBar feedback
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 2),
        backgroundColor: alreadyFavourite ? Colors.red.shade800 : Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            Icon(
              alreadyFavourite ? Icons.favorite_border : Icons.favorite,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              alreadyFavourite
                  ? '${hostel['name']} removed from Favourites'
                  : '${hostel['name']} added to Favourites',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}