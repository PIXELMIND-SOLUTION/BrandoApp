class WishlistToggleResponse {
  final bool success;
  final String message;
  final bool isWishlisted;
  final WishlistItem? wishlist;

  WishlistToggleResponse({
    required this.success,
    required this.message,
    required this.isWishlisted,
    this.wishlist,
  });

  factory WishlistToggleResponse.fromJson(Map<String, dynamic> json) {
    return WishlistToggleResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isWishlisted: json['isWishlisted'] ?? false,
      wishlist: json['wishlist'] != null
          ? WishlistItem.fromJson(json['wishlist'])
          : null,
    );
  }
}

// ─── Wishlist Item (used in both toggle response & get wishlist) ─────────────

class WishlistItem {
  final String id;
  final String wishlistId;
  final DateTime? addedAt;
  final String? userId;
  final String? hostelId;
  final HostelModel? hostel;

  WishlistItem({
    required this.id,
    required this.wishlistId,
    this.addedAt,
    this.userId,
    this.hostelId,
    this.hostel,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['_id'] ?? '',
      wishlistId: json['wishlistId'] ?? json['_id'] ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.tryParse(json['addedAt'])
          : json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      userId: json['userId'],
      hostelId: json['hostelId'],
      hostel:
          json['hostel'] != null ? HostelModel.fromJson(json['hostel']) : null,
    );
  }
}

// ─── Get Wishlist Response ────────────────────────────────────────────────────

class GetWishlistResponse {
  final bool success;
  final int count;
  final List<WishlistItem> wishlist;

  GetWishlistResponse({
    required this.success,
    required this.count,
    required this.wishlist,
  });

  factory GetWishlistResponse.fromJson(Map<String, dynamic> json) {
    return GetWishlistResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      wishlist: (json['wishlist'] as List<dynamic>?)
              ?.map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ─── Hostel Model ─────────────────────────────────────────────────────────────

class HostelModel {
  final String id;
  final String name;
  final double rating;
  final String address;
  final int monthlyAdvance;
  final List<String> images;
  final List<SharingOption> sharings;
  final HostelCategory? category;
  final HostelLocation? location;
  final DateTime? createdAt;

  HostelModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.address,
    required this.monthlyAdvance,
    required this.images,
    required this.sharings,
    this.category,
    this.location,
    this.createdAt,
  });

  factory HostelModel.fromJson(Map<String, dynamic> json) {
    return HostelModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      monthlyAdvance: (json['monthlyAdvance'] as num?)?.toInt() ?? 0,
      images: List<String>.from(json['images'] ?? []),
      sharings: (json['sharings'] as List<dynamic>?)
              ?.map((e) => SharingOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      category: json['categoryId'] != null
          ? HostelCategory.fromJson(json['categoryId'])
          : null,
      location: json['location'] != null
          ? HostelLocation.fromJson(json['location'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  /// Returns the lowest non-AC monthly price across all sharing options.
  int? get lowestPrice {
    if (sharings.isEmpty) return null;
    return sharings
        .map((s) => s.nonAcMonthlyPrice)
        .reduce((a, b) => a < b ? a : b);
  }

  /// Returns the first image or null.
  String? get thumbnailImage => images.isNotEmpty ? images.first : null;
}

// ─── Sharing Option ───────────────────────────────────────────────────────────

class SharingOption {
  final String shareType;
  final int acMonthlyPrice;
  final int acDailyPrice;
  final int nonAcMonthlyPrice;
  final int nonAcDailyPrice;

  SharingOption({
    required this.shareType,
    required this.acMonthlyPrice,
    required this.acDailyPrice,
    required this.nonAcMonthlyPrice,
    required this.nonAcDailyPrice,
  });

  factory SharingOption.fromJson(Map<String, dynamic> json) {
    return SharingOption(
      shareType: json['shareType'] ?? '',
      acMonthlyPrice: (json['acMonthlyPrice'] as num?)?.toInt() ?? 0,
      acDailyPrice: (json['acDailyPrice'] as num?)?.toInt() ?? 0,
      nonAcMonthlyPrice: (json['nonAcMonthlyPrice'] as num?)?.toInt() ?? 0,
      nonAcDailyPrice: (json['nonAcDailyPrice'] as num?)?.toInt() ?? 0,
    );
  }
}

// ─── Hostel Category ──────────────────────────────────────────────────────────

class HostelCategory {
  final String id;
  final String name;

  HostelCategory({required this.id, required this.name});

  factory HostelCategory.fromJson(Map<String, dynamic> json) {
    return HostelCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

// ─── Hostel Location ──────────────────────────────────────────────────────────

class HostelLocation {
  final String type;
  final double longitude;
  final double latitude;

  HostelLocation({
    required this.type,
    required this.longitude,
    required this.latitude,
  });

  factory HostelLocation.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List<dynamic>?;
    return HostelLocation(
      type: json['type'] ?? 'Point',
      longitude: (coords?[0] as num?)?.toDouble() ?? 0.0,
      latitude: (coords?[1] as num?)?.toDouble() ?? 0.0,
    );
  }
}