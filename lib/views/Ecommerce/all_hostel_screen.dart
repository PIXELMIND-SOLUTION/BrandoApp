
import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Add this to pubspec.yaml


// ============= MODELS =============

class ProductModel {
  final String id;
  final String name;
  final int price;
  final String type;
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      type: json['type'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

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

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final String vendorId;
  final String? userId;
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
    required this.vendorId,
    this.userId,
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
    return OrderModel(
      id: json['_id'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      vendorId: json['vendorId'] ?? '',
      userId: json['userId'],
      grandTotal: json['grandTotal'] ?? 0,
      orderedBy: json['orderedBy'] ?? '',
      deliveryType: json['deliveryType'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      deliveryAddress: json['deliveryAddress'] != null
          ? DeliveryAddress.fromJson(json['deliveryAddress'])
          : null,
      liveLocation: json['liveLocation'] != null
          ? LiveLocation.fromJson(json['liveLocation'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      otp: json['otp'] ?? 0,
    );
  }
}

// ============= MAIN SCREEN =============

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const Color kGreen = Color(0xFF1D9E75);
  static const Color kBg = Color(0xFFF5F6FA);
  static const Color kCard = Colors.white;
  
  static const String baseUrl = 'http://187.127.146.52:2003/api/admin';

  List<OrderModel> _orders = [];
  List<OrderModel> _filteredOrders = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;

  // Filter variables
  String _selectedStatusFilter = 'All';
  String _selectedDateFilter = 'Today';
  DateTime? _selectedCustomDate;

  // Date filter options
  final List<String> _dateFilterOptions = ['Today', 'Last 5 Days', 'Custom'];

  // Status filter options
  final List<String> _statusFilterOptions = [
    'All',
    'Pending',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String? userId = await AppPreferences.getUserId();
      final url = Uri.parse('$baseUrl/order/user/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> ordersJson = data['orders'];
          setState(() {
            _orders = ordersJson.map((json) => OrderModel.fromJson(json)).toList();
            _applyFilters(); // Apply filters after loading
            _isLoading = false;
            _isRefreshing = false;
          });
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Failed to fetch orders';
            _isLoading = false;
            _isRefreshing = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _isRefreshing = true;
    });
    await _fetchOrders();
  }

  void _applyFilters() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    
    setState(() {
      _filteredOrders = _orders.where((order) {
        // Apply status filter
        if (_selectedStatusFilter != 'All' && 
            order.status.toLowerCase() != _selectedStatusFilter.toLowerCase()) {
          return false;
        }
        
        // Apply date filter
        if (_selectedDateFilter == 'Today') {
          DateTime orderDate = DateTime(order.createdAt.year, order.createdAt.month, order.createdAt.day);
          return orderDate == today;
        } 
        else if (_selectedDateFilter == 'Last 5 Days') {
          DateTime fiveDaysAgo = today.subtract(const Duration(days: 5));
          return order.createdAt.isAfter(fiveDaysAgo) || 
                 order.createdAt.difference(fiveDaysAgo).inDays == 0;
        }
        else if (_selectedDateFilter == 'Custom' && _selectedCustomDate != null) {
          DateTime selectedDate = DateTime(
            _selectedCustomDate!.year, 
            _selectedCustomDate!.month, 
            _selectedCustomDate!.day
          );
          DateTime orderDate = DateTime(order.createdAt.year, order.createdAt.month, order.createdAt.day);
          return orderDate == selectedDate;
        }
        
        return true;
      }).toList();
      
      // Sort by date (newest first)
      _filteredOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _selectCustomDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kGreen,
              onPrimary: Colors.white,
              onSurface: Color(0xFF2C2C2A),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      setState(() {
        _selectedCustomDate = pickedDate;
        _selectedDateFilter = 'Custom';
        _applyFilters();
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'processing':
        return const Color(0xFF2196F3);
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFFFF9800);
    }
  }

  String _getDeliveryTypeIcon(String type) {
    return type == 'live_location' ? '📍' : '🏠';
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kGreen,
          ),
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kGreen,
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: kGreen),
            onPressed: _isRefreshing ? null : _refreshOrders,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter Chips
          _buildStatusFilterChips(),
          // Date Filter Row
          _buildDateFilterRow(),
          // Main Body
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilterOptions.length,
        itemBuilder: (context, index) {
          final status = _statusFilterOptions[index];
          final isSelected = _selectedStatusFilter == status;
          final statusColor = status == 'All' 
              ? Colors.grey 
              : _getStatusColor(status);
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                status,
                style: TextStyle(
                  color: isSelected ? Colors.white : statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              backgroundColor: Colors.white,
              selectedColor: statusColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: statusColor.withOpacity(0.5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedStatusFilter = status;
                  _applyFilters();
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateFilterRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Today Button
          _buildDateFilterButton('Today', _dateFilterOptions[0]),
          const SizedBox(width: 8),
          // Last 5 Days Button
          _buildDateFilterButton('Last 5 Days', _dateFilterOptions[1]),
          const SizedBox(width: 8),
          // Custom Calendar Button
          GestureDetector(
            onTap: _selectCustomDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedDateFilter == 'Custom' ? kGreen : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: _selectedDateFilter == 'Custom' 
                      ? kGreen 
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: _selectedDateFilter == 'Custom' 
                        ? Colors.white 
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _selectedDateFilter == 'Custom' && _selectedCustomDate != null
                        ? DateFormat('dd MMM').format(_selectedCustomDate!)
                        : 'Custom',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _selectedDateFilter == 'Custom' 
                          ? Colors.white 
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (_selectedDateFilter == 'Custom' && _selectedCustomDate != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCustomDate = null;
                            _selectedDateFilter = 'Today';
                            _applyFilters();
                          });
                        },
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: _selectedDateFilter == 'Custom' 
                              ? Colors.white70 
                              : Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterButton(String label, String filterValue) {
    final isSelected = _selectedDateFilter == filterValue;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDateFilter = filterValue;
            if (filterValue != 'Custom') {
              _selectedCustomDate = null;
            }
            _applyFilters();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? kGreen : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? kGreen : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: kGreen),
            SizedBox(height: 16),
            Text(
              'Loading orders...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshOrders,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'No orders found',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (_selectedStatusFilter != 'All' || _selectedDateFilter != 'Today')
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedStatusFilter = 'All';
                    _selectedDateFilter = 'Today';
                    _selectedCustomDate = null;
                    _applyFilters();
                  });
                },
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear Filters'),
                style: TextButton.styleFrom(
                  foregroundColor: kGreen,
                ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: kGreen,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredOrders.length,
        itemBuilder: (_, index) {
          final order = _filteredOrders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  // Keep your existing _buildOrderCard, _showOrderDetailsModal, and other helper methods
  Widget _buildOrderCard(OrderModel order) {
    final firstProduct = order.items.isNotEmpty ? order.items.first.productId : null;
    final displayProducts = order.items.take(2).toList();
    final remainingCount = order.items.length - 2;

    return GestureDetector(
      onTap: () => _showOrderDetailsModal(order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: firstProduct != null
                        ? Image.network(
                            firstProduct.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Order Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order #${order.id.substring(order.id.length > 8 ? order.id.length - 8 : 0)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C2C2A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: kGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'OTP: ${order.otp}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: kGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${_getDeliveryTypeIcon(order.deliveryType)} ${order.deliveryType == 'live_location' ? 'Live Location' : 'Home Delivery'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${order.items.length} items',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          ...displayProducts.map(
                            (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: kBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.productId.name} x${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5F5E5A),
                                ),
                              ),
                            ),
                          ),
                          if (remainingCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: kGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '+$remainingCount more',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: kGreen,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(order.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '₹${order.grandTotal}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showOrderDetailsModal(order),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.remove_red_eye_outlined,
                        size: 16,
                        color: kGreen,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetailsModal(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Order #${order.id.substring(order.id.length > 8 ? order.id.length - 8 : 0)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C2C2A),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: kGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: kGreen.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.lock_open_rounded,
                                      size: 12,
                                      color: kGreen,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'OTP: ${order.otp}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: kGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getStatusColor(order.status),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    order.status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _getStatusColor(order.status),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _getDeliveryTypeIcon(order.deliveryType),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    order.deliveryType == 'live_location'
                                        ? 'Delivery using live location'
                                        : 'Delivery to address',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF2C2C2A),
                                    ),
                                  ),
                                ),
                                if (order.deliveryType == 'address' && order.deliveryAddress != null)
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: kGreen,
                                  ),
                              ],
                            ),
                          ),
                          if (order.deliveryType == 'address' && order.deliveryAddress != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: kBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delivery Address',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${order.deliveryAddress!.fullName}\n${order.deliveryAddress!.phone}\n${order.deliveryAddress!.flatNo}, ${order.deliveryAddress!.area}\n${order.deliveryAddress!.city} - ${order.deliveryAddress!.pincode}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF2C2C2A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (order.deliveryType == 'live_location' && order.liveLocation != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: kBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: kGreen),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Lat: ${order.liveLocation!.latitude.toStringAsFixed(6)}, Lng: ${order.liveLocation!.longitude.toStringAsFixed(6)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2C2C2A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                            color: kGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Order Items (${order.items.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: order.items.length,
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        final product = item.productId;
                        final total = item.totalPrice;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.image_not_supported,
                                      size: 30,
                                      color: kGreen,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2C2C2A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.type,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '₹${product.price} per ${product.type}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      'x${item.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '₹$total',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: kGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Items',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '${order.items.length} items',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Grand Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${order.grandTotal}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}