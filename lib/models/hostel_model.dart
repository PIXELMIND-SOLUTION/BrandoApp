// lib/models/hostel_model.dart

class HostelModel {
  final String id;
  final String categoryId;
  final String name;
  final String type; // AC or NON-AC
  final double rating;
  final String address;
  final int monthlyAdvance;
  final List<SharingOption> sharings;
  final List<String> images;
  final HostelLocation location;
  final DateTime createdAt;
  final DateTime updatedAt;

  HostelModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.type,
    required this.rating,
    required this.address,
    required this.monthlyAdvance,
    required this.sharings,
    required this.images,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HostelModel.fromJson(Map<String, dynamic> json) {
    return HostelModel(
      id: json['_id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      monthlyAdvance: json['monthlyAdvance'] ?? 0,
      sharings: (json['sharings'] as List<dynamic>?)
              ?.map((e) => SharingOption.fromJson(e))
              .toList() ??
          [],
      images: List<String>.from(json['images'] ?? []),
      location: HostelLocation.fromJson(json['location'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'categoryId': categoryId,
        'name': name,
        'type': type,
        'rating': rating,
        'address': address,
        'monthlyAdvance': monthlyAdvance,
        'sharings': sharings.map((e) => e.toJson()).toList(),
        'images': images,
        'location': location.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class SharingOption {
  final String shareType;
  final int monthlyPrice;
  final int dailyPrice;

  SharingOption({
    required this.shareType,
    required this.monthlyPrice,
    required this.dailyPrice,
  });

  factory SharingOption.fromJson(Map<String, dynamic> json) {
    return SharingOption(
      shareType: json['shareType'] ?? '',
      monthlyPrice: json['monthlyPrice'] ?? 0,
      dailyPrice: json['dailyPrice'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'shareType': shareType,
        'monthlyPrice': monthlyPrice,
        'dailyPrice': dailyPrice,
      };
}

class HostelLocation {
  final String type;
  final List<double> coordinates; // [longitude, latitude]

  HostelLocation({
    required this.type,
    required this.coordinates,
  });

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;

  factory HostelLocation.fromJson(Map<String, dynamic> json) {
    return HostelLocation(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(
        (json['coordinates'] as List<dynamic>?)?.map((e) => (e as num).toDouble()) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

// Response wrapper models
class NearbyHostelsResponse {
  final bool success;
  final int count;
  final List<HostelModel> hostels;

  NearbyHostelsResponse({
    required this.success,
    required this.count,
    required this.hostels,
  });

  factory NearbyHostelsResponse.fromJson(Map<String, dynamic> json) {
    return NearbyHostelsResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      hostels: (json['hostels'] as List<dynamic>?)
              ?.map((e) => HostelModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UpdateLocationResponse {
  final bool success;
  final String message;
  final UserLocation user;

  UpdateLocationResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory UpdateLocationResponse.fromJson(Map<String, dynamic> json) {
    return UpdateLocationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: UserLocation.fromJson(json['user'] ?? {}),
    );
  }
}

class UserLocation {
  final String id;
  final double latitude;
  final double longitude;

  UserLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] ?? {};
    return UserLocation(
      id: json['_id'] ?? '',
      latitude: (loc['latitude'] ?? 0).toDouble(),
      longitude: (loc['longitude'] ?? 0).toDouble(),
    );
  }
}