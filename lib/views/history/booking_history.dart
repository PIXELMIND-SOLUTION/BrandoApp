// import 'dart:convert';
// import 'package:brando_app/views/Map/map_screen.dart';
// import 'package:brando_app/views/details/enter_details.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// // Add this class above BookingModel
// class PaymentHistoryEntry {
//   final String date;
//   final double amount;
//   final String status;

//   PaymentHistoryEntry({
//     required this.date,
//     required this.amount,
//     required this.status,
//   });

//   factory PaymentHistoryEntry.fromJson(Map<String, dynamic> json) {
//     return PaymentHistoryEntry(
//       date: json['date'] ?? '',
//       amount: (json['amount'] ?? 0).toDouble(),
//       status: json['status'] ?? '',
//     );
//   }
// }

// class BookingModel {
//   final String id;
//   final String userId;
//   final String hostelId;
//   final String hostelName;
//   final String hostelAddress;
//   final List<String> hostelImages;
//   final String shareType;
//   final String roomType;
//   final String bookingType;
//   final String startDate;
//   final double totalAmount;
//   final double monthlyAdvance;
//   final String status;
//   final String bookingReference;
//   final String createdAt;
//   final String updatedAt;

//   final String? vendorId;
//   final String? vendorName;
//   final String? vendorMobile;

//   // ✅ New fields from completed API
//   final String? roomNo;

//   final List<PaymentHistoryEntry> paymentHistory;

//   BookingModel({
//     required this.id,
//     required this.userId,
//     required this.hostelId,
//     required this.hostelName,
//     required this.hostelAddress,
//     required this.hostelImages,
//     required this.shareType,
//     required this.roomType,
//     required this.bookingType,
//     required this.startDate,
//     required this.totalAmount,
//     required this.monthlyAdvance,
//     required this.status,
//     required this.bookingReference,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.paymentHistory,
//     this.vendorId,
//     this.vendorName,
//     this.vendorMobile,
//     this.roomNo,
//   });

//   factory BookingModel.fromJson(Map<String, dynamic> json) {
//     final hostel = json['hostelId'] as Map<String, dynamic>? ?? {};
//     final rawImages = hostel['images'] as List<dynamic>? ?? [];
//     final vendor = json['vendorId'] as Map<String, dynamic>?;

//     return BookingModel(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       hostelId: hostel['_id'] ?? '',
//       hostelName: hostel['name'] ?? '',
//       hostelAddress: hostel['address'] ?? '',
//       hostelImages: rawImages
//           .map((e) => 'http://187.127.146.52:2003/$e')
//           .toList()
//           .cast<String>(),
//       shareType: json['shareType'] ?? '',
//       roomType: json['roomType'] ?? '',
//       bookingType: json['bookingType'] ?? '',
//       startDate: json['startDate'] ?? '',
//       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
//       monthlyAdvance: (json['monthlyAdvance'] ?? 0).toDouble(),
//       status: json['status'] ?? '',
//       bookingReference: json['bookingReference'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       vendorId: vendor?['_id'],
//       vendorName: vendor?['name'],
//       vendorMobile: vendor?['mobileNumber'],
//       roomNo: json['roomNo'],
//       paymentHistory: (json['paymentHistory'] as List<dynamic>? ?? [])
//           .map((e) => PaymentHistoryEntry.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

// // ─── API Service ──────────────────────────────────────────────────────────────

// class BookingApiService {
//   static const String _baseUrl = 'http://187.127.146.52:2003/api/auth';

//   static Future<Map<String, String>> _authHeaders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   static Future<List<BookingModel>> fetchPendingBookings(String userId) async {
//     final uri = Uri.parse('$_baseUrl/$userId/pending-bookings');
//     final response = await http.get(uri, headers: await _authHeaders());

//     print('Pending bookings status: ${response.statusCode}');
//     print('Pending bookings body: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       if (data['success'] == true && data['bookings'] != null) {
//         final list = data['bookings'] as List<dynamic>;
//         return list
//             .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
//             .toList();
//       }
//     }
//     return [];
//   }

//   static Future<List<BookingModel>> fetchRunningBookings(String userId) async {
//     final uri = Uri.parse('$_baseUrl/$userId/running-bookings');
//     final response = await http.get(uri, headers: await _authHeaders());

//     print('Running bookings status: ${response.statusCode}');
//     print('Running bookings body: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       if (data['success'] == true && data['bookings'] != null) {
//         final list = data['bookings'] as List<dynamic>;
//         return list
//             .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
//             .toList();
//       }
//     }
//     return [];
//   }

//   // ✅ NEW: Fetch completed bookings
//   static Future<List<BookingModel>> fetchCompletedBookings(
//     String userId,
//   ) async {
//     final uri = Uri.parse('$_baseUrl/$userId/completed-bookings');
//     final response = await http.get(uri, headers: await _authHeaders());

//     print('Completed bookings status: ${response.statusCode}');
//     print('Completed bookings body: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       if (data['success'] == true && data['bookings'] != null) {
//         final list = data['bookings'] as List<dynamic>;
//         return list
//             .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
//             .toList();
//       }
//     }
//     return [];
//   }
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────

// class BookingHistory extends StatefulWidget {
//   const BookingHistory({super.key});

//   @override
//   State<BookingHistory> createState() => _BookingHistoryState();
// }

// class _BookingHistoryState extends State<BookingHistory>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   List<BookingModel> _pendingBookings = [];
//   List<BookingModel> _runningBookings = [];
//   List<BookingModel> _completedBookings = []; // ✅ NEW

//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadBookings();
//   }

//   Future<void> _loadBookings() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString('user_id');

//       if (userId == null || userId.isEmpty) {
//         setState(() {
//           _errorMessage = 'User not logged in.';
//           _isLoading = false;
//         });
//         return;
//       }

//       // ✅ Fetch all three in parallel
//       final results = await Future.wait([
//         BookingApiService.fetchPendingBookings(userId),
//         BookingApiService.fetchRunningBookings(userId),
//         BookingApiService.fetchCompletedBookings(userId),
//       ]);

//       setState(() {
//         _pendingBookings = results[0];
//         _runningBookings = results[1];
//         _completedBookings = results[2];
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load bookings. Please try again.';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   String _formatDate(String? isoDate) {
//     if (isoDate == null || isoDate.isEmpty) return 'N/A';
//     try {
//       final dt = DateTime.parse(isoDate);
//       return '${dt.day}/${dt.month}/${dt.year}';
//     } catch (_) {
//       return isoDate;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,

//         elevation: 0,
//         title: RichText(
//           text: const TextSpan(
//             children: [
//               TextSpan(
//                 text: 'Booking ',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               TextSpan(
//                 text: 'History',
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
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(56),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Container(
//               height: 44,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5F5F5),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 indicator: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.red,
//                 labelStyle: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//                 tabs: const [
//                   Tab(text: 'Pending'),
//                   Tab(text: 'Running'),
//                   Tab(text: 'Completed'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.red))
//           : _errorMessage != null
//           ? _buildErrorState()
//           : TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildPendingTab(),
//                 _buildRunningTab(),
//                 _buildCompletedTab(),
//               ],
//             ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 48),
//           const SizedBox(height: 12),
//           Text(
//             _errorMessage!,
//             style: const TextStyle(color: Colors.grey, fontSize: 15),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _loadBookings,
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Retry', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Tabs ─────────────────────────────────────────────────────────────────

//   Widget _buildPendingTab() {
//     if (_pendingBookings.isEmpty) return _buildEmptyTab('No Pending Bookings');
//     return RefreshIndicator(
//       color: Colors.red,
//       onRefresh: _loadBookings,
//       child: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: _pendingBookings.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 12),
//         itemBuilder: (_, i) => GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => EnterDetails(
//                 bookingId: _pendingBookings[i].id,
//                 hostelId: _pendingBookings[i].hostelId,
//               ),
//             ),
//           ),
//           child: _buildPendingCard(_pendingBookings[i]),
//         ),
//       ),
//     );
//   }

//   Widget _buildRunningTab() {
//     if (_runningBookings.isEmpty) return _buildEmptyTab('No Running Bookings');
//     return RefreshIndicator(
//       color: Colors.red,
//       onRefresh: _loadBookings,
//       child: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: _runningBookings.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 12),
//         itemBuilder: (_, i) => _buildRunningCard(_runningBookings[i]),
//       ),
//     );
//   }

//   // ✅ NEW: Completed tab now loads from API
//   Widget _buildCompletedTab() {
//     if (_completedBookings.isEmpty) {
//       return _buildEmptyTab('No Completed Bookings');
//     }
//     return RefreshIndicator(
//       color: Colors.red,
//       onRefresh: _loadBookings,
//       child: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: _completedBookings.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 12),
//         itemBuilder: (_, i) => _buildCompletedCard(_completedBookings[i]),
//       ),
//     );
//   }

//   // Widget _buildEmptyTab(String message) {
//   //   return Center(
//   //     child: Text(
//   //       message,
//   //       style: const TextStyle(color: Colors.grey, fontSize: 16),
//   //     ),
//   //   );
//   // }

//   Widget _buildEmptyTab(String message) {
//     return RefreshIndicator(
//       color: Colors.red,
//       onRefresh: _loadBookings,
//       child: ListView(
//         // ListView is required for RefreshIndicator to work
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           SizedBox(
//             height: 400,
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.inbox_outlined,
//                     color: Colors.grey,
//                     size: 48,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     message,
//                     style: const TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Pull down to refresh',
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPendingCard(BookingModel booking) {
//     final imageUrl = booking.hostelImages.isNotEmpty
//         ? booking.hostelImages.first
//         : null;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: imageUrl != null
//                       ? Image.network(
//                           imageUrl,
//                           width: 80,
//                           height: 80,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => _placeholderImage(),
//                         )
//                       : _placeholderImage(),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Flexible(
//                             child: RichText(
//                               overflow: TextOverflow.ellipsis,
//                               text: TextSpan(
//                                 children: _hostelNameSpans(booking.hostelName),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           _roomTypeBadge(booking.roomType),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             size: 12,
//                             color: Colors.red,
//                           ),
//                           const SizedBox(width: 2),
//                           Expanded(
//                             child: Text(
//                               booking.hostelAddress,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 11,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildInfoChip(
//                             label: booking.shareType,
//                             icon: Icons.people,
//                           ),
//                           Text(
//                             booking.bookingReference,
//                             style: const TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Start Date :',
//                             value: _formatDate(booking.startDate),
//                             borderRight: true,
//                             borderBottom: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Total Amount :',
//                             value:
//                                 '₹${booking.totalAmount.toStringAsFixed(0)}/-',
//                             borderBottom: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Booking Type :',
//                             value: booking.bookingType.toUpperCase(),
//                             valueColor: Colors.yellow,
//                             borderRight: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Booked On :',
//                             value: _formatDate(booking.createdAt),
//                             valueColor: Colors.yellow,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: _actionButton(
//                     icon: Icons.call,
//                     label: 'Call',
//                     onPressed: booking.vendorMobile != null
//                         ? () => _callNumber(booking.vendorMobile!)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _actionButton(
//                     icon: Icons.chat,
//                     label: 'Whatsapp',
//                     onPressed: booking.vendorMobile != null
//                         ? () => _openWhatsApp(booking.vendorMobile!)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _actionButton(
//                     icon: Icons.location_on,
//                     label: 'Location',
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => MapScreen()),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: const [
//                 Text(
//                   'Tap to fill details',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.red,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//                 SizedBox(width: 4),
//                 Icon(Icons.arrow_forward_ios, size: 10, color: Colors.red),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─── Running Card ──────────────────────────────────────────────────────────

//   Widget _buildRunningCard(BookingModel booking) {
//     final imageUrl = booking.hostelImages.isNotEmpty
//         ? booking.hostelImages.first
//         : null;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: imageUrl != null
//                       ? Image.network(
//                           imageUrl,
//                           width: 80,
//                           height: 80,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => _placeholderImage(),
//                         )
//                       : _placeholderImage(),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Flexible(
//                             child: RichText(
//                               overflow: TextOverflow.ellipsis,
//                               text: TextSpan(
//                                 children: _hostelNameSpans(booking.hostelName),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           _roomTypeBadge(booking.roomType),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             size: 12,
//                             color: Colors.red,
//                           ),
//                           const SizedBox(width: 2),
//                           Expanded(
//                             child: Text(
//                               booking.hostelAddress,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 11,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         booking.bookingReference,
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Share Type :',
//                             value: booking.shareType,
//                             borderRight: true,
//                             borderBottom: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Total Amount :',
//                             value:
//                                 '₹${booking.totalAmount.toStringAsFixed(0)}/-',
//                             borderBottom: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Start Date :',
//                             value: _formatDate(booking.startDate),
//                             valueColor: Colors.yellow,
//                             borderRight: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Booked On :',
//                             value: _formatDate(booking.createdAt),
//                             valueColor: Colors.yellow,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (booking.vendorName != null) ...[
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.person, size: 14, color: Colors.red),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Vendor: ${booking.vendorName}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     if (booking.vendorMobile != null) ...[
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () => _callNumber(booking.vendorMobile!),
//                         behavior: HitTestBehavior.opaque,
//                         child: const Icon(
//                           Icons.call,
//                           size: 16,
//                           color: Colors.red,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       GestureDetector(
//                         onTap: () => _openWhatsApp(booking.vendorMobile!),
//                         behavior: HitTestBehavior.opaque,
//                         child: const Icon(
//                           Icons.chat,
//                           size: 16,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//             if (booking.paymentHistory.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               _buildPaymentHistoryWidget(booking.paymentHistory),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // ✅ NEW: Completed Card
//   Widget _buildCompletedCard(BookingModel booking) {
//     final imageUrl = booking.hostelImages.isNotEmpty
//         ? booking.hostelImages.first
//         : null;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header row ──────────────────────────────────────────────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: imageUrl != null
//                       ? Image.network(
//                           imageUrl,
//                           width: 80,
//                           height: 80,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => _placeholderImage(),
//                         )
//                       : _placeholderImage(),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Flexible(
//                             child: RichText(
//                               overflow: TextOverflow.ellipsis,
//                               text: TextSpan(
//                                 children: _hostelNameSpans(booking.hostelName),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           _roomTypeBadge(booking.roomType),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             size: 12,
//                             color: Colors.red,
//                           ),
//                           const SizedBox(width: 2),
//                           Expanded(
//                             child: Text(
//                               booking.hostelAddress,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 11,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildInfoChip(
//                             label: booking.shareType,
//                             icon: Icons.people,
//                           ),
//                           // ✅ Completed status badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 3,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade50,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.green.shade300),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.check_circle,
//                                   size: 10,
//                                   color: Colors.green.shade700,
//                                 ),
//                                 const SizedBox(width: 3),
//                                 Text(
//                                   'COMPLETED',
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.green.shade700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             // Booking reference
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 booking.bookingReference,
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.green.shade600,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Share Type :',
//                             value: booking.shareType,
//                             borderRight: true,
//                             borderBottom: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Total Amount :',
//                             value:
//                                 '₹${booking.totalAmount.toStringAsFixed(0)}/-',
//                             borderBottom: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Start Date :',
//                             value: _formatDate(booking.startDate),
//                             valueColor: Colors.yellow,
//                             borderRight: true,
//                             borderBottom: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Booking Type :',
//                             value: booking.bookingType.toUpperCase(),
//                             valueColor: Colors.yellow,
//                             borderBottom: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Room No :',
//                             value: booking.roomNo ?? 'N/A',
//                             borderRight: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Booked On :',
//                             value: _formatDate(booking.createdAt),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // ── Vendor info ─────────────────────────────────────────────────
//             if (booking.vendorName != null) ...[
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.person, size: 14, color: Colors.green),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Vendor: ${booking.vendorName}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     if (booking.vendorMobile != null) ...[
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () => _callNumber(booking.vendorMobile!),
//                         behavior: HitTestBehavior.opaque,
//                         child: const Icon(
//                           Icons.call,
//                           size: 16,
//                           color: Colors.red,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       GestureDetector(
//                         onTap: () => _openWhatsApp(booking.vendorMobile!),
//                         behavior: HitTestBehavior.opaque,
//                         child: const Icon(
//                           Icons.chat,
//                           size: 16,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//             // ── Payment history ─────────────────────────────────────────────
//             if (booking.paymentHistory.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               _buildPaymentHistoryWidget(booking.paymentHistory),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // ✅ Extracted shared payment history widget (used by running + completed)
//   Widget _buildPaymentHistoryWidget(List<PaymentHistoryEntry> history) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.receipt_long, size: 14, color: Colors.red),
//               SizedBox(width: 6),
//               Text(
//                 'Payment History',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: const [
//               Expanded(
//                 flex: 3,
//                 child: Text(
//                   'Date',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   'Amount',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   'Status',
//                   textAlign: TextAlign.end,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(height: 8, thickness: 0.5),
//           ...history.map(
//             (p) => Padding(
//               padding: const EdgeInsets.symmetric(vertical: 3),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       _formatDate(p.date),
//                       style: const TextStyle(
//                         fontSize: 11,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       '₹${p.amount.toStringAsFixed(0)}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 6,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: p.status.toLowerCase() == 'paid'
//                               ? Colors.green.shade50
//                               : Colors.orange.shade50,
//                           borderRadius: BorderRadius.circular(4),
//                           border: Border.all(
//                             color: p.status.toLowerCase() == 'paid'
//                                 ? Colors.green.shade300
//                                 : Colors.orange.shade300,
//                           ),
//                         ),
//                         child: Text(
//                           p.status.toUpperCase(),
//                           style: TextStyle(
//                             fontSize: 9,
//                             fontWeight: FontWeight.w700,
//                             color: p.status.toLowerCase() == 'paid'
//                                 ? Colors.green.shade700
//                                 : Colors.orange.shade700,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Shared helpers ────────────────────────────────────────────────────────

//   Widget _roomTypeBadge(String roomType) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         roomType,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailCell({
//     required String label,
//     required String value,
//     Color valueColor = Colors.white,
//     bool borderRight = false,
//     bool borderBottom = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border(
//           right: borderRight
//               ? const BorderSide(color: Colors.white24, width: 1)
//               : BorderSide.none,
//           bottom: borderBottom
//               ? const BorderSide(color: Colors.white24, width: 1)
//               : BorderSide.none,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               color: valueColor,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _placeholderImage() {
//     return Container(
//       width: 80,
//       height: 80,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(Icons.hotel, color: Colors.grey),
//     );
//   }

//   List<TextSpan> _hostelNameSpans(String name) {
//     final parts = name.split(' ');
//     if (parts.length == 1) {
//       return [
//         TextSpan(
//           text: name,
//           style: const TextStyle(
//             color: Colors.red,
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//       ];
//     }
//     return [
//       TextSpan(
//         text: '${parts.first} ',
//         style: const TextStyle(
//           color: Colors.red,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//       TextSpan(
//         text: parts.skip(1).join(' '),
//         style: const TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//     ];
//   }

//   Widget _buildInfoChip({required String label, required IconData icon}) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 12, color: Colors.red),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _actionButton({
//     required IconData icon,
//     required String label,
//     VoidCallback? onPressed,
//   }) {
//     return OutlinedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(
//         icon,
//         size: 16,
//         color: onPressed != null ? Colors.red : Colors.grey,
//       ),
//       label: Text(
//         label,
//         style: TextStyle(
//           color: onPressed != null ? Colors.red : Colors.grey,
//           fontSize: 13,
//         ),
//       ),
//       style: OutlinedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         side: BorderSide(color: onPressed != null ? Colors.red : Colors.grey),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   Future<void> _callNumber(String phone) async {
//     final uri = Uri(scheme: 'tel', path: phone.trim());
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else if (mounted) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Could not open dialer')));
//     }
//   }

//   // Future<void> _openWhatsApp(String phone) async {
//   //   final cleaned = phone.trim().replaceAll(RegExp(r'\D'), '');
//   //   final full = cleaned.startsWith('91') ? cleaned : '91$cleaned';
//   //   final uri = Uri.parse('https://wa.me/$full');
//   //   if (await canLaunchUrl(uri)) {
//   //     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   //   } else if (mounted) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp')));
//   //   }
//   // }

//   Future<void> _openWhatsApp(String phoneNumber) async {
//     final message = Uri.encodeComponent(
//       "Hello, I am interested in your hostel.",
//     );
//     final url = Uri.parse("https://wa.me/$phoneNumber?text=$message");

//     try {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open WhatsApp.')),
//         );
//       }
//     }
//   }
// }

import 'dart:convert';
import 'package:brando_app/config/theme_config.dart';
import 'package:brando_app/views/Map/map_screen.dart';
import 'package:brando_app/views/details/enter_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Add this class above BookingModel
class PaymentHistoryEntry {
  final String date;
  final double amount;
  final String status;

  PaymentHistoryEntry({
    required this.date,
    required this.amount,
    required this.status,
  });

  factory PaymentHistoryEntry.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryEntry(
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}

class BookingModel {
  final String id;
  final String userId;
  final String hostelId;
  final String hostelName;
  final String hostelAddress;
  final List<String> hostelImages;
  final String shareType;
  final String roomType;
  final String bookingType;
  final String startDate;
  final double totalAmount;
  final double monthlyAdvance;
  final String status;
  final String bookingReference;
  final String createdAt;
  final String updatedAt;

  final String? vendorId;
  final String? vendorName;
  final String? vendorMobile;

  // ✅ New fields from completed API
  final String? roomNo;

  final List<PaymentHistoryEntry> paymentHistory;

  BookingModel({
    required this.id,
    required this.userId,
    required this.hostelId,
    required this.hostelName,
    required this.hostelAddress,
    required this.hostelImages,
    required this.shareType,
    required this.roomType,
    required this.bookingType,
    required this.startDate,
    required this.totalAmount,
    required this.monthlyAdvance,
    required this.status,
    required this.bookingReference,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentHistory,
    this.vendorId,
    this.vendorName,
    this.vendorMobile,
    this.roomNo,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final hostel = json['hostelId'] as Map<String, dynamic>? ?? {};
    final rawImages = hostel['images'] as List<dynamic>? ?? [];
    final vendor = json['vendorId'] as Map<String, dynamic>?;

    return BookingModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      hostelId: hostel['_id'] ?? '',
      hostelName: hostel['name'] ?? '',
      hostelAddress: hostel['address'] ?? '',
      hostelImages: rawImages
          .map((e) => 'http://187.127.146.52:2003/$e')
          .toList()
          .cast<String>(),
      shareType: json['shareType'] ?? '',
      roomType: json['roomType'] ?? '',
      bookingType: json['bookingType'] ?? '',
      startDate: json['startDate'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      monthlyAdvance: (json['monthlyAdvance'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      bookingReference: json['bookingReference'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      vendorId: vendor?['_id'],
      vendorName: vendor?['name'],
      vendorMobile: vendor?['mobileNumber'],
      roomNo: json['roomNo'],
      paymentHistory: (json['paymentHistory'] as List<dynamic>? ?? [])
          .map((e) => PaymentHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─── API Service ──────────────────────────────────────────────────────────────

class BookingApiService {
  static const String _baseUrl = 'http://187.127.146.52:2003/api/auth';

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<BookingModel>> fetchPendingBookings(String userId) async {
    final uri = Uri.parse('$_baseUrl/$userId/pending-bookings');
    final response = await http.get(uri, headers: await _authHeaders());

    print('Pending bookings status: ${response.statusCode}');
    print('Pending bookings body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true && data['bookings'] != null) {
        final list = data['bookings'] as List<dynamic>;
        return list
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  static Future<List<BookingModel>> fetchRunningBookings(String userId) async {
    final uri = Uri.parse('$_baseUrl/$userId/running-bookings');
    final response = await http.get(uri, headers: await _authHeaders());

    print('Running bookings status: ${response.statusCode}');
    print('Running bookings body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true && data['bookings'] != null) {
        final list = data['bookings'] as List<dynamic>;
        return list
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  // ✅ NEW: Fetch completed bookings
  static Future<List<BookingModel>> fetchCompletedBookings(
    String userId,
  ) async {
    final uri = Uri.parse('$_baseUrl/$userId/completed-bookings');
    final response = await http.get(uri, headers: await _authHeaders());

    print('Completed bookings status: ${response.statusCode}');
    print('Completed bookings body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true && data['bookings'] != null) {
        final list = data['bookings'] as List<dynamic>;
        return list
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<BookingModel> _pendingBookings = [];
  List<BookingModel> _runningBookings = [];
  List<BookingModel> _completedBookings = []; // ✅ NEW

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        setState(() {
          _errorMessage = 'User not logged in.';
          _isLoading = false;
        });
        return;
      }

      // ✅ Fetch all three in parallel
      final results = await Future.wait([
        BookingApiService.fetchPendingBookings(userId),
        BookingApiService.fetchRunningBookings(userId),
        BookingApiService.fetchCompletedBookings(userId),
      ]);

      setState(() {
        _pendingBookings = results[0];
        _runningBookings = results[1];
        _completedBookings = results[2];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load bookings. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Booking ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'History',
                style: TextStyle(
                  color: AppColors.lightText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.primary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Booked'),
                  Tab(text: 'Staying'),
                  Tab(text: 'Vacated'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage != null
          ? _buildErrorState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPendingTab(),
                _buildRunningTab(),
                _buildCompletedTab(),
              ],
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadBookings,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Tabs ─────────────────────────────────────────────────────────────────

  Widget _buildPendingTab() {
    if (_pendingBookings.isEmpty) return _buildEmptyTab('No Pending Bookings');
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadBookings,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingBookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EnterDetails(
                bookingId: _pendingBookings[i].id,
                hostelId: _pendingBookings[i].hostelId,
              ),
            ),
          ),
          child: _buildPendingCard(_pendingBookings[i]),
        ),
      ),
    );
  }

  Widget _buildRunningTab() {
    if (_runningBookings.isEmpty) return _buildEmptyTab('No Running Bookings');
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadBookings,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _runningBookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _buildRunningCard(_runningBookings[i]),
      ),
    );
  }

  Widget _buildCompletedTab() {
    if (_completedBookings.isEmpty) {
      return _buildEmptyTab('No Completed Bookings');
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadBookings,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _completedBookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _buildCompletedCard(_completedBookings[i]),
      ),
    );
  }

  Widget _buildEmptyTab(String message) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadBookings,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 400,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    color: AppColors.lightTextSecondary,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: TextStyle(
                      color: AppColors.lightTextSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pull down to refresh',
                    style: TextStyle(
                      color: AppColors.lightTextSecondary,
                      fontSize: 12,
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

  Widget _buildPendingCard(BookingModel booking) {
    final imageUrl = booking.hostelImages.isNotEmpty
        ? booking.hostelImages.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: _hostelNameSpans(booking.hostelName),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _roomTypeBadge(booking.roomType),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              booking.hostelAddress,
                              style: TextStyle(
                                color: AppColors.lightTextSecondary,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(
                            label: booking.shareType,
                            icon: Icons.people,
                          ),
                          Text(
                            booking.bookingReference,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
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
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Start Date :',
                            value: _formatDate(booking.startDate),
                            borderRight: true,
                            borderBottom: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Total Amount :',
                            value:
                                '₹${booking.totalAmount.toStringAsFixed(0)}/-',
                            borderBottom: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Booking Type :',
                            value: booking.bookingType.toUpperCase(),
                            valueColor: Colors.yellow,
                            borderRight: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Booked On :',
                            value: _formatDate(booking.createdAt),
                            valueColor: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    icon: Icons.call,
                    label: 'Call',
                    onPressed: booking.vendorMobile != null
                        ? () => _callNumber(booking.vendorMobile!)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton(
                    icon: Icons.chat,
                    label: 'Whatsapp',
                    onPressed: booking.vendorMobile != null
                        ? () => _openWhatsApp(booking.vendorMobile!)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton(
                    icon: Icons.location_on,
                    label: 'Location',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MapScreen()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      const TextSpan(text: 'Once you reach '),
                      TextSpan(
                        text: booking.hostelName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' Tap to fill details'),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Running Card ──────────────────────────────────────────────────────────

  Widget _buildRunningCard(BookingModel booking) {
    final imageUrl = booking.hostelImages.isNotEmpty
        ? booking.hostelImages.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: _hostelNameSpans(booking.hostelName),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _roomTypeBadge(booking.roomType),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              booking.hostelAddress,
                              style: TextStyle(
                                color: AppColors.lightTextSecondary,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        booking.bookingReference,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Share Type :',
                            value: booking.shareType,
                            borderRight: true,
                            borderBottom: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Total Amount :',
                            value:
                                '₹${booking.totalAmount.toStringAsFixed(0)}/-',
                            borderBottom: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Start Date :',
                            value: _formatDate(booking.startDate),
                            valueColor: Colors.yellow,
                            borderRight: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Booked On :',
                            value: _formatDate(booking.createdAt),
                            valueColor: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (booking.vendorName != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Vendor: ${booking.vendorName}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightText,
                      ),
                    ),
                    if (booking.vendorMobile != null) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _callNumber(booking.vendorMobile!),
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          Icons.call,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _openWhatsApp(booking.vendorMobile!),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(
                          Icons.chat,
                          size: 16,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (booking.paymentHistory.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildPaymentHistoryWidget(booking.paymentHistory),
            ],
          ],
        ),
      ),
    );
  }

  // ✅ NEW: Completed Card
  Widget _buildCompletedCard(BookingModel booking) {
    final imageUrl = booking.hostelImages.isNotEmpty
        ? booking.hostelImages.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: _hostelNameSpans(booking.hostelName),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _roomTypeBadge(booking.roomType),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              booking.hostelAddress,
                              style: TextStyle(
                                color: AppColors.lightTextSecondary,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(
                            label: booking.shareType,
                            icon: Icons.people,
                          ),
                          // ✅ Completed status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.success.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 10,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'COMPLETED',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success,
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
              ],
            ),
            const SizedBox(height: 4),
            // Booking reference
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                booking.bookingReference,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Share Type :',
                            value: booking.shareType,
                            borderRight: true,
                            borderBottom: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Total Amount :',
                            value:
                                '₹${booking.totalAmount.toStringAsFixed(0)}/-',
                            borderBottom: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Start Date :',
                            value: _formatDate(booking.startDate),
                            valueColor: Colors.yellow,
                            borderRight: true,
                            borderBottom: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Booking Type :',
                            value: booking.bookingType.toUpperCase(),
                            valueColor: Colors.yellow,
                            borderBottom: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Room No :',
                            value: booking.roomNo ?? 'N/A',
                            borderRight: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Booked On :',
                            value: _formatDate(booking.createdAt),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ── Vendor info ─────────────────────────────────────────────────
            if (booking.vendorName != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 14, color: AppColors.success),
                    const SizedBox(width: 6),
                    Text(
                      'Vendor: ${booking.vendorName}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightText,
                      ),
                    ),
                    if (booking.vendorMobile != null) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _callNumber(booking.vendorMobile!),
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          Icons.call,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _openWhatsApp(booking.vendorMobile!),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(
                          Icons.chat,
                          size: 16,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            // ── Payment history ─────────────────────────────────────────────
            if (booking.paymentHistory.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildPaymentHistoryWidget(booking.paymentHistory),
            ],
          ],
        ),
      ),
    );
  }

  // ✅ Extracted shared payment history widget (used by running + completed)
  Widget _buildPaymentHistoryWidget(List<PaymentHistoryEntry> history) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Payment History',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Amount',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Status',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 8, thickness: 0.5),
          ...history.map(
            (p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      _formatDate(p.date),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '₹${p.amount.toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: p.status.toLowerCase() == 'paid'
                              ? AppColors.success.withOpacity(0.1)
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: p.status.toLowerCase() == 'paid'
                                ? AppColors.success.withOpacity(0.3)
                                : Colors.orange.shade300,
                          ),
                        ),
                        child: Text(
                          p.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: p.status.toLowerCase() == 'paid'
                                ? AppColors.success
                                : Colors.orange.shade700,
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
    );
  }

  // ─── Shared helpers ────────────────────────────────────────────────────────

  Widget _roomTypeBadge(String roomType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        roomType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailCell({
    required String label,
    required String value,
    Color valueColor = Colors.white,
    bool borderRight = false,
    bool borderBottom = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          right: borderRight
              ? const BorderSide(color: Colors.white24, width: 1)
              : BorderSide.none,
          bottom: borderBottom
              ? const BorderSide(color: Colors.white24, width: 1)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.hotel, color: AppColors.lightTextSecondary),
    );
  }

  List<TextSpan> _hostelNameSpans(String name) {
    final parts = name.split(' ');
    if (parts.length == 1) {
      return [
        TextSpan(
          text: name,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ];
    }
    return [
      TextSpan(
        text: '${parts.first} ',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      TextSpan(
        text: parts.skip(1).join(' '),
        style: TextStyle(
          color: AppColors.lightText,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ];
  }

  Widget _buildInfoChip({required String label, required IconData icon}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.lightText,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
        color: onPressed != null
            ? AppColors.primary
            : AppColors.lightTextSecondary,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: onPressed != null
              ? AppColors.primary
              : AppColors.lightTextSecondary,
          fontSize: 13,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 6),
        side: BorderSide(
          color: onPressed != null ? AppColors.primary : AppColors.lightBorder,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _callNumber(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open dialer')));
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final message = Uri.encodeComponent(
      "Hello, I am interested in your hostel.",
    );
    final url = Uri.parse("https://wa.me/$phoneNumber?text=$message");

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp.')),
        );
      }
    }
  }
}
