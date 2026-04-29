
// lib/models/booking_model.dart

class BookingHostel {
  final String id;
  final String name;
  final String address;

  const BookingHostel({
    required this.id,
    required this.name,
    required this.address,
  });

  // factory BookingHostel.fromJson(Map<String, dynamic> json) {
  //   return BookingHostel(
  //     id: json['_id'] as String,
  //     name: json['name'] as String,
  //     address: json['address'] as String,
  //   );
  // }


  factory BookingHostel.fromJson(Map<String, dynamic> json) {
  return BookingHostel(
    id: json['_id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    address: json['address'] as String? ?? '',
  );
}
}

class BookingUser {
  final String id;
  final String name;
  final dynamic mobileNumber;

  const BookingUser({
    required this.id,
    required this.name,
    required this.mobileNumber,
  });

  // factory BookingUser.fromJson(Map<String, dynamic> json) {
  //   return BookingUser(
  //     id: json['_id'] as String,
  //     name: json['name'] as String,
  //     mobileNumber: json['mobileNumber'],
  //   );
  // }


  factory BookingUser.fromJson(Map<String, dynamic> json) {
  return BookingUser(
    id: json['_id'] as String? ?? '',
    name: json['name'] as String? ?? '',  // ← was: json['name'] as String
    mobileNumber: json['mobileNumber'],
  );
}
}

class BookingVendor {
  final String id;
  final String name;
  final String mobileNumber;

  const BookingVendor({
    required this.id,
    required this.name,
    required this.mobileNumber,
  });

  factory BookingVendor.fromJson(Map<String, dynamic> json) {
    return BookingVendor(
      id: json['_id'] as String,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'].toString(),
    );
  }
}

// class BookingRequestModel {
//   final String id;
//   final BookingHostel hostel;
//   final BookingUser user;
//   final BookingVendor vendor;
//   final String roomType;
//   final String shareType;
//   final String bookingType;
//   final DateTime startDate;
//   final double totalAmount;
//   final double monthlyAdvance;
//   final String status;
//   final String bookingReference;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   const BookingRequestModel({
//     required this.id,
//     required this.hostel,
//     required this.user,
//     required this.vendor,
//     required this.roomType,
//     required this.shareType,
//     required this.bookingType,
//     required this.startDate,
//     required this.totalAmount,
//     required this.monthlyAdvance,
//     required this.status,
//     required this.bookingReference,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
//     return BookingRequestModel(
//       id: json['_id'] as String,
//       hostel: BookingHostel.fromJson(json['hostelId'] as Map<String, dynamic>),
//       user: BookingUser.fromJson(json['userId'] as Map<String, dynamic>),
//       vendor: BookingVendor.fromJson(json['vendorId'] as Map<String, dynamic>),
//       roomType: json['roomType'] as String,
//       shareType: json['shareType'] as String,
//       bookingType: json['bookingType'] as String,
//       startDate: DateTime.parse(json['startDate'] as String),
//       totalAmount: (json['totalAmount'] as num).toDouble(),
//       monthlyAdvance: (json['monthlyAdvance'] as num).toDouble(),
//       status: json['status'] as String,
//       bookingReference: json['bookingReference'] as String,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       updatedAt: DateTime.parse(json['updatedAt'] as String),
//     );
//   }
// }















class BookingRequestModel {
  final String id;
  final BookingHostel hostel;
  final BookingUser user;
  final BookingVendor vendor;
  final String roomType;
  final String shareType;
  final String bookingType;
  final DateTime startDate;
  final double totalAmount;
  final double monthlyAdvance;
  final String status;
  final String bookingReference;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isTrue; // ✅ Add this

  const BookingRequestModel({
    required this.id,
    required this.hostel,
    required this.user,
    required this.vendor,
    required this.roomType,
    required this.shareType,
    required this.bookingType,
    required this.startDate,
    required this.totalAmount,
    required this.monthlyAdvance,
    required this.status,
    required this.bookingReference,
    required this.createdAt,
    required this.updatedAt,
    required this.isTrue, // ✅ Add this
  });

  // factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
  //   // ✅ Handle both bool and string "true"/"false" from API
  //   final rawIsTrue = json['isTrue'];
  //   final bool parsedIsTrue = rawIsTrue == true ||
  //       rawIsTrue.toString().toLowerCase() == 'true';

  //   return BookingRequestModel(
  //     id: json['_id'] as String,
  //     hostel: BookingHostel.fromJson(json['hostelId'] as Map<String, dynamic>),
  //     user: BookingUser.fromJson(json['userId'] as Map<String, dynamic>),
  //     vendor: BookingVendor.fromJson(json['vendorId'] as Map<String, dynamic>),
  //     roomType: json['roomType'] as String,
  //     shareType: json['shareType'] as String,
  //     bookingType: json['bookingType'] as String,
  //     startDate: DateTime.parse(json['startDate'] as String),
  //     totalAmount: (json['totalAmount'] as num).toDouble(),
  //     monthlyAdvance: (json['monthlyAdvance'] as num).toDouble(),
  //     status: json['status'] as String,
  //     bookingReference: json['bookingReference'] as String,
  //     createdAt: DateTime.parse(json['createdAt'] as String),
  //     updatedAt: DateTime.parse(json['updatedAt'] as String),
  //     isTrue: parsedIsTrue, // ✅ Add this
  //   );
  // }




  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
  final rawIsTrue = json['isTrue'];
  final bool parsedIsTrue =
      rawIsTrue == true || rawIsTrue.toString().toLowerCase() == 'true';

  return BookingRequestModel(
    id: json['_id'] as String? ?? '',

    // ✅ Null-safe nested object parsing
    hostel: json['hostelId'] != null
        ? BookingHostel.fromJson(json['hostelId'] as Map<String, dynamic>)
        : const BookingHostel(id: '', name: '', address: ''),

    user: json['userId'] != null
        ? BookingUser.fromJson(json['userId'] as Map<String, dynamic>)
        : const BookingUser(id: '', name: '', mobileNumber: ''),

    vendor: json['vendorId'] != null
        ? BookingVendor.fromJson(json['vendorId'] as Map<String, dynamic>)
        : const BookingVendor(id: '', name: '', mobileNumber: ''),

    roomType: json['roomType'] as String? ?? '',
    shareType: json['shareType'] as String? ?? '',
    bookingType: json['bookingType'] as String? ?? '',
    startDate: json['startDate'] != null
        ? DateTime.parse(json['startDate'] as String)
        : DateTime.now(),
    totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    monthlyAdvance: (json['monthlyAdvance'] as num?)?.toDouble() ?? 0.0,
    status: json['status'] as String? ?? '',
    bookingReference: json['bookingReference'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : DateTime.now(),
    isTrue: parsedIsTrue,
  );
}
}