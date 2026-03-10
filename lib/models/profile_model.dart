
class UserProfileModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? profileImage;
  final LocationModel location;
  final bool isVerified;
  final bool otpVerified;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.profileImage,
    required this.location,
    required this.isVerified,
    required this.otpVerified,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),          
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      name: json['name']?.toString(),                             
      profileImage: _sanitizeImageUrl(json['profileImage']?.toString()),
      location: LocationModel.fromJson(
        (json['location'] as Map<String, dynamic>?) ?? {},
      ),
      isVerified: json['isVerified'] == true,
      otpVerified: json['otpVerified'] == true,
      category: json['category']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  static String? _sanitizeImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    final uploadsIndex = raw.indexOf('/uploads');
    if (uploadsIndex != -1) {
      final path = raw.substring(uploadsIndex).replaceAll('\\', '/');
      return 'http://31.97.206.144:2003$path';
    }

    return raw;
  }

  UserProfileModel copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? profileImage,
    LocationModel? location,
    bool? isVerified,
    bool? otpVerified,
    String? category,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      otpVerified: otpVerified ?? this.otpVerified,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'phoneNumber': phoneNumber,
        'name': name,
        'profileImage': profileImage,
        'location': location.toJson(),
        'isVerified': isVerified,
        'otpVerified': otpVerified,
        'category': category,
      };
}

class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({required this.latitude, required this.longitude});

  // factory LocationModel.fromJson(Map<String, dynamic> json) {
  //   return LocationModel(
  //     // ← Safe parse: handles String, int, double, or null
  //     latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
  //     longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
  //   );
  // }



  factory LocationModel.fromJson(Map<String, dynamic> json) {
  return LocationModel(
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
  );
}

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}