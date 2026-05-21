import 'package:brando_app/models/Ecommerce/product_model.dart';

class OrderItem {
  final ProductModel productId;
  final int quantity;
  final int totalPrice;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: ProductModel.fromJson(json['productId'] ?? {}),
      quantity: json['quantity'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
    );
  }
}

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final String? userId;
  final String? vendorId;
  final int grandTotal;
  final String orderedBy;
  final String deliveryType;
  final String status;
  final String paymentStatus;
  final DeliveryAddress? deliveryAddress;
  final LiveLocation? liveLocation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int otp;

  OrderModel({
    required this.id,
    required this.items,
    this.userId,
    this.vendorId,
    required this.grandTotal,
    required this.orderedBy,
    required this.deliveryType,
    required this.status,
    required this.paymentStatus,
    this.deliveryAddress,
    this.liveLocation,
    required this.createdAt,
    required this.updatedAt,
    required this.otp,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle userId - it can be String or Map
    String? userId;
    if (json['userId'] != null) {
      if (json['userId'] is String) {
        userId = json['userId'];
      } else if (json['userId'] is Map) {
        userId = json['userId']['_id']?.toString();
      }
    }

    // Handle vendorId - it can be String, Map, or null
    String? vendorId;
    if (json['vendorId'] != null) {
      if (json['vendorId'] is String) {
        vendorId = json['vendorId'];
      } else if (json['vendorId'] is Map) {
        vendorId = json['vendorId']['_id']?.toString();
      }
    }

    // Handle deliveryAddress - only if it exists and is not null
    DeliveryAddress? deliveryAddress;
    if (json['deliveryAddress'] != null && 
        json['deliveryAddress'] is Map && 
        (json['deliveryAddress'] as Map).isNotEmpty) {
      deliveryAddress = DeliveryAddress.fromJson(json['deliveryAddress']);
    }

    // Handle liveLocation - only if it exists and is not null
    LiveLocation? liveLocation;
    if (json['liveLocation'] != null && 
        json['liveLocation'] is Map && 
        (json['liveLocation'] as Map).isNotEmpty) {
      liveLocation = LiveLocation.fromJson(json['liveLocation']);
    }

    return OrderModel(
      id: json['_id'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      userId: userId,
      vendorId: vendorId,
      grandTotal: json['grandTotal'] ?? 0,
      orderedBy: json['orderedBy'] ?? '',
      deliveryType: json['deliveryType'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      deliveryAddress: deliveryAddress,
      liveLocation: liveLocation,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      otp: json['otp'] ?? 0,
    );
  }
}

class DeliveryAddress {
  final String fullName;
  final String phone;
  final String flatNo;
  final String area;
  final String city;
  final String pincode;

  DeliveryAddress({
    required this.fullName,
    required this.phone,
    required this.flatNo,
    required this.area,
    required this.city,
    required this.pincode,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      flatNo: json['flatNo'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }
}

class LiveLocation {
  final double latitude;
  final double longitude;

  LiveLocation({
    required this.latitude,
    required this.longitude,
  });

  factory LiveLocation.fromJson(Map<String, dynamic> json) {
    return LiveLocation(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}