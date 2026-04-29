class BookingRequest {
  final String id;
  final String status;
  final String createdAt;
  final String hostelName;
  final String? hostelImage;
  final double? hostelLat;
  final double? hostelLng;
  final String vendorName;
  final String vendorPhone;

  BookingRequest({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.hostelName,
    this.hostelImage,
    this.hostelLat,
    this.hostelLng,
    required this.vendorName,
    required this.vendorPhone,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    final hostel = json['hostel'] as Map<String, dynamic>? ?? {};
    final vendor = json['vendor'] as Map<String, dynamic>? ?? {};
    final coords = (hostel['location']?['coordinates'] as List?)?.cast<double>();

    return BookingRequest(
      id: json['bookingId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      hostelName: hostel['name'] ?? 'Unknown',
      hostelImage: hostel['image'],
      hostelLat: coords != null && coords.length == 2 ? coords[1] : null,
      hostelLng: coords != null && coords.length == 2 ? coords[0] : null,
      vendorName: vendor['name'] ?? '',
      vendorPhone: vendor['mobileNumber'] ?? '',
    );
  }
}
