// ignore_for_file: unused_field

import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/booking/booking_provider.dart';
import 'package:brando_app/views/history/booking_history.dart';
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

  HostelModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.address,
    required this.monthlyAdvance,
    required this.sharings,
    required this.images,
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

// ─── My Bookings API Service ──────────────────────────────────────────────────

class MyBookingsApiService {
  static const String _baseUrl = 'http://187.127.146.52:2003/api/auth';
  static Future<bool> hasActiveBookingForHostel({
    required String userId,
    required String hostelId,
  }) async {
    final uri = Uri.parse('$_baseUrl/mybookings/$userId');
    final response = await http.get(uri);

    print('Response status code for my bookings ${response.statusCode}');
    print('Response bodyyyyyyyyyyyyy for my bookings ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true) {
        final bookings = (json['bookings'] as List<dynamic>?) ?? [];
        for (final booking in bookings) {
          final bookingHostelId = (booking['hostelId'] is Map)
              ? booking['hostelId']['_id'] as String? ?? ''
              : booking['hostelId'] as String? ?? '';

          // isTrue is returned as a string "true"/"false" from the API
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

// ─── Detail Screen ────────────────────────────────────────────────────────────

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

  // Hostel API state
  HostelModel? _hostel;
  bool _isLoading = true;
  String? _errorMessage;

  String? _userId;

  // ── My Bookings state ──────────────────────────────────────────────────────
  /// Whether the user already has an active (isTrue == true) booking for this hostel
  bool _hasActiveBooking = false;
  bool _isCheckingBooking = false;

  List<Map<String, dynamic>> get _dates {
    final now = DateTime.now();
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return List.generate(7, (i) {
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
          const SnackBar(
            content: Text('Could not open the link. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Returns the selected date formatted as "yyyy-MM-dd" for the API
  String get _selectedStartDate {
    final dates = _dates;
    final selected = dates[_selectedDateIndex]['fullDate'] as DateTime;
    final y = selected.year;
    final m = selected.month.toString().padLeft(2, '0');
    final d = selected.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Returns the exact shareType value from the API
  String get _selectedShareType {
    if (_selectedPriceIndex == null) return '';
    final prices = _currentPrices;
    if (_selectedPriceIndex! >= prices.length) return '';
    return prices[_selectedPriceIndex!]['rawShareType'] as String;
  }

  /// Returns "AC" or "Non-AC" based on the toggle
  String get _selectedRoomType => _isACToggled ? 'AC' : 'Non-AC';

  /// Returns "monthly" or "daily" based on the active tab
  String get _selectedBookingType =>
      _tabController.index == 0 ? 'monthly' : 'daily';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserId();
    _fetchHostel();
  }

  Future<void> _loadUserId() async {
    final id = AppPreferences.getUserId();
    setState(() => _userId = id);
    // Once we have userId and hostelId, check existing bookings
    if (id != null && widget.hostelId != null) {
      _checkExistingBooking(userId: id, hostelId: widget.hostelId!);
    }
  }

  /// Calls the mybookings API and sets [_hasActiveBooking]
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
          _hasActiveBooking = hasActive;
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

  // ─── Booking Request ──────────────────────────────────────────────────────

  Future<void> _handleBooking() async {
    if (_hostel == null || _userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _userId == null
                ? 'User session not found. Please log in again.'
                : 'Hostel data unavailable.',
          ),
          backgroundColor: Colors.red[700],
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
      // Mark locally so the button hides immediately
      setState(() => _hasActiveBooking = true);
      _showBookingSuccessModal();
    } else if (bookingProvider.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookingProvider.errorMessage ?? 'Booking failed.'),
          backgroundColor: Colors.red[700],
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
                MaterialPageRoute(builder: (context) => const BookingHistory()),
              );
            },
          ),
        );
      },
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                                color: Color(0xFFE53935),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            if (_hostel == null)
                              const TextSpan(
                                text: 'Hostels',
                                style: TextStyle(
                                  color: Colors.black,
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

            // Body
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFE53935)),
                ),
              )
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Unable to load hostel details.',
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _fetchHostel,
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFFE53935),
                        ),
                        label: const Text(
                          'Retry',
                          style: TextStyle(color: Color(0xFFE53935)),
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

  Widget _buildContent() {
    final hostel = _hostel!;
    final dates = _dates;
    final prices = _currentPrices;

    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final isProcessing = bookingProvider.isLoading;

        // Show "Already Submitted" if:
        // 1. The mybookings API returned an active booking for this hostel, OR
        // 2. The user just submitted successfully in this session
        // final bool alreadySubmitted =
        //     _hasActiveBooking ||
        //     bookingProvider.isSuccess ||
        //     (bookingProvider.booking?.isTrue == true);

        final bool alreadySubmitted =
            _hasActiveBooking || bookingProvider.isHostelSubmitted(_hostel!.id);

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Hostel Image Carousel ─────────────────────────
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
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Color(0xFFE53935),
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

                                // Dot Indicators
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
                                                    ? const Color(0xFFE53935)
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

                                // Image Counter Badge
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

                      // ── Location Row ──────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFE53935),
                              size: 18,
                            ),
                            Expanded(
                              child: Text(
                                hostel.address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 8),

                            // ── AC Toggle ─────────────────────────────
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
                                      : Colors.grey[300],
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
                                          : Colors.black54,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'AC',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _isACToggled
                                            ? Colors.white
                                            : Colors.black54,
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

                      // ── Rating Row ────────────────────────────────────
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Tab Bar ───────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            onTap: (_) =>
                                setState(() => _selectedPriceIndex = null),
                            indicator: BoxDecoration(
                              color: const Color(0xFFE53935),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black87,
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

                      // ── Prices Header ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _tabController.index == 0
                                    ? 'Monthly Prices for '
                                    : 'Daily Prices for ',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: _isACToggled ? 'AC' : 'Non-AC',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFE53935),
                                ),
                              ),
                              const TextSpan(
                                text: '  (tap a card to select)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Price Grid ────────────────────────────────────
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
                                      ? const Color(0xFFB71C1C)
                                      : const Color(0xFFE53935),
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
                                            color: const Color(
                                              0xFFE53935,
                                            ).withOpacity(0.5),
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

                      // ── Select Date Section ───────────────────────────
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Select Date To Book a Hostel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: dates.length,
                          itemBuilder: (context, index) {
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
                                      ? const Color(0xFFFF0000)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFF0000)
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dates[index]['day'],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : isToday
                                            ? const Color(0xFFE53935)
                                            : Colors.black54,
                                        fontSize: isToday ? 11 : 12,
                                        fontWeight: isToday
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${dates[index]['date']}',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
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
                                activeColor: const Color(0xFFFF0000),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text:
                                            'By signing up, you agree to our ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () => _launchURL(
                                            'https://brando-user-policy.onrender.com/terms-and-conditions',
                                          ),
                                          child: const Text(
                                            'Terms of Use',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFFF0000),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '\nand ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () => _launchURL(
                                            'https://brando-user-policy.onrender.com/privacy-and-policy',
                                          ),
                                          child: const Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFFF0000),
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

                      // ── Terms and Privacy ─────────────────────────────
                      // Only show checkbox if not already submitted and a price is selected
                      // if (_selectedPriceIndex != null && !alreadySubmitted)
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 12),
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Checkbox(
                      //           value: _isAgreed,
                      //           onChanged: (value) =>
                      //               setState(() => _isAgreed = value ?? false),
                      //           activeColor: const Color(0xFFFF0000),
                      //           materialTapTargetSize:
                      //               MaterialTapTargetSize.shrinkWrap,
                      //           visualDensity: VisualDensity.compact,
                      //         ),
                      //         const SizedBox(width: 4),
                      //         Expanded(
                      //           child: Text.rich(
                      //             TextSpan(
                      //               children: const [
                      //                 TextSpan(
                      //                   text:
                      //                       'By signing up, you agree to our ',
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                     color: Colors.black87,
                      //                   ),
                      //                 ),
                      //                 TextSpan(
                      //                   text: 'Terms of Use',
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                     color: Color(0xFFFF0000),
                      //                     decoration: TextDecoration.underline,
                      //                   ),
                      //                 ),
                      //                 TextSpan(
                      //                   text: '\nand ',
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                     color: Colors.black87,
                      //                   ),
                      //                 ),
                      //                 TextSpan(
                      //                   text: 'Privacy Policy',
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                     color: Color(0xFFFF0000),
                      //                     decoration: TextDecoration.underline,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── Book Now / Already Submitted / Checking Button ──────────
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _isCheckingBooking
                      // ── Checking booking state (loading spinner) ─────
                      ? ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      : alreadySubmitted
                      // ── Already Submitted State ──────────────────
                      ? ElevatedButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white70,
                          ),
                          label: const Text(
                            'Already Submitted',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            disabledBackgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        )
                      // ── Normal / Loading State ───────────────────
                      : ElevatedButton(
                          onPressed:
                              (_isAgreed &&
                                  _selectedPriceIndex != null &&
                                  !isProcessing)
                              ? _handleBooking
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF0000),
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: isProcessing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    _selectedPrice != null
                                        ? 'Book Now  ₹${_formatPrice(_selectedPrice!)}/-'
                                        : 'Book Now',
                                    key: ValueKey(_selectedPrice),
                                    style: TextStyle(
                                      color:
                                          (_isAgreed &&
                                              _selectedPriceIndex != null)
                                          ? Colors.white
                                          : Colors.black45,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
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
      color: Colors.grey[200],
      child: const Icon(Icons.image, size: 60, color: Colors.grey),
    );
  }
}

// ─── Booking Success Modal ────────────────────────────────────────────────────

// class _BookingSuccessModal extends StatefulWidget {
//   final VoidCallback onImageTap;

//   const _BookingSuccessModal({required this.onImageTap});

//   @override
//   State<_BookingSuccessModal> createState() => _BookingSuccessModalState();
// }

// class _BookingSuccessModalState extends State<_BookingSuccessModal>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _scaleAnim;
//   late Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _scaleAnim = CurvedAnimation(
//       parent: _animController,
//       curve: Curves.easeOutBack,
//     );
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fadeAnim,
//       child: ScaleTransition(
//         scale: _scaleAnim,
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 30,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GestureDetector(
//                 onTap: widget.onImageTap,
//                 child: Image.asset(
//                   'assets/booking.png',
//                   width: 180,
//                   height: 180,
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: 180,
//                     height: 180,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.hotel,
//                       size: 80,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text.rich(
//                 TextSpan(
//                   children: const [
//                     TextSpan(
//                       text: 'Hostel Booking ',
//                       style: TextStyle(
//                         color: Color(0xFFE53935),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Completed\nSuccessfully',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  late AnimationController _confettiController;

  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Lottie animation controller
    _lottieController = AnimationController(vsync: this);

    // Modal slide-up + fade
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
            color: Colors.white,
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
              // ── Red header band with Lottie ──────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF1744), Color(0xFFE53935)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Decorative circle
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
                        // Lottie animation
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
                          // Fallback if Lottie fails
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
                        // Confirmed badge
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

              // ── Body ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                child: Column(
                  children: [
                    // Title
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
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
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Info card
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFFFFF5F5),
                    //     borderRadius: BorderRadius.circular(16),
                    //     border: Border.all(
                    //       color: const Color(0xFFFFCDD2),
                    //       width: 1.5,
                    //     ),
                    //   ),
                    //   // padding: const EdgeInsets.symmetric(
                    //   //   horizontal: 16, vertical: 12,
                    //   // ),
                    //   // child: Column(
                    //   //   children: [
                    //   //     _InfoRow(
                    //   //       icon: Icons.schedule_rounded,
                    //   //       text: 'Our team will contact you within 24 hrs',
                    //   //     ),
                    //   //     const Divider(
                    //   //       color: Color(0xFFFFE0E0),
                    //   //       height: 16,
                    //   //       thickness: 1,
                    //   //     ),
                    //   //     // _InfoRow(
                    //   //     //   icon: Icons.phone_in_talk_rounded,
                    //   //     //   text: 'Keep your phone ready for confirmation',
                    //   //     // ),
                    //   //     const Divider(
                    //   //       color: Color(0xFFFFE0E0),
                    //   //       height: 16,
                    //   //       thickness: 1,
                    //   //     ),
                    //   //     // _InfoRow(
                    //   //     //   icon: Icons.history_rounded,
                    //   //     //   text: 'Track your booking in History tab',
                    //   //     // ),
                    //   //   ],
                    //   // ),
                    // ),
                    const SizedBox(height: 22),

                    // CTA button
                    GestureDetector(
                      onTap: widget.onImageTap,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF1744), Color(0xFFE53935)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE53935).withOpacity(0.38),
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

                    // Dismiss link
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Stay on this page',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
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

// ── Small info row widget ─────────────────────────────────────────────────────
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
            color: const Color(0xFFFFEBEB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFE53935), size: 16),
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
