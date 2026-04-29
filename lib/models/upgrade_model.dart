class UpgradeBookingRequest {
  final String roomType;
  final String shareType;
  final String bookingType;
  final String isTrue;

  UpgradeBookingRequest({
    required this.roomType,
    required this.shareType,
    required this.bookingType,
    required this.isTrue,
  });

  Map<String, dynamic> toJson() => {
        'roomType': roomType,
        'shareType': shareType,
        'bookingType': bookingType,
        'isTrue': isTrue,
      };
}

class UpgradeBookingResponse {
  final bool success;
  final String message;
  final UpgradedBooking booking;

  UpgradeBookingResponse({
    required this.success,
    required this.message,
    required this.booking,
  });

  factory UpgradeBookingResponse.fromJson(Map<String, dynamic> json) {
    return UpgradeBookingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      booking: UpgradedBooking.fromJson(json['booking']),
    );
  }
}

class UpgradedBooking {
  final String id;
  final HostelInfo hostel;
  final UserInfo user;
  final VendorInfo vendor;
  final String roomType;
  final String shareType;
  final String isTrue;
  final String bookingType;
  final String startDate;
  final double totalAmount;
  final double monthlyAdvance;
  final String status;
  final String bookingReference;
  final String createdAt;
  final String updatedAt;

  UpgradedBooking({
    required this.id,
    required this.hostel,
    required this.user,
    required this.vendor,
    required this.roomType,
    required this.shareType,
    required this.isTrue,
    required this.bookingType,
    required this.startDate,
    required this.totalAmount,
    required this.monthlyAdvance,
    required this.status,
    required this.bookingReference,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpgradedBooking.fromJson(Map<String, dynamic> json) {
    return UpgradedBooking(
      id: json['_id'] ?? '',
      hostel: HostelInfo.fromJson(json['hostelId']),
      user: UserInfo.fromJson(json['userId']),
      vendor: VendorInfo.fromJson(json['vendorId']),
      roomType: json['roomType'] ?? '',
      shareType: json['shareType'] ?? '',
      isTrue: json['isTrue'] ?? '',
      bookingType: json['bookingType'] ?? '',
      startDate: json['startDate'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      monthlyAdvance: (json['monthlyAdvance'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      bookingReference: json['bookingReference'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class HostelInfo {
  final String id;
  final String name;
  final String address;

  HostelInfo({required this.id, required this.name, required this.address});

  factory HostelInfo.fromJson(Map<String, dynamic> json) {
    return HostelInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class UserInfo {
  final String id;
  final String name;
  final dynamic mobileNumber;

  UserInfo({required this.id, required this.name, required this.mobileNumber});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'],
    );
  }
}

class VendorInfo {
  final String id;
  final String name;
  final String mobileNumber;

  VendorInfo({
    required this.id,
    required this.name,
    required this.mobileNumber,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    return VendorInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber']?.toString() ?? '',
    );
  }
}