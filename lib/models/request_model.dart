// class BookingRequest {
//   final String id;
//   final String status;
//   final String? serviceName;
//   final String? providerName;
//   final String? date;
//   final String? time;
//   final String? address;
//   final double? amount;
//   final String? imageUrl;

//   BookingRequest({
//     required this.id,
//     required this.status,
//     this.serviceName,
//     this.providerName,
//     this.date,
//     this.time,
//     this.address,
//     this.amount,
//     this.imageUrl,
//   });

//   factory BookingRequest.fromJson(Map<String, dynamic> json) {
//     return BookingRequest(
//       id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
//       status: json['status']?.toString() ?? 'pending',
//       serviceName: json['serviceName']?.toString() ??
//           json['service_name']?.toString() ??
//           json['service']?['name']?.toString(),
//       providerName: json['providerName']?.toString() ??
//           json['provider_name']?.toString() ??
//           json['provider']?['name']?.toString(),
//       date: json['date']?.toString() ?? json['bookingDate']?.toString(),
//       time: json['time']?.toString() ?? json['bookingTime']?.toString(),
//       address: json['address']?.toString() ?? json['location']?.toString(),
//       amount: (json['amount'] ?? json['totalAmount'] ?? json['price']) != null
//           ? double.tryParse(
//               (json['amount'] ?? json['totalAmount'] ?? json['price'])
//                   .toString())
//           : null,
//       imageUrl: json['imageUrl']?.toString() ??
//           json['image']?.toString() ??
//           json['service']?['image']?.toString(),
//     );
//   }
// }











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
