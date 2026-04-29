// import 'package:brando_app/helper/shared_preference.dart';
// import 'package:brando_app/models/request_model.dart';
// import 'package:brando_app/services/booking/request_service.dart';
// import 'package:flutter/material.dart';

// class MybookingScreen extends StatefulWidget {
//   const MybookingScreen({super.key});

//   @override
//   State<MybookingScreen> createState() => _MybookingScreenState();
// }

// class _MybookingScreenState extends State<MybookingScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   List<BookingRequest> _allBookings = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   final List<String> _tabs = ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled'];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: _tabs.length, vsync: this);
//     _loadBookings();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadBookings() async {
//     final userId = AppPreferences.getUserId();
//     if (userId == null || userId.isEmpty) {
//       setState(() => _errorMessage = 'User not logged in.');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final bookings = await BookingApiService.fetchMyBookings(userId);
//       setState(() {
//         _allBookings = bookings;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   List<BookingRequest> _filteredBookings(String tab) {
//     if (tab == 'All') return _allBookings;
//     return _allBookings
//         .where((b) => b.status.toLowerCase() == tab.toLowerCase())
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'My Bookings',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           indicatorColor: Colors.blue,
//           labelColor: Colors.blue,
//           unselectedLabelColor: Colors.grey,
//           tabAlignment: TabAlignment.start,
//           tabs: _tabs.map((t) => Tab(text: t)).toList(),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null
//               ? _buildErrorState()
//               : TabBarView(
//                   controller: _tabController,
//                   children: _tabs
//                       .map((tab) => _buildBookingList(_filteredBookings(tab)))
//                       .toList(),
//                 ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
//             const SizedBox(height: 16),
//             Text(
//               'Something went wrong',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _errorMessage ?? '',
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _loadBookings,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBookingList(List<BookingRequest> bookings) {
//     if (bookings.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.calendar_today_outlined,
//                 size: 72, color: Colors.grey[300]),
//             const SizedBox(height: 16),
//             Text(
//               'No bookings found',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[500],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _loadBookings,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: bookings.length,
//         itemBuilder: (context, index) => _BookingCard(booking: bookings[index]),
//       ),
//     );
//   }
// }

// // ─── Booking Card ─────────────────────────────────────────────────────────────

// // class _BookingCard extends StatelessWidget {
// //   final BookingRequest booking;

// //   const _BookingCard({required this.booking});

// //   Color _statusColor(String status) {
// //     switch (status.toLowerCase()) {
// //       case 'confirmed':
// //         return Colors.green;
// //       case 'pending':
// //         return Colors.orange;
// //       case 'cancelled':
// //         return Colors.red;
// //       case 'completed':
// //         return Colors.blue;
// //       default:
// //         return Colors.grey;
// //     }
// //   }

// //   IconData _statusIcon(String status) {
// //     switch (status.toLowerCase()) {
// //       case 'confirmed':
// //         return Icons.check_circle_outline;
// //       case 'pending':
// //         return Icons.hourglass_empty;
// //       case 'cancelled':
// //         return Icons.cancel_outlined;
// //       case 'completed':
// //         return Icons.task_alt;
// //       default:
// //         return Icons.info_outline;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final statusColor = _statusColor(booking.status);

// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 14),
// //       elevation: 1.5,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Header row: service name + status badge
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Expanded(
// //                   child: Text(
// //                     booking.serviceName ?? 'Booking #${booking.id.length > 6 ? booking.id.substring(booking.id.length - 6) : booking.id}',
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                   decoration: BoxDecoration(
// //                     color: statusColor.withOpacity(0.12),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(_statusIcon(booking.status),
// //                           size: 13, color: statusColor),
// //                       const SizedBox(width: 4),
// //                       Text(
// //                         booking.status[0].toUpperCase() +
// //                             booking.status.substring(1),
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w600,
// //                           color: statusColor,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),

// //             const SizedBox(height: 12),
// //             const Divider(height: 1),
// //             const SizedBox(height: 12),

// //             // Details
// //             if (booking.providerName != null)
// //               _InfoRow(
// //                   icon: Icons.person_outline, label: booking.providerName!),
// //             if (booking.date != null)
// //               _InfoRow(
// //                   icon: Icons.calendar_today_outlined, label: booking.date!),
// //             if (booking.time != null)
// //               _InfoRow(icon: Icons.access_time, label: booking.time!),
// //             if (booking.address != null)
// //               _InfoRow(
// //                   icon: Icons.location_on_outlined, label: booking.address!),
// //             if (booking.amount != null)
// //               _InfoRow(
// //                 icon: Icons.currency_rupee,
// //                 label: booking.amount!.toStringAsFixed(2),
// //                 isBold: true,
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }




// // ─── Booking Card ─────────────────────────────────────────────────────────────

// class _BookingCard extends StatelessWidget {
//   final BookingRequest booking;

//   const _BookingCard({required this.booking});

//   Color _statusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       case 'completed':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _statusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         return Icons.check_circle_outline;
//       case 'pending':
//         return Icons.hourglass_empty;
//       case 'cancelled':
//         return Icons.cancel_outlined;
//       case 'completed':
//         return Icons.task_alt;
//       default:
//         return Icons.info_outline;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _statusColor(booking.status);

//     return Card(
//       margin: const EdgeInsets.only(bottom: 14),
//       elevation: 1.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Banner image ──────────────────────────────────────────────
//           if (booking.i != null && booking.imageUrl!.isNotEmpty)
//             SizedBox(
//               height: 160,
//               width: double.infinity,
//               child: Image.network(
//                 booking.imageUrl!,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) return child;
//                   return Container(
//                     color: Colors.grey[200],
//                     child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   color: Colors.grey[200],
//                   child: const Center(
//                     child: Icon(Icons.image_not_supported_outlined,
//                         size: 40, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── Header: service name + status badge ───────────────
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         booking.serviceName ??
//                             'Booking #${booking.id.length > 6 ? booking.id.substring(booking.id.length - 6) : booking.id}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(_statusIcon(booking.status),
//                               size: 13, color: statusColor),
//                           const SizedBox(width: 4),
//                           Text(
//                             booking.status[0].toUpperCase() +
//                                 booking.status.substring(1),
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: statusColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 12),
//                 const Divider(height: 1),
//                 const SizedBox(height: 12),

//                 // ── Detail rows ───────────────────────────────────────
//                 if (booking.providerName != null)
//                   _InfoRow(icon: Icons.person_outline, label: booking.providerName!),
//                 if (booking.date != null)
//                   _InfoRow(icon: Icons.calendar_today_outlined, label: booking.date!),
//                 if (booking.time != null)
//                   _InfoRow(icon: Icons.access_time, label: booking.time!),
//                 if (booking.address != null)
//                   _InfoRow(icon: Icons.location_on_outlined, label: booking.address!),
//                 if (booking.amount != null)
//                   _InfoRow(
//                     icon: Icons.currency_rupee,
//                     label: booking.amount!.toStringAsFixed(2),
//                     isBold: true,
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isBold;

//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     this.isBold = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13.5,
//                 color: isBold ? Colors.black87 : Colors.grey[700],
//                 fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


















import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/request_model.dart';
import 'package:brando_app/services/booking/request_service.dart';
import 'package:flutter/material.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const String _kBaseUrl = 'http://187.127.146.52:2003/';

class MybookingScreen extends StatefulWidget {
  const MybookingScreen({super.key});

  @override
  State<MybookingScreen> createState() => _MybookingScreenState();
}

class _MybookingScreenState extends State<MybookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<BookingRequest> _allBookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _tabs = [
    'All',
    'Requested',
    'Accepted',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    final userId = AppPreferences.getUserId();
    if (userId == null || userId.isEmpty) {
      setState(() => _errorMessage = 'User not logged in.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookings = await BookingApiService.fetchMyBookings(userId);
      setState(() {
        _allBookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<BookingRequest> _filteredBookings(String tab) {
    if (tab == 'All') return _allBookings;
    return _allBookings
        .where((b) => b.status.toLowerCase() == tab.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabAlignment: TabAlignment.start,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: _tabs
                      .map((tab) => _buildBookingList(_filteredBookings(tab)))
                      .toList(),
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadBookings,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<BookingRequest> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) =>
            _BookingCard(booking: bookings[index]),
      ),
    );
  }
}

// ─── Booking Card ─────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingRequest booking;

  const _BookingCard({required this.booking});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'requested':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle_outline;
      case 'requested':
        return Icons.hourglass_empty;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'completed':
        return Icons.task_alt;
      default:
        return Icons.info_outline;
    }
  }

  /// Formats ISO-8601 date string → "20/04/2026  09:01"
  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$day/$month/${dt.year}  $hour:$min';
    } catch (_) {
      return isoDate;
    }
  }

  /// Builds the full image URL from a relative path like "uploads/xxx.jpg"
  String? _resolveImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.trim().isEmpty) return null;
    // Already a full URL
    if (relativePath.startsWith('http')) return relativePath;
    return '$_kBaseUrl$relativePath';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(booking.status);
    final imageUrl = _resolveImageUrl(booking.hostelImage);

    // Short booking ID suffix for display (last 6 chars)
    final shortId = booking.id.length > 6
        ? booking.id.substring(booking.id.length - 6)
        : booking.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banner image / placeholder ────────────────────────────────
          SizedBox(
            height: 140,
            width: double.infinity,
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: hostel name + status badge ──────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        booking.hostelName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon(booking.status),
                              size: 13, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            booking.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // ── Detail rows ──────────────────────────────────────────
                _InfoRow(
                  icon: Icons.person_outline,
                  label: booking.vendorName,
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: booking.vendorPhone,
                ),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: _formatDate(booking.createdAt),
                ),
                _InfoRow(
                  icon: Icons.tag,
                  label: 'Booking ID: ...$shortId',
                  isMuted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.home_work_outlined, size: 48, color: Colors.grey),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isBold;
  final bool isMuted;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.isBold = false,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                color: isMuted
                    ? Colors.grey[400]
                    : isBold
                        ? Colors.black87
                        : Colors.grey[700],
                fontWeight:
                    isBold ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}