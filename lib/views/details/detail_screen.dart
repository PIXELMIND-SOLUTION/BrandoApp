import 'dart:convert';
import 'package:brando_app/config/theme_config.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/booking/booking_provider.dart';
import 'package:brando_app/views/history/booking_history.dart';
import 'package:brando_app/views/navbar/navbar_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SharingOption {
  final String shareType;
  final int acMonthlyPrice;
  final int acDailyPrice;
  final int nonAcMonthlyPrice;
  final int nonAcDailyPrice;

  SharingOption({
    required this.shareType,
    this.acMonthlyPrice = 0,
    this.acDailyPrice = 0,
    this.nonAcMonthlyPrice = 0,
    this.nonAcDailyPrice = 0,
  });
}

class HostelModel {
  final String id;
  final String name;
  final String type;
  final double rating;
  final String address;
  final int monthlyAdvance;
  final List<SharingOption> sharings;
  final List<String> images;
  final List<String> features;
  final String furnishing;
  final dynamic discount;

  HostelModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.address,
    required this.monthlyAdvance,
    required this.sharings,
    required this.images,
    required this.features,
    required this.furnishing,
    this.discount,
  });

  factory HostelModel.fromJson(Map<String, dynamic> json) {
    final rawSharings = (json['sharings'] as List<dynamic>?) ?? [];
    final Map<String, SharingOption> sharingMap = {};

    for (final item in rawSharings) {
      final shareType = item['shareType'] as String? ?? '';
      final type = (item['type'] as String? ?? '').toUpperCase();
      final monthlyPrice = (item['monthlyPrice'] ?? 0) as int;
      final dailyPrice = (item['dailyPrice'] ?? 0) as int;
      final existing = sharingMap[shareType];

      if (type == 'AC') {
        sharingMap[shareType] = SharingOption(
          shareType: shareType,
          acMonthlyPrice: monthlyPrice,
          acDailyPrice: dailyPrice,
          nonAcMonthlyPrice: existing?.nonAcMonthlyPrice ?? 0,
          nonAcDailyPrice: existing?.nonAcDailyPrice ?? 0,
        );
      } else {
        sharingMap[shareType] = SharingOption(
          shareType: shareType,
          acMonthlyPrice: existing?.acMonthlyPrice ?? 0,
          acDailyPrice: existing?.acDailyPrice ?? 0,
          nonAcMonthlyPrice: monthlyPrice,
          nonAcDailyPrice: dailyPrice,
        );
      }
    }

    return HostelModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      monthlyAdvance: json['monthlyAdvance'] ?? 0,
      sharings: sharingMap.values.toList(),
      images: List<String>.from(json['images'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      furnishing: json['furnishing'] ?? '',
      discount: json['discount'] ?? 0,
    );
  }

  bool get isAC => type.toUpperCase() == 'AC';
}

class HostelApiService {
  static const String _baseUrl = 'http://187.127.146.52:2003/api/Admin';

  static Future<HostelModel> getHostelById(String hostelId) async {
    final uri = Uri.parse('$_baseUrl/hostel/$hostelId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true && json['hostel'] != null) {
        return HostelModel.fromJson(json['hostel']);
      }
      throw Exception('Invalid response format');
    } else {
      throw Exception('Failed to load hostel: ${response.statusCode}');
    }
  }
}

class MyBookingsApiService {
  static const String _baseUrl = 'http://187.127.146.52:2003/api/auth';
  static Future<bool> hasActiveBookingForHostel({
    required String userId,
    required String hostelId,
  }) async {
    final uri = Uri.parse('$_baseUrl/mybookings/$userId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true) {
        final bookings = (json['bookings'] as List<dynamic>?) ?? [];
        for (final booking in bookings) {
          final bookingHostelId = (booking['hostelId'] is Map)
              ? booking['hostelId']['_id'] as String? ?? ''
              : booking['hostelId'] as String? ?? '';

          final isTrue = booking['isTrue'];
          final isTrueBool = isTrue == true || isTrue == 'true';

          if (bookingHostelId == hostelId && isTrueBool) {
            return true;
          }
        }
      }
    }
    return false;
  }
}

class DetailScreen extends StatefulWidget {
  final String? hostelId;

  const DetailScreen({super.key, this.hostelId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isAgreed = false;
  int _selectedDateIndex = 0;
  int _currentImageIndex = 0;

  int? _selectedPriceIndex;
  bool _isACToggled = true;

  HostelModel? _hostel;
  bool _isLoading = true;
  String? _errorMessage;

  String? _userId;

  bool _hasActiveBooking = false;
  bool _isCheckingBooking = false;

  List<Map<String, dynamic>> _dates = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeDates();
    _loadUserId();
    _fetchHostel();
  }

  void _initializeDates() {
    final now = DateTime.now();
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    _dates = List.generate(5, (i) {
      final day = now.add(Duration(days: i));
      return {
        'day': i == 0 ? 'Today' : dayNames[day.weekday % 7],
        'date': day.day,
        'fullDate': day,
      };
    });
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open the link. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String get _selectedStartDate {
    if (_selectedDateIndex < 0 || _selectedDateIndex >= _dates.length) {
      final now = DateTime.now();
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    final selected = _dates[_selectedDateIndex]['fullDate'] as DateTime;
    final y = selected.year;
    final m = selected.month.toString().padLeft(2, '0');
    final d = selected.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String get _selectedShareType {
    if (_selectedPriceIndex == null) return '';
    final prices = _currentPrices;
    if (_selectedPriceIndex! >= prices.length) return '';
    return prices[_selectedPriceIndex!]['rawShareType'] as String;
  }

  String get _selectedRoomType => _isACToggled ? 'AC' : 'Non-AC';
  String get _selectedBookingType =>
      _tabController.index == 0 ? 'monthly' : 'daily';

  Future<void> _loadUserId() async {
    final id = AppPreferences.getUserId();
    setState(() => _userId = id);
    if (id != null && widget.hostelId != null) {
      _checkExistingBooking(userId: id, hostelId: widget.hostelId!);
    }
  }

  Future<void> _checkExistingBooking({
    required String userId,
    required String hostelId,
  }) async {
    setState(() => _isCheckingBooking = true);
    try {
      final hasActive = await MyBookingsApiService.hasActiveBookingForHostel(
        userId: userId,
        hostelId: hostelId,
      );
      if (mounted) {
        setState(() {
          _hasActiveBooking = false;
          _isCheckingBooking = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isCheckingBooking = false);
    }
  }

  Future<void> _fetchHostel() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final hostel = await HostelApiService.getHostelById(
        widget.hostelId.toString(),
      );
      setState(() {
        _hostel = hostel;
        _isACToggled = hostel.sharings.any((s) => s.acMonthlyPrice > 0);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentPrices {
    if (_hostel == null) return [];
    final isMonthly = _tabController.index == 0;

    return _hostel!.sharings
        .map((s) {
          int price;
          if (isMonthly) {
            price = _isACToggled ? s.acMonthlyPrice : s.nonAcMonthlyPrice;
          } else {
            price = _isACToggled ? s.acDailyPrice : s.nonAcDailyPrice;
          }
          return {
            'share': s.shareType.toUpperCase(),
            'rawShareType': s.shareType,
            'price': price,
            'priceFormatted': '${_formatPrice(price)}/-',
          };
        })
        .where((item) => (item['price'] as int) > 0)
        .toList();
  }

  int? get _selectedPrice {
    if (_selectedPriceIndex == null) return null;
    final prices = _currentPrices;
    if (_selectedPriceIndex! >= prices.length) return null;
    return prices[_selectedPriceIndex!]['price'] as int;
  }

  String _formatPrice(int price) {
    if (price >= 1000) {
      final thousands = price ~/ 1000;
      final remainder = price % 1000;
      return remainder == 0
          ? '$thousands,000'
          : '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return price.toString();
  }

  Future<void> _handleBooking() async {
    if (_hostel == null || _userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _userId == null
                ? 'User session not found. Please log in again.'
                : 'Hostel data unavailable.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
      return;
    }

    if (_selectedPriceIndex == null) return;

    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );

    await bookingProvider.createBooking(
      hostelId: _hostel!.id,
      userId: _userId!,
      roomType: _selectedRoomType,
      shareType: _selectedShareType,
      bookingType: _selectedBookingType,
      startDate: _selectedStartDate,
      isTrue: true,
    );

    if (!mounted) return;

    if (bookingProvider.isSuccess) {
      setState(() => _hasActiveBooking = false);
      _showBookingSuccessModal();
    } else if (bookingProvider.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookingProvider.errorMessage ?? 'Booking failed.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
    }
  }

  void _showBookingSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _BookingSuccessModal(
            onImageTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BookingHistory(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _getDiscountedPrice(int originalPrice) {
    if (_hostel?.discount == null || (_hostel!.discount as int) <= 0) {
      return originalPrice;
    }
    final discountPercent = _hostel!.discount as int;
    return originalPrice - ((originalPrice * discountPercent) ~/ 100);
  }

  String _getFormattedDiscountedPrice(int originalPrice) {
    return _formatPrice(_getDiscountedPrice(originalPrice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _hostel == null
          ? const SizedBox.shrink()
          : Consumer<BookingProvider>(
              builder: (context, bookingProvider, _) {
                final isProcessing = bookingProvider.isLoading;
                // final bool alreadySubmitted =
                //     _hasActiveBooking ||
                //     bookingProvider.isHostelSubmitted(_hostel!.id);

                // final bool alreadySubmitted = _hasActiveBooking;
                // bookingProvider.isHostelSubmitted(_hostel!.id);

                final bool alreadySubmitted = _hasActiveBooking;

                return BottomAppBar(
                  elevation: 10,
                  shadowColor: Colors.black,
                  height: 56,
                  surfaceTintColor: AppColors.lightBackground,
                  color: AppColors.lightBackground,
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedShareType.isNotEmpty
                                  ? '${_selectedShareType.toUpperCase()}'
                                  : 'Select a room',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.lightText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (_selectedPrice != null &&
                                    _hostel?.discount != null &&
                                    (_hostel!.discount as int) > 0)
                                  // Show original price with strikethrough
                                  Text(
                                    '₹ ${_formatPrice(_selectedPrice!)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors
                                          .lightTextSecondary
                                          .withOpacity(0.6),
                                      color: AppColors.lightTextSecondary
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                if (_selectedPrice != null &&
                                    _hostel?.discount != null &&
                                    (_hostel!.discount as int) > 0)
                                  const SizedBox(width: 8),
                                // Show discounted price
                                Text(
                                  _selectedPrice != null
                                      ? '₹ ${_hostel?.discount != null && (_hostel!.discount as int) > 0 ? _getFormattedDiscountedPrice(_selectedPrice!) : _formatPrice(_selectedPrice!)}'
                                      : '— —',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (_selectedPrice != null &&
                                    _hostel?.discount != null &&
                                    (_hostel!.discount as int) > 0)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${_hostel!.discount}% OFF',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        _isCheckingBooking
                            ? Container(
                                height: 31,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBorder,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            : alreadySubmitted
                            ? Container(
                                height: 31,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Submitted',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap:
                                    (_isAgreed &&
                                        _selectedPriceIndex != null &&
                                        !isProcessing)
                                    ? _handleBooking
                                    : null,
                                child: Container(
                                  height: 31,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color:
                                        (_isAgreed &&
                                            _selectedPriceIndex != null)
                                        ? AppColors.primary
                                        : AppColors.lightBorder,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: isProcessing
                                      ? const Center(
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Pay after joining',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    (_isAgreed &&
                                                        _selectedPriceIndex !=
                                                            null)
                                                    ? Colors.white
                                                    : AppColors
                                                          .lightTextSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 9),
                                            Icon(
                                              Icons.navigate_next,
                                              color:
                                                  (_isAgreed &&
                                                      _selectedPriceIndex !=
                                                          null)
                                                  ? Colors.white
                                                  : AppColors
                                                        .lightTextSecondary,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back, color: AppColors.lightText),
                  ),
                  Expanded(
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _hostel != null
                                  ? '${_hostel!.name} '
                                  : 'HIFI ',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            if (_hostel == null)
                              TextSpan(
                                text: 'Hostels',
                                style: TextStyle(
                                  color: AppColors.lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Unable to load hostel details.',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _fetchHostel,
                        icon: const Icon(
                          Icons.refresh,
                          color: AppColors.primary,
                        ),
                        label: const Text(
                          'Retry',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              _buildContent(),
          ],
        ),
      ),
    );
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'parking':
        return Icons.local_parking;
      case 'ac':
        return Icons.ac_unit;
      case 'geyser':
        return Icons.water_damage;
      case 'washing machine':
        return Icons.local_laundry_service;
      case 'power backup':
        return Icons.battery_charging_full;
      case 'lift':
        return Icons.elevator;
      case 'security':
        return Icons.security;
      case 'cctv':
        return Icons.videocam;
      case 'food':
        return Icons.restaurant;
      case 'gym':
        return Icons.fitness_center;
      default:
        return Icons.star;
    }
  }

  Widget _buildContent() {
    final hostel = _hostel!;
    final prices = _currentPrices;

    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final isProcessing = bookingProvider.isLoading;
        // final bool alreadySubmitted =
        //     _hasActiveBooking || bookingProvider.isHostelSubmitted(_hostel!.id);
        final bool alreadySubmitted = _hasActiveBooking;

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          if (hostel.images.isNotEmpty)
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 220,
                                    viewportFraction: 1.0,
                                    enlargeCenterPage: false,
                                    autoPlay: hostel.images.length > 1,
                                    autoPlayInterval: const Duration(
                                      seconds: 3,
                                    ),
                                    autoPlayAnimationDuration: const Duration(
                                      milliseconds: 600,
                                    ),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    onPageChanged: (index, reason) {
                                      setState(
                                        () => _currentImageIndex = index,
                                      );
                                    },
                                  ),
                                  items: hostel.images.map((imageUrl) {
                                    return Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      height: 220,
                                      fit: BoxFit.fill,
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return Container(
                                              width: double.infinity,
                                              height: 220,
                                              color: AppColors.lightSurface,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: AppColors.primary,
                                                    ),
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _imagePlaceholder(),
                                    );
                                  }).toList(),
                                ),
                                if (hostel.images.length > 1)
                                  Positioned(
                                    bottom: 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: hostel.images
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                            final isActive =
                                                entry.key == _currentImageIndex;
                                            return AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              width: isActive ? 20 : 8,
                                              height: 8,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isActive
                                                    ? AppColors.primary
                                                    : Colors.white.withOpacity(
                                                        0.7,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 3,
                                                  ),
                                                ],
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_currentImageIndex + 1}/${hostel.images.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            _imagePlaceholder(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            Expanded(
                              child: Text(
                                hostel.address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.lightText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isACToggled = !_isACToggled;
                                  _selectedPriceIndex = null;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _isACToggled
                                      ? const Color(0xFF1565C0)
                                      : AppColors.lightBorder,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.ac_unit,
                                      size: 16,
                                      color: _isACToggled
                                          ? Colors.white
                                          : AppColors.lightTextSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'AC',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _isACToggled
                                            ? Colors.white
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      width: 36,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: _isACToggled
                                            ? Colors.white24
                                            : Colors.black12,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          AnimatedPositioned(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            curve: Curves.easeInOut,
                                            left: _isACToggled ? 16 : 2,
                                            top: 3,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hostel.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (hostel.features.isNotEmpty ||
                          hostel.furnishing.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hostel.furnishing.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.king_bed_rounded,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Furnishing: ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightText,
                                        ),
                                      ),
                                      Text(
                                        hostel.furnishing,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (hostel.features.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: hostel.features.map((feature) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightSurface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(
                                            0.2,
                                          ),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getFeatureIcon(feature),
                                            size: 12,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            feature,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            onTap: (_) =>
                                setState(() => _selectedPriceIndex = null),
                            indicator: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: AppColors.lightText,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(
                                text:
                                    'Monthly Advance (${_formatPrice(hostel.monthlyAdvance)}/-)',
                              ),
                              const Tab(text: 'Daily'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _tabController.index == 0
                                    ? 'Monthly Prices for '
                                    : 'Daily Prices for ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightText,
                                ),
                              ),
                              TextSpan(
                                text: _isACToggled ? 'AC' : 'Non-AC',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const TextSpan(
                                text: '  (tap a card to select)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.lightTextSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: prices.length,
                          itemBuilder: (context, index) {
                            final isSelected = _selectedPriceIndex == index;
                            return GestureDetector(
                              onTap: alreadySubmitted
                                  ? null
                                  : () {
                                      setState(() {
                                        _selectedPriceIndex = isSelected
                                            ? null
                                            : index;
                                        if (!isSelected) _isAgreed = false;
                                      });
                                    },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        )
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.5),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    if (isSelected) const SizedBox(height: 2),
                                    Text(
                                      prices[index]['share'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      prices[index]['priceFormatted'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Select Date To Book a Hostel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _dates.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _dates.length) {
                              final isSelected = _selectedDateIndex == -1;
                              return GestureDetector(
                                onTap: () async {
                                  setState(() => _selectedDateIndex = -1);
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColors.primary,
                                            onPrimary: Colors.white,
                                            onSurface: AppColors.lightText,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null && mounted) {
                                    const dayNames = [
                                      'Sun',
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                    ];
                                    final exists = _dates.any((date) {
                                      final existingDate =
                                          date['fullDate'] as DateTime;
                                      return existingDate.year == picked.year &&
                                          existingDate.month == picked.month &&
                                          existingDate.day == picked.day;
                                    });
                                    if (!exists) {
                                      setState(() {
                                        _dates.add({
                                          'day': dayNames[picked.weekday % 7],
                                          'date': picked.day,
                                          'fullDate': picked,
                                        });
                                        _dates.sort(
                                          (a, b) => (a['fullDate'] as DateTime)
                                              .compareTo(
                                                b['fullDate'] as DateTime,
                                              ),
                                        );
                                        final newIndex = _dates.indexWhere(
                                          (date) =>
                                              (date['fullDate'] as DateTime)
                                                      .year ==
                                                  picked.year &&
                                              (date['fullDate'] as DateTime)
                                                      .month ==
                                                  picked.month &&
                                              (date['fullDate'] as DateTime)
                                                      .day ==
                                                  picked.day,
                                        );
                                        _selectedDateIndex = newIndex;
                                      });
                                    } else {
                                      final existingIndex = _dates.indexWhere((
                                        date,
                                      ) {
                                        final existingDate =
                                            date['fullDate'] as DateTime;
                                        return existingDate.year ==
                                                picked.year &&
                                            existingDate.month ==
                                                picked.month &&
                                            existingDate.day == picked.day;
                                      });
                                      setState(
                                        () =>
                                            _selectedDateIndex = existingIndex,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  width: 52,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.lightBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.lightBorder,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.lightTextSecondary,
                                        size: 24,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Pick',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.lightTextSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            final isSelected = _selectedDateIndex == index;
                            final isToday = index == 0;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedDateIndex = index),
                              child: Container(
                                width: isToday ? 64 : 52,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.lightBorder,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _dates[index]['day'],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : isToday
                                            ? AppColors.primary
                                            : AppColors.lightTextSecondary,
                                        fontSize: isToday ? 11 : 12,
                                        fontWeight: isToday
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_dates[index]['date']}',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.lightText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_selectedPriceIndex != null && !alreadySubmitted)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _isAgreed,
                                onChanged: (value) =>
                                    setState(() => _isAgreed = value ?? false),
                                activeColor: AppColors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'By signing up, you agree to our ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.lightText,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () => _launchURL(
                                            'https://brando-user-policy.onrender.com/terms-and-conditions',
                                          ),
                                          child: Text(
                                            'Terms of Use',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.primary,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nand ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.lightText,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () => _launchURL(
                                            'https://brando-user-policy.onrender.com/privacy-and-policy',
                                          ),
                                          child: Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.primary,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: AppColors.lightSurface,
      child: Icon(Icons.image, size: 60, color: AppColors.lightTextSecondary),
    );
  }
}

class _BookingSuccessModal extends StatefulWidget {
  final VoidCallback onImageTap;
  const _BookingSuccessModal({required this.onImageTap});

  @override
  State<_BookingSuccessModal> createState() => _BookingSuccessModalState();
}

class _BookingSuccessModalState extends State<_BookingSuccessModal>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _slideController;
  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _slideAnim = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: Transform.scale(scale: _scaleAnim.value, child: child),
          ),
        );
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF1744), AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Lottie.asset(
                          'assets/animations/booking_success.json',
                          controller: _lottieController,
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                          onLoaded: (composition) {
                            _lottieController
                              ..duration = composition.duration
                              ..forward();
                          },
                          errorBuilder: (context, error, stack) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 56,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'BOOKING CONFIRMED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Your Hostel Booking\nis ',
                            style: TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.35,
                            ),
                          ),
                          TextSpan(
                            text: 'Successfully Placed!',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: widget.onImageTap,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF1744), AppColors.primary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.38),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'View My Bookings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Stay on this page',
                        style: TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
        ),
      ],
    );
  }
}
