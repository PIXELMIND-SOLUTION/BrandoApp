import 'package:brando_app/models/Ecommerce/category_model.dart';
import 'package:brando_app/models/Ecommerce/order_model.dart';
import 'package:brando_app/models/Ecommerce/product_model.dart';
import 'package:brando_app/services/Ecommerce/order_service.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  List<OrderModel> _orders = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Fetch products from API
  Future<bool> fetchProducts() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _orderService.getProducts();
      if (result['success']) {
        _products = result['products'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to fetch products: $e');
      return false;
    }
  }
  
  // Fetch categories from API
  Future<bool> fetchCategories() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _orderService.getCategories();
      if (result['success']) {
        _categories = result['categories'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to fetch categories: $e');
      return false;
    }
  }
  
  // Place order with live location (multiple products)
  Future<Map<String, dynamic>> placeOrderWithLiveLocation({
    required List<Map<String, dynamic>> items,
    required double latitude,
    required double longitude,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _orderService.placeOrderWithLiveLocation(
        items: items,
        latitude: latitude,
        longitude: longitude,
      );
      
      _setLoading(false);
      
      if (result['success']) {
        _orders.insert(0, result['order']);
        notifyListeners();
      }
      
      return result;
    } catch (e) {
      _setError('Failed to place order: $e');
      _setLoading(false);
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
  
  // Place order with address (multiple products)
  Future<Map<String, dynamic>> placeOrderWithAddress({
    required List<Map<String, dynamic>> items,
    required String addressId,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _orderService.placeOrderWithAddress(
        items: items,
        addressId: addressId,
      );
      
      _setLoading(false);
      
      if (result['success']) {
        _orders.insert(0, result['order']);
        notifyListeners();
      }
      
      return result;
    } catch (e) {
      _setError('Failed to place order: $e');
      _setLoading(false);
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
  
  // Fetch orders
  Future<bool> fetchOrders() async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _orderService.getOrders();
      if (result['success']) {
        _orders = result['orders'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to fetch orders: $e');
      return false;
    }
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}