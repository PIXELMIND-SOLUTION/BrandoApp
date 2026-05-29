import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/Ecommerce/address_model.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressModel> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get default address
  AddressModel? get defaultAddress {
    try {
      return _addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // Get user ID (you can store this in shared preferences or auth provider)

  // Fetch all addresses for user
  Future<bool> fetchAddresses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
            final userId = await AppPreferences.getUserId();

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/user/$userId/addresses'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          List<dynamic> addressesJson = data['addresses'];
          _addresses = addressesJson
              .map((json) => AddressModel.fromJson(json))
              .toList();
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Failed to load addresses';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add new address
  Future<bool> addAddress({
    required String fullName,
    required String phone,
    required String flatNo,
    required String area,
    required String city,
    required String pincode,
    required bool isDefault,
    String addressType = 'home',
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final body = json.encode({
        'fullName': fullName,
        'phone': phone,
        'flatNo': flatNo,
        'area': area,
        'city': city,
        'pincode': pincode,
        'isDefault': isDefault,
        'addressType': addressType,
      });
      final userId = await AppPreferences.getUserId();

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/user/$userId/address'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
print('kkkkkkkkkkkkk${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Refresh addresses after adding
          await fetchAddresses();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Failed to add address';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update address
  Future<bool> updateAddress({
    required String addressId,
    required String fullName,
    required String phone,
    required String flatNo,
    required String area,
    required String city,
    required String pincode,
    required bool isDefault,
    String addressType = 'home',
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final body = json.encode({
        'fullName': fullName,
        'phone': phone,
        'flatNo': flatNo,
        'area': area,
        'city': city,
        'pincode': pincode,
        'isDefault': isDefault,
        'addressType': addressType,
      });
      final userId = await AppPreferences.getUserId();
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/user/$userId/address/$addressId'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Refresh addresses after update
          await fetchAddresses();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Failed to update address';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = await AppPreferences.getUserId();
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/user/$userId/address/$addressId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Refresh addresses after deletion
          await fetchAddresses();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Failed to delete address';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Set address as default
  Future<bool> setDefaultAddress(String addressId) async {
    final address = _addresses.firstWhere((addr) => addr.id == addressId);
    return await updateAddress(
      addressId: addressId,
      fullName: address.fullName,
      phone: address.phone,
      flatNo: address.flatNo,
      area: address.area,
      city: address.city,
      pincode: address.pincode,
      isDefault: true,
      addressType: address.addressType,
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}