// import 'package:brando_app/views/details/enter_details.dart';
// import 'package:flutter/material.dart';

// class BookingHistory extends StatefulWidget {
//   const BookingHistory({super.key});

//   @override
//   State<BookingHistory> createState() => _BookingHistoryState();
// }

// class _BookingHistoryState extends State<BookingHistory>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.index = 0;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
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
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildPendingTab(),
//           _buildRunningTab(),
//           _buildEmptyTab('No Completed Bookings'),
//         ],
//       ),
//     );
//   }

//   Widget _buildPendingTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [_buildBookingCard()],
//     );
//   }

//   Widget _buildRunningTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [_buildRunningBookingCard()],
//     );
//   }

//   Widget _buildEmptyTab(String message) {
//     return Center(
//       child: Text(
//         message,
//         style: const TextStyle(color: Colors.grey, fontSize: 16),
//       ),
//     );
//   }

//   /// Running tab card — matches the screenshot design
//   Widget _buildRunningBookingCard() {
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
//             // Top Row: Image + Info
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Hotel Image
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => EnterDetails()),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.asset(
//                       'assets/hotelimage.png',
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         width: 80,
//                         height: 80,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.hotel, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Info Column
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Name + Badge
//                       Row(
//                         children: [
//                           RichText(
//                             text: const TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: 'HIFI ',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: 'HOSTELS',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Text(
//                               '3 Star',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       // Location
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Icon(Icons.location_on, size: 12, color: Colors.red),
//                           SizedBox(width: 2),
//                           Expanded(
//                             child: Text(
//                               'Amd Hyderabad Kukatpally Hyderabad, 500081... BIM Area',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 11,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
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

//             // Details Grid (red background table)
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   // Row 1: Room No | Amount Paid
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Room No :',
//                             value: '101 1st floor',
//                             borderRight: true,
//                             borderBottom: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Amount Paid :',
//                             value: '2,000/-',
//                             borderBottom: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Row 2: Proofs Submitted | Daily dates
//                   IntrinsicHeight(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Proofs Submited :',
//                             value: 'Aadhar Card, Pan Card',
//                             valueColor: Colors.yellow,
//                             borderRight: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildDetailCell(
//                             label: 'Daily',
//                             value: '( 15/2/2026 - 18/2/2026 )',
//                             valueColor: Colors.yellow,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
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

//   // ── Original Pending card ──────────────────────────────────────────────────

//   Widget _buildBookingCard() {
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
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => EnterDetails()),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.asset(
//                       'assets/hotelimage.png',
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         width: 80,
//                         height: 80,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.hotel, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           RichText(
//                             text: const TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: 'HIFI ',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: 'HOSTELS',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Text(
//                               '3 Star',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Icon(Icons.location_on, size: 12, color: Colors.red),
//                           SizedBox(width: 2),
//                           Expanded(
//                             child: Text(
//                               'Amd Hyderabad Kukatpally Hyderabad, 500081... BIM Area',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 11,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildShareOption('1 SHARE', '6,000/-'),
//                           _buildShareOption('2 SHARE', '4,000/-'),
//                           _buildShareOption('3 SHARE', '4,000/-'),
//                           _buildShareOption('4 SHARE', '3,000/-'),
//                           _buildShareOption('5 SHARE', '9,000/-'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             const Divider(height: 1),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(Icons.call, size: 16, color: Colors.red),
//                     label: const Text(
//                       'Call',
//                       style: TextStyle(color: Colors.red, fontSize: 13),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       side: const BorderSide(color: Colors.red),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(Icons.chat, size: 16, color: Colors.red),
//                     label: const Text(
//                       'Whatsapp',
//                       style: TextStyle(color: Colors.red, fontSize: 13),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       side: const BorderSide(color: Colors.red),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.location_on,
//                       size: 16,
//                       color: Colors.red,
//                     ),
//                     label: const Text(
//                       'Location',
//                       style: TextStyle(color: Colors.red, fontSize: 13),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       side: const BorderSide(color: Colors.red),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShareOption(String label, String price) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 9,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         Text(price, style: const TextStyle(fontSize: 9, color: Colors.grey)),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:brando_app/views/Map/map_screen.dart';
import 'package:brando_app/views/details/enter_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class BookingModel {
  final String id;
  final String userId;
  final String hostelId;
  final String hostelName;
  final String hostelAddress;
  final List<String> hostelImages;
  final String shareType;
  final String roomType;
  final String roomNo;
  final String name;
  final String mobileNumber;
  final String email;
  final String aadharCardImage;
  final String panCardImage;
  final String paymentStatus;
  final double price;
  final String? assignedDate;
  final String status;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.hostelId,
    required this.hostelName,
    required this.hostelAddress,
    required this.hostelImages,
    required this.shareType,
    required this.roomType,
    required this.roomNo,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.aadharCardImage,
    required this.panCardImage,
    required this.paymentStatus,
    required this.price,
    this.assignedDate,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final hostel = json['hostelId'] as Map<String, dynamic>? ?? {};
    final rawImages = hostel['images'] as List<dynamic>? ?? [];

    return BookingModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      hostelId: hostel['_id'] ?? '',
      hostelName: hostel['name'] ?? '',
      hostelAddress: hostel['address'] ?? '',
      hostelImages: rawImages
          .map((e) => 'http://31.97.206.144:2003/$e')
          .toList()
          .cast<String>(),
      shareType: json['shareType'] ?? '',
      roomType: json['roomType'] ?? '',
      roomNo: json['roomNo'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      aadharCardImage: json['aadharCardImage'] ?? '',
      panCardImage: json['panCardImage'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      assignedDate: json['assignedDate'],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

// ─── API Service ──────────────────────────────────────────────────────────────

class BookingApiService {
  static const String _baseUrl = 'http://31.97.206.144:2003/api/auth';

  static Future<BookingModel?> fetchMyHostel(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final uri = Uri.parse('$_baseUrl/my-hostel/$userId');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print(
      'Response status code for my hosteeeeeeelllllllllllllll ${response.statusCode}',
    );
    print(
      'Response boddddddddddddyyyyyyyyyyyyyy for my hosteeeeeeelllllllllllllll ${response.body}',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true && data['booking'] != null) {
        return BookingModel.fromJson(data['booking']);
      }
    }
    return null;
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
  BookingModel? _booking;
  bool _isLoading = true;
  String? _errorMessage;

  String? _userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
    _loadBooking();
  }

  Future<void> _loadBooking() async {
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

      // setState(() {
      //   _userId = userId; // 👈 Add this line
      // });

      final booking = await BookingApiService.fetchMyHostel(userId);
      setState(() {
        _booking = booking;
        _isLoading = false;
      });

      // // Auto-switch tab based on status
      // if (booking != null) {
      //   final status = booking.status.toLowerCase();
      //   if (status == 'requested' || status == 'pending') {
      //     _tabController.index = 0;
      //   } else if (status == 'running' || status == 'confirmed') {
      //     _tabController.index = 1;
      //   } else if (status == 'completed') {
      //     _tabController.index = 2;
      //   }
      // }

      // Auto-switch tab based on status
      if (booking != null) {
        final status = booking.status.toLowerCase();
        if (status == 'requested' || status == 'pending') {
          _tabController.index = 0;
        } else if (status == 'running' ||
            status == 'confirmed' ||
            status == 'assigned') {
          _tabController.index = 1;
        } else if (status == 'completed') {
          _tabController.index = 2;
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load booking. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  bool get _isPending {
    if (_booking == null) return false;
    final s = _booking!.status.toLowerCase();
    return s == 'requested' || s == 'pending';
  }

  // bool get _isRunning {
  //   if (_booking == null) return false;
  //   final s = _booking!.status.toLowerCase();
  //   return s == 'running' || s == 'confirmed';
  // }

  // AFTER
  bool get _isRunning {
    if (_booking == null) return false;
    final s = _booking!.status.toLowerCase();
    return s == 'running' || s == 'confirmed' || s == 'assigned';
  }

  bool get _isCompleted {
    if (_booking == null) return false;
    return _booking!.status.toLowerCase() == 'completed';
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'N/A';
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  String get _proofLabels {
    final parts = <String>[];
    if (_booking?.aadharCardImage.isNotEmpty == true) parts.add('Aadhar Card');
    if (_booking?.panCardImage.isNotEmpty == true) parts.add('Pan Card');
    return parts.isEmpty ? 'N/A' : parts.join(', ');
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Booking ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'History',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.red,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Running'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
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
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.grey, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _loadBooking();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Tabs ─────────────────────────────────────────────────────────────────

  Widget _buildPendingTab() {
    if (!_isPending || _booking == null) {
      return _buildEmptyTab('No Pending Bookings');
    }
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: _loadBooking,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [_buildBookingCard(_booking!)],
      ),
    );
  }

  Widget _buildRunningTab() {
    if (!_isRunning || _booking == null) {
      return _buildEmptyTab('No Running Bookings');
    }
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: _loadBooking,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [_buildRunningBookingCard(_booking!)],
      ),
    );
  }

  Widget _buildCompletedTab() {
    if (!_isCompleted || _booking == null) {
      return _buildEmptyTab('No Completed Bookings');
    }
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: _loadBooking,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [_buildRunningBookingCard(_booking!)],
      ),
    );
  }

  Widget _buildEmptyTab(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  // ─── Running Card ─────────────────────────────────────────────────────────

  Widget _buildRunningBookingCard(BookingModel booking) {
    final imageUrl = booking.hostelImages.isNotEmpty
        ? booking.hostelImages.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            // Top Row: Image + Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EnterDetails(hostelId: booking.hostelId),
                      ),
                    );
                  },
                  child: ClipRRect(
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              booking.roomType,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              booking.hostelAddress,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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

            // Details Grid
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Room No :',
                            value: '${booking.roomNo} (${booking.shareType})',
                            borderRight: true,
                            borderBottom: true,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailCell(
                            label: 'Amount Paid :',
                            value: booking.price > 0
                                ? '${booking.price.toStringAsFixed(0)}/-'
                                : 'Pending',
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
                            label: 'Proofs Submitted :',
                            value: _proofLabels,
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
          ],
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

  // ─── Pending Card ─────────────────────────────────────────────────────────

  Widget _buildBookingCard(BookingModel booking) {
    final imageUrl = booking.hostelImages.isNotEmpty
        ? booking.hostelImages.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EnterDetails(hostelId: booking.hostelId),
                      ),
                    );
                  },
                  child: ClipRRect(
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              booking.roomType,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              booking.hostelAddress,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Share Type + Payment Status row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(
                            label: booking.shareType,
                            icon: Icons.people,
                          ),
                          _buildStatusBadge(booking.paymentStatus),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final phone = booking.mobileNumber.trim();
                      final uri = Uri(scheme: 'tel', path: phone);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open dialer'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.call, size: 16, color: Colors.red),
                    label: const Text(
                      'Call',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final phone = booking.mobileNumber.trim().replaceAll(
                        RegExp(r'\D'),
                        '',
                      );
                      final fullPhone = phone.startsWith('91')
                          ? phone
                          : '91$phone';
                      final uri = Uri.parse('https://wa.me/$fullPhone');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open WhatsApp'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.chat, size: 16, color: Colors.red),
                    label: const Text(
                      'Whatsapp',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationScreen(userId:_userId,)));
                    },
                    icon: const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Location',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared Helpers ───────────────────────────────────────────────────────

  Widget _placeholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.hotel, color: Colors.grey),
    );
  }

  List<TextSpan> _hostelNameSpans(String name) {
    final parts = name.split(' ');
    if (parts.length == 1) {
      return [
        TextSpan(
          text: name,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ];
    }
    return [
      TextSpan(
        text: '${parts.first} ',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      TextSpan(
        text: parts.skip(1).join(' '),
        style: const TextStyle(
          color: Colors.black,
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
        Icon(icon, size: 12, color: Colors.red),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    switch (status.toLowerCase()) {
      case 'paid':
        bg = Colors.green;
        break;
      case 'pending':
        bg = Colors.orange;
        break;
      default:
        bg = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bg, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(color: bg, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
