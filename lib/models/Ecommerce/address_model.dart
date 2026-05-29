class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String flatNo;
  final String area;
  final String city;
  final String pincode;
  final bool isDefault;
  final String addressType;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.flatNo,
    required this.area,
    required this.city,
    required this.pincode,
    required this.isDefault,
    required this.addressType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      flatNo: json['flatNo'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      isDefault: json['isDefault'] ?? false,
      addressType: json['addressType'] ?? 'home',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'flatNo': flatNo,
      'area': area,
      'city': city,
      'pincode': pincode,
      'isDefault': isDefault,
      'addressType': addressType,
    };
  }

  String get formattedAddress {
    return '$flatNo, $area, $city - $pincode';
  }

  String get fullAddress {
    return '$fullName\n$phone\n$flatNo, $area\n$city - $pincode';
  }

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? flatNo,
    String? area,
    String? city,
    String? pincode,
    bool? isDefault,
    String? addressType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      flatNo: flatNo ?? this.flatNo,
      area: area ?? this.area,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      isDefault: isDefault ?? this.isDefault,
      addressType: addressType ?? this.addressType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}