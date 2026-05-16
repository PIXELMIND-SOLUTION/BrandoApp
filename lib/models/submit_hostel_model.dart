class HostelBookingRequestModel {
  final String name;
  final String mobileNumber;
  final String roomNo;
  final String? roomType;
  final String? shareType;
  final String? email;
  final List<String> aadharCardImage; // Changed to List
  final List<String> panCardImage; // Changed to List
  final String profileImage;
  final String emergencyNumber;
  final String bookingType; // 'monthly' or 'daily'
  final int totalAmount; // Selected amount

  HostelBookingRequestModel({
    required this.name,
    required this.mobileNumber,
    required this.roomNo,
    this.roomType,
    this.shareType,
    this.email,
    required this.aadharCardImage,
    required this.panCardImage,
    required this.profileImage,
    required this.emergencyNumber,
    required this.bookingType,
    required this.totalAmount,
  });
}

class HostelBookingResponseModel {
  final bool success;
  final String message;
  final BookingDetails? booking;

  HostelBookingResponseModel({
    required this.success,
    required this.message,
    this.booking,
  });

  factory HostelBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return HostelBookingResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      booking: json['booking'] != null
          ? BookingDetails.fromJson(json['booking'])
          : null,
    );
  }
}

class BookingDetails {
  final String id;
  final String userId;
  final String hostelId;
  final String vendorId;
  final String shareType;
  final String roomType;
  final String roomNo;
  final String name;
  final String mobileNumber;
  final String email;
  final List<String> aadharCardImages; // Changed to List
  final List<String> panCardImages; // Changed to List
  final String profileImage;
  final String paymentStatus;
  final num price;
  final String? assignedDate;
  final String status;
  final String createdAt;
  final String updatedAt;

  BookingDetails({
    required this.id,
    required this.userId,
    required this.hostelId,
    required this.vendorId,
    required this.shareType,
    required this.roomType,
    required this.roomNo,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.aadharCardImages,
    required this.panCardImages,
    required this.profileImage,
    required this.paymentStatus,
    required this.price,
    this.assignedDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    // Handle both single image (string) and multiple images (list) responses
    List<String> parseImages(dynamic images) {
      if (images == null) return [];
      if (images is String) return [images];
      if (images is List) return images.map((e) => e.toString()).toList();
      return [];
    }

    return BookingDetails(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      hostelId: json['hostelId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      shareType: json['shareType'] ?? '',
      roomType: json['roomType'] ?? '',
      roomNo: json['roomNo'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      aadharCardImages: parseImages(
        json['aadharCardImages'] ?? json['aadharCardImage'],
      ),
      panCardImages: parseImages(json['panCardImages'] ?? json['panCardImage']),
      profileImage: json['profileImage'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      price: json['price'] ?? 0,
      assignedDate: json['assignedDate'],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
