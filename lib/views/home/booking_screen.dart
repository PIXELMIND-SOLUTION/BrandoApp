// import 'dart:convert';
// import 'package:brando_app/helper/shared_preference.dart';
// import 'package:brando_app/provider/upgrade/upgrade_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';


// class HostelInfo {
//   final String id;
//   final String name;
//   final double rating;
//   final String address;
//   final List<String> images;

//   HostelInfo({
//     required this.id,
//     required this.name,
//     required this.rating,
//     required this.address,
//     required this.images,
//   });

//   factory HostelInfo.fromJson(Map<String, dynamic> json) {
//     return HostelInfo(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       rating: (json['rating'] ?? 0).toDouble(),
//       address: json['address'] ?? '',
//       images: List<String>.from(json['images'] ?? []),
//     );
//   }
// }

// class RunningBooking {
//   final String id;
//   final HostelInfo hostel;
//   final String roomType;
//   final String shareType;
//   final String bookingType;
//   final DateTime startDate;
//   final double totalAmount;
//   final String status;
//   final String bookingReference;
//   final bool isTrue;

//   RunningBooking({
//     required this.id,
//     required this.hostel,
//     required this.roomType,
//     required this.shareType,
//     required this.bookingType,
//     required this.startDate,
//     required this.totalAmount,
//     required this.status,
//     required this.bookingReference,
//     required this.isTrue,
//   });

//   factory RunningBooking.fromJson(Map<String, dynamic> json) {
//     return RunningBooking(
//       id: json['_id'] ?? '',
//       hostel: HostelInfo.fromJson(json['hostelId']),
//       roomType: json['roomType'] ?? '',
//       shareType: json['shareType'] ?? '',
//       bookingType: json['bookingType'] ?? '',
//       startDate: DateTime.parse(json['startDate']),
//       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
//       status: json['status'] ?? '',
//       bookingReference: json['bookingReference'] ?? '',
//       isTrue: json['isTrue'].toString() == 'true',
//     );
//   }
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────

// class BookingScreen extends StatefulWidget {
//   const BookingScreen({super.key});

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   // ── State ──────────────────────────────────────────────────────────────────
//   bool _isLoading = true;
//   String? _error;

//   List<RunningBooking> _bookings = [];
//   RunningBooking? _selectedBooking;

//   bool isAC = false;
//   String selectedPlan = 'Monthly';
//   int selectedShareIndex = 0;
//   DateTime selectedDate = DateTime.now();

//   static const String _baseUrl = 'http://187.127.146.52:2003';

//   List<Map<String, dynamic>> get _shareOptions {
//     final seen = <String>{};
//     final options = <Map<String, dynamic>>[];
//     for (final b in _bookings) {
//       if (!seen.contains(b.shareType)) {
//         seen.add(b.shareType);
//         options.add({
//           'label': b.shareType.toUpperCase(),
//           'price': '${b.totalAmount.toInt()}/-',
//           'amount': b.totalAmount,
//           'booking': b,
//         });
//       }
//     }
//     return options;
//   }

//   // ── Calendar helpers ───────────────────────────────────────────────────────
//   List<DateTime> get _next14Days {
//     final today = DateTime.now();
//     return List.generate(14, (i) => today.add(Duration(days: i)));
//   }

//   String _dayLabel(DateTime d) {
//     const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return days[d.weekday - 1];
//   }

//   // ── Lifecycle ──────────────────────────────────────────────────────────────
//   @override
//   void initState() {
//     super.initState();
//     selectedDate = DateTime.now();
//     _fetchBookings();
//   }

//   Future<void> _fetchBookings() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final userId = AppPreferences.getUserId() ?? '69afe465a07d1f7ab12f8569';
//       final token = AppPreferences.getAuthToken() ?? '';

//       final uri = Uri.parse('$_baseUrl/api/auth/$userId/running-bookings');
//       final response = await http.get(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//         },
//       ).timeout(const Duration(seconds: 15));

//       // if (response.statusCode == 200) {
//       //   final data = jsonDecode(response.body) as Map<String, dynamic>;
//       //   final list = (data['bookings'] as List)
//       //       .map((e) => RunningBooking.fromJson(e))
//       //       .toList();

//       //   setState(() {
//       //     _bookings = list;
//       //     _isLoading = false;
//       //     if (list.isNotEmpty) {
//       //       _selectedBooking = list.first;
//       //       isAC = list.first.roomType.toLowerCase().contains('ac') &&
//       //           !list.first.roomType.toLowerCase().contains('non');
//       //       selectedPlan = _capitalize(list.first.bookingType);
//       //       selectedDate = list.first.startDate;
//       //     }
//       //   });
//       // } 




//       if (response.statusCode == 200) {
//   final data = jsonDecode(response.body);

//   // Handle both Map and unexpected response shapes
//   List bookingsList = [];
//   if (data is Map<String, dynamic>) {
//     final raw = data['bookings'];
//     if (raw is List) {
//       bookingsList = raw;
//     }
//   } else if (data is List) {
//     bookingsList = data; // API returned a plain array
//   }

//   final list = bookingsList
//       .map((e) => RunningBooking.fromJson(e as Map<String, dynamic>))
//       .toList();

//   setState(() {
//     _bookings = list;
//     _isLoading = false;
//     if (list.isNotEmpty) {
//       _selectedBooking = list.first;
//       isAC = list.first.roomType.toLowerCase().contains('ac') &&
//           !list.first.roomType.toLowerCase().contains('non');
//       selectedPlan = _capitalize(list.first.bookingType);
//       selectedDate = list.first.startDate;
//     }
//   });
// }
      
      
      
//       else {
//         setState(() {
//           _error = 'Server error: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load bookings: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   String _capitalize(String s) =>
//       s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

//   // ── Selected amount ────────────────────────────────────────────────────────
//   double get _selectedAmount {
//     final opts = _shareOptions;
//     if (opts.isEmpty || selectedShareIndex >= opts.length) {
//       return _selectedBooking?.totalAmount ?? 0;
//     }
//     return opts[selectedShareIndex]['amount'] as double;
//   }

//   // ── Hostel image URL ───────────────────────────────────────────────────────
//   String? get _hostelImageUrl {
//     final images = _selectedBooking?.hostel.images ?? [];
//     if (images.isEmpty) return null;
//     final path = images.first;
//     return '$_baseUrl/$path';
//   }

//   // ── Upgrade Now handler ────────────────────────────────────────────────────
//   Future<void> _onUpgradeNow() async {
//     final booking = _selectedBooking;
//     if (booking == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.orange,
//           content: Text('No booking selected to upgrade.'),
//         ),
//       );
//       return;
//     }

//     final opts = _shareOptions;
//     final selectedShare = opts.isNotEmpty && selectedShareIndex < opts.length
//         ? opts[selectedShareIndex]['booking'] as RunningBooking
//         : booking;

//     // Sync provider fields before calling upgrade
//     final provider = context.read<UpgradeBookingProvider>();
//     provider.setRoomType(isAC ? 'AC' : 'Non-AC');
//     provider.setShareType(selectedShare.shareType);
//     provider.setBookingType(selectedPlan.toLowerCase());
//     provider.setIsTrue(true);

//     final token = AppPreferences.getAuthToken() ?? '';

//     await provider.upgradeBooking(
//       bookingId: booking.id,
//       token: token.isNotEmpty ? token : null,
//     );

//     if (!mounted) return;

//     if (provider.isSuccess) {
//       final upgraded = provider.upgradedBooking;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.green,
//           content: Text(
//             'Upgrade successful! '
//             '₹${upgraded?.totalAmount.toInt() ?? _selectedAmount.toInt()} '
//             '• ${upgraded?.shareType ?? selectedShare.shareType} '
//             '• ${upgraded?.roomType ?? (isAC ? "AC" : "Non-AC")} '
//             '• ${_formatDate(selectedDate)}',
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );

//       // Refresh bookings list to reflect the upgrade
//       _fetchBookings();
//     } else if (provider.hasError) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: const Color(0xFFD32F2F),
//           content: Text(provider.errorMessage ?? 'Upgrade failed. Try again.'),
//           duration: const Duration(seconds: 3),
//           action: SnackBarAction(
//             label: 'Retry',
//             textColor: Colors.white,
//             onPressed: _onUpgradeNow,
//           ),
//         ),
//       );
//     }
//   }

//   // ── UI ─────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: RichText(
//           text: const TextSpan(
//             children: [
//               TextSpan(
//                 text: 'HIFI ',
//                 style: TextStyle(
//                   color: Color(0xFFD32F2F),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               TextSpan(
//                 text: 'Hostels',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: Color(0xFFD32F2F)),
//             )
//           : _error != null
//               ? _buildError()
//               : _buildBody(),
//     );
//   }

//   Widget _buildError() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Color(0xFFD32F2F)),
//             const SizedBox(height: 12),
//             Text(_error!, textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFD32F2F)),
//               onPressed: _fetchBookings,
//               child: const Text('Retry', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {



//       if (_bookings.isEmpty) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.bed_outlined, size: 80, color: Colors.grey[300]),
//             const SizedBox(height: 16),
//             const Text(
//               'No Bookings Found',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'You have no active bookings at the moment.\nExplore hostels and book your stay!',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFD32F2F),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: _fetchBookings,
//               icon: const Icon(Icons.refresh, color: Colors.white),
//               label: const Text(
//                 'Refresh',
//                 style: TextStyle(color: Colors.white, fontSize: 15),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//     final booking = _selectedBooking;
//     final shareOpts = _shareOptions;

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Header Image ───────────────────────────────────────────────────
//           SizedBox(
//             height: 180,
//             width: double.infinity,
//             child: _hostelImageUrl != null
//                 ? Image.network(
//                     _hostelImageUrl!,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (_, child, progress) {
//                       if (progress == null) return child;
//                       return Container(
//                         color: Colors.grey[200],
//                         child: const Center(
//                           child: CircularProgressIndicator(
//                               color: Color(0xFFD32F2F)),
//                         ),
//                       );
//                     },
//                     errorBuilder: (_, __, ___) => _imagePlaceholder(),
//                   )
//                 : _imagePlaceholder(),
//           ),

//           // ── Location Row ───────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_on,
//                     color: Color(0xFFD32F2F), size: 18),
//                 const SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     booking?.hostel.address ?? 'Unknown location',
//                     style: const TextStyle(
//                         fontSize: 13, fontWeight: FontWeight.w500),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const Icon(Icons.keyboard_arrow_down, size: 18),
//               ],
//             ),
//           ),

//           // ── Details Section ────────────────────────────────────────────────
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             child: Text(
//               'Details',
//               style: TextStyle(
//                 color: Color(0xFFD32F2F),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Table(
//               border: TableBorder.all(color: const Color(0xFFD32F2F), width: 1),
//               children: [
//                 TableRow(children: [
//                   _tableCell(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Hostel Name :',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 12)),
//                         Text(
//                           booking?.hostel.name ?? '-',
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 13),
//                         ),
//                       ],
//                     ),
//                     isRed: true,
//                   ),
//                   _tableCell(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Amount Paid :',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 12)),
//                         Text(
//                           booking != null
//                               ? '₹ ${booking.totalAmount.toInt()}/-'
//                               : '-',
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 13),
//                         ),
//                       ],
//                     ),
//                     isRed: false,
//                   ),
//                 ]),
//                 TableRow(children: [
//                   _tableCell(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Room Type :',
//                             style: TextStyle(
//                                 color: Color(0xFFD32F2F), fontSize: 12)),
//                         Text(
//                           booking?.roomType ?? '-',
//                           style: const TextStyle(
//                               color: Color(0xFFD32F2F),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     isRed: false,
//                   ),
//                   _tableCell(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _capitalize(booking?.bookingType ?? ''),
//                           style: const TextStyle(
//                               color: Colors.black, fontSize: 12),
//                         ),
//                         Text(
//                           booking != null
//                               ? '( ${_formatDate(booking.startDate)} )'
//                               : '',
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 11),
//                         ),
//                       ],
//                     ),
//                     isRed: false,
//                   ),
//                 ]),
//               ],
//             ),
//           ),

//           const SizedBox(height: 8),

//           // ── Booking Reference ──────────────────────────────────────────────
//           if (booking != null)
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               child: Row(
//                 children: [
//                   const Icon(Icons.confirmation_number_outlined,
//                       size: 16, color: Colors.grey),
//                   const SizedBox(width: 4),
//                   Text(
//                     'Ref: ${booking.bookingReference}',
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.green[50],
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(color: Colors.green),
//                     ),
//                     child: Text(
//                       booking.status.toUpperCase(),
//                       style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           const SizedBox(height: 20),

//           // ── Upgrade Section ────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Upgrade',
//                   style: TextStyle(
//                     color: Color(0xFFD32F2F),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 // AC / Non-AC Toggle
//                 GestureDetector(
//                   onTap: () => setState(() => isAC = !isAC),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 250),
//                     width: 90,
//                     height: 34,
//                     decoration: BoxDecoration(
//                       color:
//                           isAC ? const Color(0xFFD32F2F) : Colors.grey[400],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text(
//                               'AC',
//                               style: TextStyle(
//                                 color: isAC
//                                     ? Colors.white
//                                     : Colors.transparent,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               'Non-AC',
//                               style: TextStyle(
//                                 color: !isAC
//                                     ? Colors.white
//                                     : Colors.transparent,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         AnimatedAlign(
//                           duration: const Duration(milliseconds: 250),
//                           alignment: isAC
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.all(3),
//                             width: 28,
//                             height: 28,
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 isAC ? 'AC' : 'NA',
//                                 style: TextStyle(
//                                   fontSize: 8,
//                                   fontWeight: FontWeight.bold,
//                                   color: isAC
//                                       ? const Color(0xFFD32F2F)
//                                       : Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           // ── Plan Dropdown ──────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey[300]!),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: selectedPlan,
//                   isExpanded: true,
//                   icon: const Icon(Icons.keyboard_arrow_down,
//                       color: Colors.black),
//                   items: ['Daily', 'Monthly', 'Weekly', 'Yearly']
//                       .map((plan) => DropdownMenuItem(
//                             value: plan,
//                             child: Text(plan,
//                                 style: const TextStyle(fontSize: 15)),
//                           ))
//                       .toList(),
//                   onChanged: (val) => setState(() => selectedPlan = val!),
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // ── Price Label ────────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: '$selectedPlan Prices for ',
//                     style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15),
//                   ),
//                   TextSpan(
//                     text: isAC ? 'AC' : 'Non-AC',
//                     style: const TextStyle(
//                         color: Color(0xFFD32F2F),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),

//           // ── Share Options ──────────────────────────────────────────────────
//           shareOpts.isEmpty
//               ? const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   child: Text('No share options available.',
//                       style: TextStyle(color: Colors.grey)),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: List.generate(shareOpts.length, (index) {
//                       final isSelected = selectedShareIndex == index;
//                       final opt = shareOpts[index];
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedShareIndex = index;
//                             _selectedBooking =
//                                 opt['booking'] as RunningBooking;
//                           });
//                         },
//                         child: Container(
//                           width:
//                               (MediaQuery.of(context).size.width - 24 - 32) /
//                                   3,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 6),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? const Color(0xFFD32F2F)
//                                 : Colors.white,
//                             border: Border.all(
//                               color: isSelected
//                                   ? const Color(0xFFD32F2F)
//                                   : Colors.grey[300]!,
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 opt['label'] as String,
//                                 style: TextStyle(
//                                   color: isSelected
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 11,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 '₹${opt['price']}',
//                                 style: TextStyle(
//                                   color: isSelected
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),

//           const SizedBox(height: 20),

//           // ── Select Date ────────────────────────────────────────────────────
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             child: Text(
//               'Select Date To Book a Hostel',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//           ),

//           const SizedBox(height: 12),

//           SizedBox(
//             height: 70,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: _next14Days.length,
//               itemBuilder: (context, index) {
//                 final date = _next14Days[index];
//                 final isSelected = selectedDate.year == date.year &&
//                     selectedDate.month == date.month &&
//                     selectedDate.day == date.day;
//                 return GestureDetector(
//                   onTap: () => setState(() => selectedDate = date),
//                   child: Container(
//                     width: 55,
//                     margin: const EdgeInsets.only(right: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? const Color(0xFFD32F2F)
//                           : Colors.white,
//                       border: Border.all(
//                         color: isSelected
//                             ? const Color(0xFFD32F2F)
//                             : Colors.grey[300]!,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _dayLabel(date),
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.grey,
//                             fontSize: 13,
//                           ),
//                         ),
//                         Text(
//                           '${date.day}',
//                           style: TextStyle(
//                             color:
//                                 isSelected ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           const SizedBox(height: 30),

//           // ── Upgrade Now Button (watches provider loading state) ────────────
//           Consumer<UpgradeBookingProvider>(
//             builder: (context, provider, _) {
//               final isUpgrading = provider.isLoading;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isUpgrading
//                           ? const Color(0xFFD32F2F).withOpacity(0.7)
//                           : const Color(0xFFD32F2F),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                     ),
//                     onPressed: isUpgrading ? null : _onUpgradeNow,
//                     child: isUpgrading
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2.5,
//                             ),
//                           )
//                         : Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 'Upgrade Now',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 '₹ ${_selectedAmount.toInt()}/-  •  ${isAC ? "AC" : "Non-AC"}  •  $selectedPlan',
//                                 style: const TextStyle(
//                                     color: Colors.white70, fontSize: 11),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               );
//             },
//           ),

//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   // ── Helpers ────────────────────────────────────────────────────────────────

//   Widget _imagePlaceholder() {
//     return Container(
//       color: Colors.grey[200],
//       child: const Center(
//           child: Icon(Icons.image, size: 60, color: Colors.grey)),
//     );
//   }

//   String _formatDate(DateTime d) =>
//       '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

//   Widget _tableCell({required Widget child, required bool isRed}) {
//     return Container(
//       color: isRed ? const Color(0xFFD32F2F) : Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       child: child,
//     );
//   }
// }
















import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/upgrade/upgrade_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class HostelInfo {
  final String id;
  final String name;
  final double rating;
  final String address;
  final List<String> images;

  HostelInfo({
    required this.id,
    required this.name,
    required this.rating,
    required this.address,
    required this.images,
  });

  factory HostelInfo.fromJson(Map<String, dynamic> json) {
    return HostelInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class PendingBooking {
  final String id;
  final HostelInfo hostel;
  final String roomType;
  final String shareType;
  final String bookingType;
  final DateTime startDate;
  final double totalAmount;
  final double monthlyAdvance;
  final String status;
  final String bookingReference;
  final bool isTrue;

  PendingBooking({
    required this.id,
    required this.hostel,
    required this.roomType,
    required this.shareType,
    required this.bookingType,
    required this.startDate,
    required this.totalAmount,
    required this.monthlyAdvance,
    required this.status,
    required this.bookingReference,
    required this.isTrue,
  });

  // factory PendingBooking.fromJson(Map<String, dynamic> json) {
  //   return PendingBooking(
  //     id: json['_id'] ?? '',
  //     hostel: HostelInfo.fromJson(json['hostelId']),
  //     roomType: json['roomType'] ?? '',
  //     shareType: json['shareType'] ?? '',
  //     bookingType: json['bookingType'] ?? '',
  //     startDate: DateTime.parse(json['startDate']),
  //     totalAmount: (json['totalAmount'] ?? 0).toDouble(),
  //     monthlyAdvance: (json['monthlyAdvance'] ?? 0).toDouble(),
  //     status: json['status'] ?? '',
  //     bookingReference: json['bookingReference'] ?? '',
  //     isTrue: json['isTrue'].toString() == 'true',
  //   );
  // }



  factory PendingBooking.fromJson(Map<String, dynamic> json) {
  final hostelData = json['hostelId'];
  return PendingBooking(
    id: json['_id'] ?? '',
    hostel: hostelData != null && hostelData is Map<String, dynamic>
        ? HostelInfo.fromJson(hostelData)
        : HostelInfo(id: '', name: 'Unknown Hostel', rating: 0, address: '', images: []),
    roomType: json['roomType'] ?? '',
    shareType: json['shareType'] ?? '',
    bookingType: json['bookingType'] ?? '',
    startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
    totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    monthlyAdvance: (json['monthlyAdvance'] ?? 0).toDouble(),
    status: json['status'] ?? '',
    bookingReference: json['bookingReference'] ?? '',
    isTrue: json['isTrue'].toString() == 'true',
  );
}
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  bool _isLoading = true;
  String? _error;

  List<PendingBooking> _bookings = [];
  PendingBooking? _selectedBooking;

  bool isAC = false;
  String selectedPlan = 'Monthly';
  int selectedShareIndex = 0;
  DateTime selectedDate = DateTime.now();

  static const String _baseUrl = 'http://187.127.146.52:2003';

  List<Map<String, dynamic>> get _shareOptions {
    final seen = <String>{};
    final options = <Map<String, dynamic>>[];
    for (final b in _bookings) {
      if (!seen.contains(b.shareType)) {
        seen.add(b.shareType);
        options.add({
          'label': b.shareType.toUpperCase(),
          'price': '${b.totalAmount.toInt()}/-',
          'amount': b.totalAmount,
          'booking': b,
        });
      }
    }
    return options;
  }

  // ── Calendar helpers ───────────────────────────────────────────────────────
  List<DateTime> get _next14Days {
    final today = DateTime.now();
    return List.generate(14, (i) => today.add(Duration(days: i)));
  }

  String _dayLabel(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = AppPreferences.getUserId() ?? '69afe465a07d1f7ab12f8569';
      final token = AppPreferences.getAuthToken() ?? '';

      // ── Changed endpoint: running-bookings → pending-bookings ──────────────
      final uri = Uri.parse('$_baseUrl/api/auth/$userId/pending-bookings');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List bookingsList = [];
        if (data is Map<String, dynamic>) {
          final raw = data['bookings'];
          if (raw is List) {
            bookingsList = raw;
          }
        } else if (data is List) {
          bookingsList = data;
        }

        final list = bookingsList
            .map((e) => PendingBooking.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() {
          _bookings = list;
          _isLoading = false;
          if (list.isNotEmpty) {
            _selectedBooking = list.first;
            isAC = list.first.roomType.toLowerCase().contains('ac') &&
                !list.first.roomType.toLowerCase().contains('non');
            selectedPlan = _capitalize(list.first.bookingType);
            selectedDate = list.first.startDate;
          }
        });
      } else {
        setState(() {
          _error = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load bookings: $e';
        _isLoading = false;
      });
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  // ── Selected amount ────────────────────────────────────────────────────────
  double get _selectedAmount {
    final opts = _shareOptions;
    if (opts.isEmpty || selectedShareIndex >= opts.length) {
      return _selectedBooking?.totalAmount ?? 0;
    }
    return opts[selectedShareIndex]['amount'] as double;
  }

  // ── Monthly advance for selected booking ───────────────────────────────────
  double get _selectedMonthlyAdvance {
    final opts = _shareOptions;
    if (opts.isEmpty || selectedShareIndex >= opts.length) {
      return _selectedBooking?.monthlyAdvance ?? 0;
    }
    final booking = opts[selectedShareIndex]['booking'] as PendingBooking;
    return booking.monthlyAdvance;
  }

  // ── Hostel image URL ───────────────────────────────────────────────────────
  String? get _hostelImageUrl {
    final images = _selectedBooking?.hostel.images ?? [];
    if (images.isEmpty) return null;
    final path = images.first;
    return '$_baseUrl/$path';
  }

  // ── Upgrade Now handler ────────────────────────────────────────────────────
  Future<void> _onUpgradeNow() async {
    final booking = _selectedBooking;
    if (booking == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('No booking selected to upgrade.'),
        ),
      );
      return;
    }

    final opts = _shareOptions;
    final selectedShare = opts.isNotEmpty && selectedShareIndex < opts.length
        ? opts[selectedShareIndex]['booking'] as PendingBooking
        : booking;

    final provider = context.read<UpgradeBookingProvider>();
    provider.setRoomType(isAC ? 'AC' : 'Non-AC');
    provider.setShareType(selectedShare.shareType);
    provider.setBookingType(selectedPlan.toLowerCase());
    provider.setIsTrue(true);

    final token = AppPreferences.getAuthToken() ?? '';

    await provider.upgradeBooking(
      bookingId: booking.id,
      token: token.isNotEmpty ? token : null,
    );

    if (!mounted) return;

    if (provider.isSuccess) {
      final upgraded = provider.upgradedBooking;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Upgrade successful! '
            '₹${upgraded?.totalAmount.toInt() ?? _selectedAmount.toInt()} '
            '• ${upgraded?.shareType ?? selectedShare.shareType} '
            '• ${upgraded?.roomType ?? (isAC ? "AC" : "Non-AC")} '
            '• ${_formatDate(selectedDate)}',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      _fetchBookings();
    } else if (provider.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD32F2F),
          content: Text(provider.errorMessage ?? 'Upgrade failed. Try again.'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _onUpgradeNow,
          ),
        ),
      );
    }
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'HIFI ',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
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
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD32F2F)),
            )
          : _error != null
              ? _buildError()
              : _buildBody(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFD32F2F)),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F)),
              onPressed: _fetchBookings,
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bed_outlined, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text(
                'No Pending Bookings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have no pending bookings at the moment.\nExplore hostels and book your stay!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _fetchBookings,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final booking = _selectedBooking;
    final shareOpts = _shareOptions;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Image ───────────────────────────────────────────────────
          SizedBox(
            height: 180,
            width: double.infinity,
            child: _hostelImageUrl != null
                ? Image.network(
                    _hostelImageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFD32F2F)),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),

          // ── Location Row ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    color: Color(0xFFD32F2F), size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    booking?.hostel.address ?? 'Unknown location',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),

          // ── Details Section ────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Details',
              style: TextStyle(
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Table(
              border: TableBorder.all(color: const Color(0xFFD32F2F), width: 1),
              children: [
                TableRow(children: [
                  _tableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hostel Name :',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        Text(
                          booking?.hostel.name ?? '-',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                    isRed: true,
                  ),
                  _tableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount Paid :',
                            style:
                                TextStyle(color: Colors.black, fontSize: 12)),
                        Text(
                          booking != null
                              ? '₹ ${booking.totalAmount.toInt()}/-'
                              : '-',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                    isRed: false,
                  ),
                ]),
                TableRow(children: [
                  _tableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Room Type :',
                            style: TextStyle(
                                color: Color(0xFFD32F2F), fontSize: 12)),
                        Text(
                          booking?.roomType ?? '-',
                          style: const TextStyle(
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    isRed: false,
                  ),
                  _tableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _capitalize(booking?.bookingType ?? ''),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                        ),
                        Text(
                          booking != null
                              ? '( ${_formatDate(booking.startDate)} )'
                              : '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ],
                    ),
                    isRed: false,
                  ),
                ]),
                // ── Extra row: Monthly Advance ─────────────────────────────
                if ((booking?.monthlyAdvance ?? 0) > 0)
                  TableRow(children: [
                    _tableCell(
                      child: const Text(
                        'Monthly Advance :',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      isRed: false,
                    ),
                    _tableCell(
                      child: Text(
                        '₹ ${booking!.monthlyAdvance.toInt()}/-',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      isRed: false,
                    ),
                  ]),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Booking Reference + Pending Badge ──────────────────────────────
          if (booking != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.confirmation_number_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Ref: ${booking.bookingReference}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // ── Upgrade Section ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upgrade',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // AC / Non-AC Toggle
                GestureDetector(
                  onTap: () => setState(() => isAC = !isAC),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 90,
                    height: 34,
                    decoration: BoxDecoration(
                      color:
                          isAC ? const Color(0xFFD32F2F) : Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'AC',
                              style: TextStyle(
                                color: isAC
                                    ? Colors.white
                                    : Colors.transparent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Non-AC',
                              style: TextStyle(
                                color: !isAC
                                    ? Colors.white
                                    : Colors.transparent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          alignment: isAC
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                isAC ? 'AC' : 'NA',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: isAC
                                      ? const Color(0xFFD32F2F)
                                      : Colors.grey,
                                ),
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

          const SizedBox(height: 12),

          // ── Plan Dropdown ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedPlan,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.black),
                  items: ['Daily', 'Monthly', 'Weekly', 'Yearly']
                      .map((plan) => DropdownMenuItem(
                            value: plan,
                            child: Text(plan,
                                style: const TextStyle(fontSize: 15)),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedPlan = val!),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Price Label ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$selectedPlan Prices for ',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  TextSpan(
                    text: isAC ? 'AC' : 'Non-AC',
                    style: const TextStyle(
                        color: Color(0xFFD32F2F),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Share Options ──────────────────────────────────────────────────
          shareOpts.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('No share options available.',
                      style: TextStyle(color: Colors.grey)),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(shareOpts.length, (index) {
                      final isSelected = selectedShareIndex == index;
                      final opt = shareOpts[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedShareIndex = index;
                            _selectedBooking =
                                opt['booking'] as PendingBooking;
                          });
                        },
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width - 24 - 32) /
                                  3,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFD32F2F)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD32F2F)
                                  : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Text(
                                opt['label'] as String,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${opt['price']}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

          const SizedBox(height: 20),

          // ── Select Date ────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Select Date To Book a Hostel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _next14Days.length,
              itemBuilder: (context, index) {
                final date = _next14Days[index];
                final isSelected = selectedDate.year == date.year &&
                    selectedDate.month == date.month &&
                    selectedDate.day == date.day;
                return GestureDetector(
                  onTap: () => setState(() => selectedDate = date),
                  child: Container(
                    width: 55,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFD32F2F)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFD32F2F)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayLabel(date),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : Colors.black,
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

          const SizedBox(height: 30),

          // ── Upgrade Now Button ─────────────────────────────────────────────
          Consumer<UpgradeBookingProvider>(
            builder: (context, provider, _) {
              final isUpgrading = provider.isLoading;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUpgrading
                          ? const Color(0xFFD32F2F).withOpacity(0.7)
                          : const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: isUpgrading ? null : _onUpgradeNow,
                    child: isUpgrading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Upgrade Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '₹ ${_selectedAmount.toInt()}/-  •  ${isAC ? "AC" : "Non-AC"}  •  $selectedPlan',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
          child: Icon(Icons.image, size: 60, color: Colors.grey)),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _tableCell({required Widget child, required bool isRed}) {
    return Container(
      color: isRed ? const Color(0xFFD32F2F) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: child,
    );
  }
}