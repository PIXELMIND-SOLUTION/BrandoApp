// lib/features/booking/models/booking_request_model.dart

class BookingRequestModel {
  final String id;
  final String userId;
  final String hostelId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingRequestModel({
    required this.id,
    required this.userId,
    required this.hostelId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      hostelId: json['hostelId'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'hostelId': hostelId,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}