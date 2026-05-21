import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/Ecommerce/category_model.dart';
import 'package:brando_app/models/Ecommerce/order_model.dart';
import 'package:brando_app/models/Ecommerce/product_model.dart';
import 'package:http/http.dart' as http;


class OrderService {
  static const String baseUrl = 'http://187.127.146.52:2003/api/admin';
  
  // Vendor ID - You should get this from your auth service

  // Place order with live location (multiple products)
  Future<Map<String, dynamic>> placeOrderWithLiveLocation({
    required List<Map<String, dynamic>> items, // Array of {productId, quantity}
    required double latitude,
    required double longitude,
  }) async {
    try {
      final userId = await AppPreferences.getUserId();
      final url = Uri.parse('$baseUrl/order');
      print("kkkkkkkk$userId");
      final body = {
        'items': items,
        'userId': userId,
        'deliveryType': 'live_location',
        'latitude': latitude,
        'longitude': longitude,
      };

      print('Request body: ${json.encode(body)}'); // For debugging

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // For debugging

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Order placed successfully',
          'order': OrderModel.fromJson(data['order']),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to place order: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Place order with address (multiple products)
  Future<Map<String, dynamic>> placeOrderWithAddress({
    required List<Map<String, dynamic>> items, // Array of {productId, quantity}
    required String fullName,
    required String phone,
    required String flatNo,
    required String area,
    required String city,
    required String pincode,
  }) async {
    try {
      final userId = await AppPreferences.getUserId();
      final url = Uri.parse('$baseUrl/order');
      
      final body = {
        'items': items,
        'userId': userId,
        'deliveryType': 'address',
        'fullName': fullName,
        'phone': phone,
        'flatNo': flatNo,
        'area': area,
        'city': city,
        'pincode': pincode,
      };

      print('Request body: ${json.encode(body)}'); // For debugging

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // For debugging

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Order placed successfully',
          'order': OrderModel.fromJson(data['order']),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to place order: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Get all orders
  Future<Map<String, dynamic>> getOrders() async {
    try {
      final userId = await AppPreferences.getUserId();
      final url = Uri.parse('$baseUrl/order/user/$userId');
      
      final response = await http.get(url);
      print('Request body: ${json.encode(response.body)}'); // For debugging

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'orders': (data['orders'] as List)
              .map((order) => OrderModel.fromJson(order))
              .toList(),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch orders',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Get products
  Future<Map<String, dynamic>> getProducts() async {
    try {
      final url = Uri.parse('$baseUrl/product');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'products': (data['products'] as List)
              .map((product) => ProductModel.fromJson(product))
              .toList(),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch products',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Get categories
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final url = Uri.parse('$baseUrl/product-category');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'categories': (data['categories'] as List)
              .map((category) => CategoryModel.fromJson(category))
              .toList(),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch categories',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}