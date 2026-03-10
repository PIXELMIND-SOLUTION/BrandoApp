// // // import 'package:brando_app/views/history/booking_history.dart';
// // // import 'package:flutter/material.dart';

// // // class DetailScreen extends StatefulWidget {
// // //   const DetailScreen({super.key});

// // //   @override
// // //   State<DetailScreen> createState() => _DetailScreenState();
// // // }

// // // class _DetailScreenState extends State<DetailScreen>
// // //     with SingleTickerProviderStateMixin {
// // //   late TabController _tabController;
// // //   bool _isAC = false;

// // //   bool _isAgreed = false;
// // //   int _selectedDateIndex = 0;

// // //   // ── Dynamic dates: today + next 6 days ──────────────────────────────────
// // //   List<Map<String, dynamic>> get _dates {
// // //     final now = DateTime.now();
// // //     const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
// // //     return List.generate(7, (i) {
// // //       final day = now.add(Duration(days: i));
// // //       return {
// // //         'day': i == 0 ? 'Today' : dayNames[day.weekday % 7],
// // //         'date': day.day,
// // //       };
// // //     });
// // //   }

// // //   final List<Map<String, dynamic>> _monthlyNonAcPrices = [
// // //     {'share': '1 SHARE', 'price': '5,000/-'},
// // //     {'share': '2 SHARE', 'price': '5,000/-'},
// // //     {'share': '3 SHARE', 'price': '5,000/-'},
// // //     {'share': '4 SHARE', 'price': '5,000/-'},
// // //     {'share': '1 SHARE', 'price': '5,000/-'},
// // //     {'share': '2 SHARE', 'price': '5,000/-'},
// // //   ];

// // //   final List<Map<String, dynamic>> _monthlyAcPrices = [
// // //     {'share': '1 SHARE', 'price': '7,000/-'},
// // //     {'share': '2 SHARE', 'price': '6,500/-'},
// // //     {'share': '3 SHARE', 'price': '6,000/-'},
// // //     {'share': '4 SHARE', 'price': '5,500/-'},
// // //     {'share': '1 SHARE', 'price': '7,000/-'},
// // //     {'share': '2 SHARE', 'price': '6,500/-'},
// // //   ];

// // //   final List<Map<String, dynamic>> _dailyPrices = [
// // //     {'share': '1 SHARE', 'price': '500/-'},
// // //     {'share': '2 SHARE', 'price': '450/-'},
// // //     {'share': '3 SHARE', 'price': '400/-'},
// // //     {'share': '4 SHARE', 'price': '350/-'},
// // //     {'share': '1 SHARE', 'price': '500/-'},
// // //     {'share': '2 SHARE', 'price': '450/-'},
// // //   ];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 2, vsync: this);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _tabController.dispose();
// // //     super.dispose();
// // //   }

// // //   void _showBookingSuccessModal() {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       barrierColor: Colors.black54,
// // //       builder: (BuildContext context) {
// // //         return Dialog(
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(20),
// // //           ),
// // //           elevation: 0,
// // //           backgroundColor: Colors.transparent,
// // //           child: _BookingSuccessModal(
// // //             onImageTap: () {
// // //               Navigator.of(context).pop();
// // //               Navigator.of(context).pushReplacement(
// // //                 MaterialPageRoute(builder: (context) => const BookingHistory()),
// // //               );
// // //             },
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final dates = _dates; // evaluated once per build
// // //     final prices = _tabController.index == 0
// // //         ? (_isAC ? _monthlyAcPrices : _monthlyNonAcPrices)
// // //         : _dailyPrices;

// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       body: SafeArea(
// // //         child: Column(
// // //           children: [
// // //             // App Bar
// // //             Padding(
// // //               padding: const EdgeInsets.symmetric(
// // //                 horizontal: 16.0,
// // //                 vertical: 8,
// // //               ),
// // //               child: Row(
// // //                 children: [
// // //                   IconButton(
// // //                     onPressed: () {
// // //                       Navigator.of(context).pop();
// // //                     },
// // //                     icon: const Icon(Icons.arrow_back, color: Colors.black),
// // //                   ),
// // //                   const Expanded(
// // //                     child: Center(
// // //                       child: Text.rich(
// // //                         TextSpan(
// // //                           children: [
// // //                             TextSpan(
// // //                               text: 'HIFI ',
// // //                               style: TextStyle(
// // //                                 color: Color(0xFFE53935),
// // //                                 fontWeight: FontWeight.bold,
// // //                                 fontSize: 20,
// // //                               ),
// // //                             ),
// // //                             TextSpan(
// // //                               text: 'Hostels',
// // //                               style: TextStyle(
// // //                                 color: Colors.black,
// // //                                 fontWeight: FontWeight.bold,
// // //                                 fontSize: 20,
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 24),
// // //                 ],
// // //               ),
// // //             ),

// // //             Expanded(
// // //               child: SingleChildScrollView(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     // Hostel Image
// // //                     Stack(
// // //                       children: [
// // //                         ClipRRect(
// // //                           child: Image.asset(
// // //                             'assets/detailimage.png',
// // //                             width: double.infinity,
// // //                             height: 200,
// // //                             fit: BoxFit.cover,
// // //                             errorBuilder: (context, error, stackTrace) =>
// // //                                 Container(
// // //                                   width: double.infinity,
// // //                                   height: 200,
// // //                                   color: Colors.grey[200],
// // //                                   child: const Icon(
// // //                                     Icons.image,
// // //                                     size: 60,
// // //                                     color: Colors.grey,
// // //                                   ),
// // //                                 ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),

// // //                     // Location Row
// // //                     Padding(
// // //                       padding: const EdgeInsets.symmetric(
// // //                         horizontal: 12,
// // //                         vertical: 8,
// // //                       ),
// // //                       child: Row(
// // //                         children: [
// // //                           const Icon(
// // //                             Icons.location_on,
// // //                             color: Color(0xFFE53935),
// // //                             size: 18,
// // //                           ),
// // //                           const Expanded(
// // //                             child: Text(
// // //                               'Kphb Hyderabad Kukatpally ...',
// // //                               style: TextStyle(
// // //                                 fontSize: 14,
// // //                                 color: Colors.black87,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           const Icon(
// // //                             Icons.keyboard_arrow_down,
// // //                             color: Colors.black54,
// // //                           ),
// // //                           const SizedBox(width: 8),
// // //                           // AC Toggle
// // //                           GestureDetector(
// // //                             onTap: () => setState(() => _isAC = !_isAC),
// // //                             child: Container(
// // //                               padding: const EdgeInsets.symmetric(
// // //                                 horizontal: 10,
// // //                                 vertical: 4,
// // //                               ),
// // //                               decoration: BoxDecoration(
// // //                                 color: _isAC
// // //                                     ? const Color(0xFF1565C0)
// // //                                     : Colors.grey[300],
// // //                                 borderRadius: BorderRadius.circular(20),
// // //                               ),
// // //                               child: Row(
// // //                                 mainAxisSize: MainAxisSize.min,
// // //                                 children: [
// // //                                   Icon(
// // //                                     Icons.ac_unit,
// // //                                     size: 16,
// // //                                     color: _isAC
// // //                                         ? Colors.white
// // //                                         : Colors.black54,
// // //                                   ),
// // //                                   const SizedBox(width: 4),
// // //                                   Text(
// // //                                     'AC',
// // //                                     style: TextStyle(
// // //                                       fontSize: 13,
// // //                                       fontWeight: FontWeight.bold,
// // //                                       color: _isAC
// // //                                           ? Colors.white
// // //                                           : Colors.black54,
// // //                                     ),
// // //                                   ),
// // //                                   const SizedBox(width: 4),
// // //                                   Container(
// // //                                     width: 28,
// // //                                     height: 16,
// // //                                     decoration: BoxDecoration(
// // //                                       color: _isAC
// // //                                           ? Colors.white24
// // //                                           : Colors.black12,
// // //                                       borderRadius: BorderRadius.circular(8),
// // //                                     ),
// // //                                     child: Align(
// // //                                       alignment: _isAC
// // //                                           ? Alignment.centerRight
// // //                                           : Alignment.centerLeft,
// // //                                       child: Container(
// // //                                         width: 14,
// // //                                         height: 14,
// // //                                         margin: const EdgeInsets.symmetric(
// // //                                           horizontal: 1,
// // //                                         ),
// // //                                         decoration: BoxDecoration(
// // //                                           color: _isAC
// // //                                               ? Colors.white
// // //                                               : Colors.white70,
// // //                                           shape: BoxShape.circle,
// // //                                         ),
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),

// // //                     // Tab Bar
// // //                     Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                       child: Container(
// // //                         height: 42,
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.grey[100],
// // //                           borderRadius: BorderRadius.circular(8),
// // //                         ),
// // //                         child: TabBar(
// // //                           controller: _tabController,
// // //                           onTap: (_) => setState(() {}),
// // //                           indicator: BoxDecoration(
// // //                             color: const Color(0xFFE53935),
// // //                             borderRadius: BorderRadius.circular(8),
// // //                           ),
// // //                           indicatorSize: TabBarIndicatorSize.tab,
// // //                           labelColor: Colors.white,
// // //                           unselectedLabelColor: Colors.black87,
// // //                           labelStyle: const TextStyle(
// // //                             fontWeight: FontWeight.w600,
// // //                             fontSize: 12,
// // //                           ),
// // //                           dividerColor: Colors.transparent,
// // //                           tabs: const [
// // //                             Tab(text: 'Monthly Advance (1,000/-)'),
// // //                             Tab(text: 'Daily'),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 16),

// // //                     // Monthly / Daily Prices Header
// // //                     Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                       child: Text.rich(
// // //                         TextSpan(
// // //                           children: [
// // //                             TextSpan(
// // //                               text: _tabController.index == 0
// // //                                   ? 'Monthly Prices for '
// // //                                   : 'Daily Prices for ',
// // //                               style: const TextStyle(
// // //                                 fontSize: 15,
// // //                                 fontWeight: FontWeight.w600,
// // //                                 color: Colors.black,
// // //                               ),
// // //                             ),
// // //                             TextSpan(
// // //                               text: _isAC ? 'AC' : 'Non- Ac',
// // //                               style: const TextStyle(
// // //                                 fontSize: 15,
// // //                                 fontWeight: FontWeight.w600,
// // //                                 color: Color(0xFFE53935),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 12),

// // //                     // Price Grid
// // //                     Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                       child: GridView.builder(
// // //                         shrinkWrap: true,
// // //                         physics: const NeverScrollableScrollPhysics(),
// // //                         gridDelegate:
// // //                             const SliverGridDelegateWithFixedCrossAxisCount(
// // //                               crossAxisCount: 4,
// // //                               childAspectRatio: 1.3,
// // //                               crossAxisSpacing: 8,
// // //                               mainAxisSpacing: 8,
// // //                             ),
// // //                         itemCount: prices.length,
// // //                         itemBuilder: (context, index) {
// // //                           return Container(
// // //                             decoration: BoxDecoration(
// // //                               color: const Color(0xFFE53935),
// // //                               borderRadius: BorderRadius.circular(6),
// // //                             ),
// // //                             child: Column(
// // //                               mainAxisAlignment: MainAxisAlignment.center,
// // //                               children: [
// // //                                 Text(
// // //                                   prices[index]['share'],
// // //                                   style: const TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontSize: 11,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                                 const SizedBox(height: 4),
// // //                                 Text(
// // //                                   prices[index]['price'],
// // //                                   style: const TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontSize: 11,
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           );
// // //                         },
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 20),

// // //                     // Select Date Section
// // //                     const Padding(
// // //                       padding: EdgeInsets.symmetric(horizontal: 12),
// // //                       child: Text(
// // //                         'Select Date To Book a Hostel',
// // //                         style: TextStyle(
// // //                           fontSize: 15,
// // //                           fontWeight: FontWeight.w600,
// // //                           color: Colors.black,
// // //                         ),
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 12),

// // //                     // ── Dynamic Date Selector ──────────────────────────────
// // //                     SizedBox(
// // //                       height: 70,
// // //                       child: ListView.builder(
// // //                         scrollDirection: Axis.horizontal,
// // //                         padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                         itemCount: dates.length,
// // //                         itemBuilder: (context, index) {
// // //                           final isSelected = _selectedDateIndex == index;
// // //                           final isToday = index == 0;
// // //                           return GestureDetector(
// // //                             onTap: () =>
// // //                                 setState(() => _selectedDateIndex = index),
// // //                             child: Container(
// // //                               // Give "Today" a bit more room for the label
// // //                               width: isToday ? 64 : 52,
// // //                               margin: const EdgeInsets.only(right: 8),
// // //                               decoration: BoxDecoration(
// // //                                 color: isSelected
// // //                                     ? const Color(0xFFFF0000)
// // //                                     : Colors.white,
// // //                                 borderRadius: BorderRadius.circular(8),
// // //                                 border: Border.all(
// // //                                   color: isSelected
// // //                                       ? const Color(0xFFFF0000)
// // //                                       : Colors.grey[300]!,
// // //                                 ),
// // //                               ),
// // //                               child: Column(
// // //                                 mainAxisAlignment: MainAxisAlignment.center,
// // //                                 children: [
// // //                                   Text(
// // //                                     dates[index]['day'],
// // //                                     style: TextStyle(
// // //                                       color: isSelected
// // //                                           ? Colors.white
// // //                                           : isToday
// // //                                               ? const Color(0xFFE53935)
// // //                                               : Colors.black54,
// // //                                       fontSize: isToday ? 11 : 12,
// // //                                       fontWeight: isToday
// // //                                           ? FontWeight.bold
// // //                                           : FontWeight.normal,
// // //                                     ),
// // //                                   ),
// // //                                   const SizedBox(height: 4),
// // //                                   Text(
// // //                                     '${dates[index]['date']}',
// // //                                     style: TextStyle(
// // //                                       color: isSelected
// // //                                           ? Colors.white
// // //                                           : Colors.black87,
// // //                                       fontWeight: FontWeight.bold,
// // //                                       fontSize: 18,
// // //                                     ),
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           );
// // //                         },
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 20),

// // //                     // Terms and Privacy
// // //                     Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                       child: Row(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Checkbox(
// // //                             value: _isAgreed,
// // //                             onChanged: (value) {
// // //                               setState(() {
// // //                                 _isAgreed = value ?? false;
// // //                               });
// // //                             },
// // //                             activeColor: const Color(0xFFFF0000),
// // //                             materialTapTargetSize:
// // //                                 MaterialTapTargetSize.shrinkWrap,
// // //                             visualDensity: VisualDensity.compact,
// // //                           ),
// // //                           const SizedBox(width: 4),
// // //                           Expanded(
// // //                             child: Text.rich(
// // //                               TextSpan(
// // //                                 children: [
// // //                                   const TextSpan(
// // //                                     text: 'By signing up, you agree to our ',
// // //                                     style: TextStyle(
// // //                                       fontSize: 12,
// // //                                       color: Colors.black87,
// // //                                     ),
// // //                                   ),
// // //                                   const TextSpan(
// // //                                     text: 'Terms of Use',
// // //                                     style: TextStyle(
// // //                                       fontSize: 12,
// // //                                       color: Color(0xFFFF0000),
// // //                                       decoration: TextDecoration.underline,
// // //                                     ),
// // //                                   ),
// // //                                   const TextSpan(
// // //                                     text: '\nand ',
// // //                                     style: TextStyle(
// // //                                       fontSize: 12,
// // //                                       color: Colors.black87,
// // //                                     ),
// // //                                   ),
// // //                                   const TextSpan(
// // //                                     text: 'Privacy Policy',
// // //                                     style: TextStyle(
// // //                                       fontSize: 12,
// // //                                       color: Color(0xFFFF0000),
// // //                                       decoration: TextDecoration.underline,
// // //                                     ),
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 16),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),

// // //             // Pay After Join Button
// // //             Padding(
// // //               padding: const EdgeInsets.all(12),
// // //               child: SizedBox(
// // //                 width: double.infinity,
// // //                 height: 50,
// // //                 child: ElevatedButton(
// // //                   onPressed: _isAgreed ? _showBookingSuccessModal : null,
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: const Color(0xFFFF0000),
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                     ),
// // //                     elevation: 2,
// // //                   ),
// // //                   child: const Text(
// // //                     'Pay After Join',
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.w600,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ─── Booking Success Modal ────────────────────────────────────────────────────

// // // class _BookingSuccessModal extends StatefulWidget {
// // //   final VoidCallback onImageTap;

// // //   const _BookingSuccessModal({required this.onImageTap});

// // //   @override
// // //   State<_BookingSuccessModal> createState() => _BookingSuccessModalState();
// // // }

// // // class _BookingSuccessModalState extends State<_BookingSuccessModal>
// // //     with SingleTickerProviderStateMixin {
// // //   late AnimationController _animController;
// // //   late Animation<double> _scaleAnim;
// // //   late Animation<double> _fadeAnim;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _animController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 400),
// // //     );
// // //     _scaleAnim = CurvedAnimation(
// // //       parent: _animController,
// // //       curve: Curves.easeOutBack,
// // //     );
// // //     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
// // //     _animController.forward();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _animController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return FadeTransition(
// // //       opacity: _fadeAnim,
// // //       child: ScaleTransition(
// // //         scale: _scaleAnim,
// // //         child: Container(
// // //           margin: const EdgeInsets.symmetric(horizontal: 20),
// // //           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
// // //           decoration: BoxDecoration(
// // //             color: Colors.white,
// // //             borderRadius: BorderRadius.circular(20),
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Colors.black.withOpacity(0.15),
// // //                 blurRadius: 30,
// // //                 offset: const Offset(0, 10),
// // //               ),
// // //             ],
// // //           ),
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               GestureDetector(
// // //                 onTap: widget.onImageTap,
// // //                 child: Image.asset(
// // //                   'assets/booking.png',
// // //                   width: 180,
// // //                   height: 180,
// // //                   fit: BoxFit.contain,
// // //                   errorBuilder: (context, error, stackTrace) => Container(
// // //                     width: 180,
// // //                     height: 180,
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.grey[100],
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     child: const Icon(
// // //                       Icons.hotel,
// // //                       size: 80,
// // //                       color: Colors.grey,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),

// // //               const SizedBox(height: 20),

// // //               Text.rich(
// // //                 TextSpan(
// // //                   children: [
// // //                     const TextSpan(
// // //                       text: 'Hostel Booking ',
// // //                       style: TextStyle(
// // //                         color: Color(0xFFE53935),
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 18,
// // //                       ),
// // //                     ),
// // //                     const TextSpan(
// // //                       text: 'Completed\nSuccessfully',
// // //                       style: TextStyle(
// // //                         color: Colors.black,
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 18,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 textAlign: TextAlign.center,
// // //               ),

// // //               const SizedBox(height: 24),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }




// // import 'dart:convert';
// // import 'package:brando_app/views/history/booking_history.dart';
// // import 'package:carousel_slider/carousel_slider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // // ─── Models ──────────────────────────────────────────────────────────────────




// // class SharingOption {
// //   final String shareType;
// //   final int acMonthlyPrice;
// //   final int acDailyPrice;
// //   final int nonAcMonthlyPrice;
// //   final int nonAcDailyPrice;

// //   SharingOption({
// //     required this.shareType,
// //     required this.acMonthlyPrice,
// //     required this.acDailyPrice,
// //     required this.nonAcMonthlyPrice,
// //     required this.nonAcDailyPrice,
// //   });

// //   factory SharingOption.fromJson(Map<String, dynamic> json) {
// //     return SharingOption(
// //       shareType: json['shareType'] ?? '',
// //       acMonthlyPrice: json['acMonthlyPrice'] ?? 0,
// //       acDailyPrice: json['acDailyPrice'] ?? 0,
// //       nonAcMonthlyPrice: json['nonAcMonthlyPrice'] ?? 0,
// //       nonAcDailyPrice: json['nonAcDailyPrice'] ?? 0,
// //     );
// //   }
// // }

// // // class SharingOption {
// // //   final String shareType;
// // //   final int monthlyPrice;
// // //   final int dailyPrice;

// // //   SharingOption({
// // //     required this.shareType,
// // //     required this.monthlyPrice,
// // //     required this.dailyPrice,
// // //   });

// // //   factory SharingOption.fromJson(Map<String, dynamic> json) {
// // //     return SharingOption(
// // //       shareType: json['shareType'] ?? '',
// // //       monthlyPrice: json['monthlyPrice'] ?? 0,
// // //       dailyPrice: json['dailyPrice'] ?? 0,
// // //     );
// // //   }
// // // }

// // class HostelModel {
// //   final String id;
// //   final String name;
// //   final String type; // "AC" or "NON-AC"
// //   final double rating;
// //   final String address;
// //   final int monthlyAdvance;
// //   final List<SharingOption> sharings;
// //   final List<String> images;

// //   HostelModel({
// //     required this.id,
// //     required this.name,
// //     required this.type,
// //     required this.rating,
// //     required this.address,
// //     required this.monthlyAdvance,
// //     required this.sharings,
// //     required this.images,
// //   });

// //   factory HostelModel.fromJson(Map<String, dynamic> json) {
// //     return HostelModel(
// //       id: json['_id'] ?? '',
// //       name: json['name'] ?? '',
// //       type: json['type'] ?? '',
// //       rating: (json['rating'] ?? 0).toDouble(),
// //       address: json['address'] ?? '',
// //       monthlyAdvance: json['monthlyAdvance'] ?? 0,
// //       sharings:
// //           (json['sharings'] as List<dynamic>?)
// //               ?.map((e) => SharingOption.fromJson(e))
// //               .toList() ??
// //           [],
// //       images: List<String>.from(json['images'] ?? []),
// //     );
// //   }

// //   bool get isAC => type.toUpperCase() == 'AC';
// // }

// // // ─── API Service ─────────────────────────────────────────────────────────────

// // class HostelApiService {
// //   static const String _baseUrl = 'http://31.97.206.144:2003/api/Admin';

// //   static Future<HostelModel> getHostelById(String hostelId) async {
// //     final uri = Uri.parse('$_baseUrl/getHostelById/$hostelId');
// //     final response = await http.get(uri);

// //     if (response.statusCode == 200) {
// //       final json = jsonDecode(response.body) as Map<String, dynamic>;
// //       if (json['success'] == true && json['hostel'] != null) {
// //         return HostelModel.fromJson(json['hostel']);
// //       }
// //       throw Exception('Invalid response format');
// //     } else {
// //       throw Exception('Failed to load hostel: ${response.statusCode}');
// //     }
// //   }
// // }

// // // ─── Detail Screen ────────────────────────────────────────────────────────────

// // class DetailScreen extends StatefulWidget {
// //   final String? hostelId;

// //   const DetailScreen({super.key, this.hostelId});

// //   @override
// //   State<DetailScreen> createState() => _DetailScreenState();
// // }

// // class _DetailScreenState extends State<DetailScreen>
// //     with SingleTickerProviderStateMixin {
// //   late TabController _tabController;

// //   bool _isAgreed = false;
// //   int _selectedDateIndex = 0;

// //   int _currentImageIndex = 0;

// //   // API state
// //   HostelModel? _hostel;
// //   bool _isLoading = true;
// //   String? _errorMessage;

// //   // ── Dynamic dates: today + next 6 days ──────────────────────────────────
// //   List<Map<String, dynamic>> get _dates {
// //     final now = DateTime.now();
// //     const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
// //     return List.generate(7, (i) {
// //       final day = now.add(Duration(days: i));
// //       return {
// //         'day': i == 0 ? 'Today' : dayNames[day.weekday % 7],
// //         'date': day.day,
// //       };
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //     _fetchHostel();
// //   }

// //   Future<void> _fetchHostel() async {
// //     try {
// //       setState(() {
// //         _isLoading = true;
// //         _errorMessage = null;
// //       });
// //       final hostel = await HostelApiService.getHostelById(
// //         widget.hostelId.toString(),
// //       );
// //       setState(() {
// //         _hostel = hostel;
// //         _isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _errorMessage = e.toString();
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   // Build price cards from API sharings
// //   // List<Map<String, dynamic>> get _currentPrices {
// //   //   if (_hostel == null) return [];
// //   //   return _hostel!.sharings.map((s) {
// //   //     final isMonthly = _tabController.index == 0;
// //   //     final price = isMonthly ? s.monthlyPrice : s.dailyPrice;
// //   //     return {
// //   //       'share': s.shareType.toUpperCase(),
// //   //       'price': '${_formatPrice(price)}/-',
// //   //     };
// //   //   }).toList();
// //   // }



// //   List<Map<String, dynamic>> get _currentPrices {
// //   if (_hostel == null) return [];
// //   final isMonthly = _tabController.index == 0;
// //   final isAC = _hostel!.isAC;

// //   return _hostel!.sharings.map((s) {
// //     int price;
// //     if (isMonthly) {
// //       price = isAC ? s.acMonthlyPrice : s.nonAcMonthlyPrice;
// //     } else {
// //       price = isAC ? s.acDailyPrice : s.nonAcDailyPrice;
// //     }
// //     return {
// //       'share': s.shareType.toUpperCase(),
// //       'price': '${_formatPrice(price)}/-',
// //     };
// //   }).toList();
// // }

// //   String _formatPrice(int price) {
// //     // Add comma for thousands: 5000 → 5,000
// //     if (price >= 1000) {
// //       final thousands = price ~/ 1000;
// //       final remainder = price % 1000;
// //       return remainder == 0
// //           ? '$thousands,000'
// //           : '$thousands,${remainder.toString().padLeft(3, '0')}';
// //     }
// //     return price.toString();
// //   }

// //   void _showBookingSuccessModal() {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       barrierColor: Colors.black54,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //           ),
// //           elevation: 0,
// //           backgroundColor: Colors.transparent,
// //           child: _BookingSuccessModal(
// //             onImageTap: () {
// //               Navigator.of(context).pop();
// //               Navigator.of(context).pushReplacement(
// //                 MaterialPageRoute(builder: (context) => const BookingHistory()),
// //               );
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // ─── Build ───────────────────────────────────────────────────────────────

// //   @override
// //   Widget build(BuildContext context) {
// //     print('hostel iddddddddddddddddddddd ${widget.hostelId}');
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // App Bar
// //             Padding(
// //               padding: const EdgeInsets.symmetric(
// //                 horizontal: 16.0,
// //                 vertical: 8,
// //               ),
// //               child: Row(
// //                 children: [
// //                   IconButton(
// //                     onPressed: () => Navigator.of(context).pop(),
// //                     icon: const Icon(Icons.arrow_back, color: Colors.black),
// //                   ),
// //                   Expanded(
// //                     child: Center(
// //                       child: Text.rich(
// //                         TextSpan(
// //                           children: [
// //                             TextSpan(
// //                               // Show hostel name in app bar once loaded
// //                               text: _hostel != null
// //                                   ? '${_hostel!.name} '
// //                                   : 'HIFI ',
// //                               style: const TextStyle(
// //                                 color: Color(0xFFE53935),
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 20,
// //                               ),
// //                             ),
// //                             if (_hostel == null)
// //                               const TextSpan(
// //                                 text: 'Hostels',
// //                                 style: TextStyle(
// //                                   color: Colors.black,
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 20,
// //                                 ),
// //                               ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 24),
// //                 ],
// //               ),
// //             ),

// //             // Body
// //             if (_isLoading)
// //               const Expanded(
// //                 child: Center(
// //                   child: CircularProgressIndicator(color: Color(0xFFE53935)),
// //                 ),
// //               )
// //             else if (_errorMessage != null)
// //               Expanded(
// //                 child: Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       const Icon(
// //                         Icons.error_outline,
// //                         color: Colors.red,
// //                         size: 48,
// //                       ),
// //                       const SizedBox(height: 12),
// //                       const Text(
// //                         'Failed to load hostel details.',
// //                         style: TextStyle(fontSize: 15, color: Colors.black87),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       TextButton.icon(
// //                         onPressed: _fetchHostel,
// //                         icon: const Icon(
// //                           Icons.refresh,
// //                           color: Color(0xFFE53935),
// //                         ),
// //                         label: const Text(
// //                           'Retry',
// //                           style: TextStyle(color: Color(0xFFE53935)),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               )
// //             else
// //               _buildContent(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildContent() {
// //     final hostel = _hostel!;
// //     final dates = _dates;
// //     final prices = _currentPrices;

// //     return Expanded(
// //       child: Column(
// //         children: [
// //           Expanded(
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // ── Hostel Image (from API) ─────────────────────────────
// //                   Stack(
// //                     children: [
// //                       // ── Hostel Image Carousel ───────────────────────────────────────
// //                       if (hostel.images.isNotEmpty)
// //                         Stack(
// //                           alignment: Alignment.bottomCenter,
// //                           children: [
// //                             CarouselSlider(
// //                               options: CarouselOptions(
// //                                 height: 220,
// //                                 viewportFraction: 1.0,
// //                                 enlargeCenterPage: false,
// //                                 autoPlay: hostel.images.length > 1,
// //                                 autoPlayInterval: const Duration(seconds: 3),
// //                                 autoPlayAnimationDuration: const Duration(
// //                                   milliseconds: 600,
// //                                 ),
// //                                 autoPlayCurve: Curves.fastOutSlowIn,
// //                                 onPageChanged: (index, reason) {
// //                                   setState(() => _currentImageIndex = index);
// //                                 },
// //                               ),
// //                               items: hostel.images.map((imageUrl) {
// //                                 return Image.network(
// //                                   imageUrl,
// //                                   width: double.infinity,
// //                                   height: 220,
// //                                   fit: BoxFit.cover,
// //                                   loadingBuilder: (context, child, progress) {
// //                                     if (progress == null) return child;
// //                                     return Container(
// //                                       width: double.infinity,
// //                                       height: 220,
// //                                       color: Colors.grey[200],
// //                                       child: const Center(
// //                                         child: CircularProgressIndicator(
// //                                           color: Color(0xFFE53935),
// //                                         ),
// //                                       ),
// //                                     );
// //                                   },
// //                                   errorBuilder: (context, error, stackTrace) =>
// //                                       _imagePlaceholder(),
// //                                 );
// //                               }).toList(),
// //                             ),

// //                             // ── Dot Indicators ─────────────────────────────────────────
// //                             if (hostel.images.length > 1)
// //                               Positioned(
// //                                 bottom: 10,
// //                                 child: Row(
// //                                   mainAxisAlignment: MainAxisAlignment.center,
// //                                   children: hostel.images.asMap().entries.map((
// //                                     entry,
// //                                   ) {
// //                                     final isActive =
// //                                         entry.key == _currentImageIndex;
// //                                     return AnimatedContainer(
// //                                       duration: const Duration(
// //                                         milliseconds: 300,
// //                                       ),
// //                                       width: isActive ? 20 : 8,
// //                                       height: 8,
// //                                       margin: const EdgeInsets.symmetric(
// //                                         horizontal: 3,
// //                                       ),
// //                                       decoration: BoxDecoration(
// //                                         color: isActive
// //                                             ? const Color(0xFFE53935)
// //                                             : Colors.white.withOpacity(0.7),
// //                                         borderRadius: BorderRadius.circular(4),
// //                                         boxShadow: [
// //                                           BoxShadow(
// //                                             color: Colors.black.withOpacity(
// //                                               0.2,
// //                                             ),
// //                                             blurRadius: 3,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                 ),
// //                               ),

// //                             // ── Image Counter Badge ─────────────────────────────────────
// //                             Positioned(
// //                               top: 10,
// //                               right: 10,
// //                               child: Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8,
// //                                   vertical: 4,
// //                                 ),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.black.withOpacity(0.5),
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                                 child: Text(
// //                                   '${_currentImageIndex + 1}/${hostel.images.length}',
// //                                   style: const TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 12,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         )
// //                       else
// //                         _imagePlaceholder(),

// //                       // hostel.images.isNotEmpty
// //                       //     ? Image.network(
// //                       //         hostel.images.first,
// //                       //         width: double.infinity,
// //                       //         height: 200,
// //                       //         fit: BoxFit.cover,
// //                       //         loadingBuilder: (context, child, progress) {
// //                       //           if (progress == null) return child;
// //                       //           return Container(
// //                       //             width: double.infinity,
// //                       //             height: 200,
// //                       //             color: Colors.grey[200],
// //                       //             child: const Center(
// //                       //               child: CircularProgressIndicator(
// //                       //                 color: Color(0xFFE53935),
// //                       //               ),
// //                       //             ),
// //                       //           );
// //                       //         },
// //                       //         errorBuilder: (context, error, stackTrace) =>
// //                       //             _imagePlaceholder(),
// //                       //       )
// //                       //     : _imagePlaceholder(),
// //                     ],
// //                   ),

// //                   // ── Location Row ────────────────────────────────────────
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 8,
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         const Icon(
// //                           Icons.location_on,
// //                           color: Color(0xFFE53935),
// //                           size: 18,
// //                         ),
// //                         Expanded(
// //                           child: Text(
// //                             hostel.address,
// //                             style: const TextStyle(
// //                               fontSize: 14,
// //                               color: Colors.black87,
// //                             ),
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                         const Icon(
// //                           Icons.keyboard_arrow_down,
// //                           color: Colors.black54,
// //                         ),
// //                         const SizedBox(width: 8),

// //                         // ── AC Badge (read-only, driven by API type) ──────
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 10,
// //                             vertical: 4,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: hostel.isAC
// //                                 ? const Color(0xFF1565C0)
// //                                 : Colors.grey[300],
// //                             borderRadius: BorderRadius.circular(20),
// //                           ),
// //                           child: Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               Icon(
// //                                 Icons.ac_unit,
// //                                 size: 16,
// //                                 color: hostel.isAC
// //                                     ? Colors.white
// //                                     : Colors.black54,
// //                               ),
// //                               const SizedBox(width: 4),
// //                               Text(
// //                                 'AC',
// //                                 style: TextStyle(
// //                                   fontSize: 13,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: hostel.isAC
// //                                       ? Colors.white
// //                                       : Colors.black54,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 4),
// //                               Container(
// //                                 width: 28,
// //                                 height: 16,
// //                                 decoration: BoxDecoration(
// //                                   color: hostel.isAC
// //                                       ? Colors.white24
// //                                       : Colors.black12,
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 child: Align(
// //                                   alignment: hostel.isAC
// //                                       ? Alignment.centerRight
// //                                       : Alignment.centerLeft,
// //                                   child: Container(
// //                                     width: 14,
// //                                     height: 14,
// //                                     margin: const EdgeInsets.symmetric(
// //                                       horizontal: 1,
// //                                     ),
// //                                     decoration: const BoxDecoration(
// //                                       color: Colors.white70,
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   // ── Rating Row ──────────────────────────────────────────
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     child: Row(
// //                       children: [
// //                         const Icon(Icons.star, color: Colors.amber, size: 18),
// //                         const SizedBox(width: 4),
// //                         Text(
// //                           hostel.rating.toStringAsFixed(1),
// //                           style: const TextStyle(
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w600,
// //                             color: Colors.black87,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   const SizedBox(height: 8),

// //                   // ── Tab Bar ─────────────────────────────────────────────
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     child: Container(
// //                       height: 42,
// //                       decoration: BoxDecoration(
// //                         color: Colors.grey[100],
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: TabBar(
// //                         controller: _tabController,
// //                         onTap: (_) => setState(() {}),
// //                         indicator: BoxDecoration(
// //                           color: const Color(0xFFE53935),
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         indicatorSize: TabBarIndicatorSize.tab,
// //                         labelColor: Colors.white,
// //                         unselectedLabelColor: Colors.black87,
// //                         labelStyle: const TextStyle(
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: 12,
// //                         ),
// //                         dividerColor: Colors.transparent,
// //                         tabs: [
// //                           Tab(
// //                             text:
// //                                 'Monthly Advance (${_formatPrice(hostel.monthlyAdvance)}/-)',
// //                           ),
// //                           const Tab(text: 'Daily'),
// //                         ],
// //                       ),
// //                     ),
// //                   ),

// //                   const SizedBox(height: 16),

// //                   // ── Prices Header ───────────────────────────────────────
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     child: Text.rich(
// //                       TextSpan(
// //                         children: [
// //                           TextSpan(
// //                             text: _tabController.index == 0
// //                                 ? 'Monthly Prices for '
// //                                 : 'Daily Prices for ',
// //                             style: const TextStyle(
// //                               fontSize: 15,
// //                               fontWeight: FontWeight.w600,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                           TextSpan(
// //                             text: hostel.isAC ? 'AC' : 'Non-AC',
// //                             style: const TextStyle(
// //                               fontSize: 15,
// //                               fontWeight: FontWeight.w600,
// //                               color: Color(0xFFE53935),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),

// //                   const SizedBox(height: 12),

// //                   // ── Price Grid ──────────────────────────────────────────
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     child: GridView.builder(
// //                       shrinkWrap: true,
// //                       physics: const NeverScrollableScrollPhysics(),
// //                       gridDelegate:
// //                           const SliverGridDelegateWithFixedCrossAxisCount(
// //                             crossAxisCount: 4,
// //                             childAspectRatio: 1.3,
// //                             crossAxisSpacing: 8,
// //                             mainAxisSpacing: 8,
// //                           ),
// //                       itemCount: prices.length,
// //                       itemBuilder: (context, index) {
// //                         return Container(
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFFE53935),
// //                             borderRadius: BorderRadius.circular(6),
// //                           ),
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Text(
// //                                 prices[index]['share'],
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 11,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 4),
// //                               Text(
// //                                 prices[index]['price'],
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 11,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),

// //                   const SizedBox(height: 20),

// //                   // ── Select Date Section ─────────────────────────────────
// //                   const Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 12),
// //                     child: Text(
// //                       'Select Date To Book a Hostel',
// //                       style: TextStyle(
// //                         fontSize: 15,
// //                         fontWeight: FontWeight.w600,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                   ),

// //                   const SizedBox(height: 12),

// //                   SizedBox(
// //                     height: 70,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// //                       itemCount: dates.length,
// //                       itemBuilder: (context, index) {
// //                         final isSelected = _selectedDateIndex == index;
// //                         final isToday = index == 0;
// //                         return GestureDetector(
// //                           onTap: () =>
// //                               setState(() => _selectedDateIndex = index),
// //                           child: Container(
// //                             width: isToday ? 64 : 52,
// //                             margin: const EdgeInsets.only(right: 8),
// //                             decoration: BoxDecoration(
// //                               color: isSelected
// //                                   ? const Color(0xFFFF0000)
// //                                   : Colors.white,
// //                               borderRadius: BorderRadius.circular(8),
// //                               border: Border.all(
// //                                 color: isSelected
// //                                     ? const Color(0xFFFF0000)
// //                                     : Colors.grey[300]!,
// //                               ),
// //                             ),
// //                             child: Column(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Text(
// //                                   dates[index]['day'],
// //                                   style: TextStyle(
// //                                     color: isSelected
// //                                         ? Colors.white
// //                                         : isToday
// //                                         ? const Color(0xFFE53935)
// //                                         : Colors.black54,
// //                                     fontSize: isToday ? 11 : 12,
// //                                     fontWeight: isToday
// //                                         ? FontWeight.bold
// //                                         : FontWeight.normal,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 4),
// //                                 Text(
// //                                   '${dates[index]['date']}',
// //                                   style: TextStyle(
// //                                     color: isSelected
// //                                         ? Colors.white
// //                                         : Colors.black87,
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 18,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),

// //                   const SizedBox(height: 20),

// //                   // ── Terms and Privacy ───────────────────────────────────
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Checkbox(
// //                           value: _isAgreed,
// //                           onChanged: (value) =>
// //                               setState(() => _isAgreed = value ?? false),
// //                           activeColor: const Color(0xFFFF0000),
// //                           materialTapTargetSize:
// //                               MaterialTapTargetSize.shrinkWrap,
// //                           visualDensity: VisualDensity.compact,
// //                         ),
// //                         const SizedBox(width: 4),
// //                         Expanded(
// //                           child: Text.rich(
// //                             TextSpan(
// //                               children: const [
// //                                 TextSpan(
// //                                   text: 'By signing up, you agree to our ',
// //                                   style: TextStyle(
// //                                     fontSize: 12,
// //                                     color: Colors.black87,
// //                                   ),
// //                                 ),
// //                                 TextSpan(
// //                                   text: 'Terms of Use',
// //                                   style: TextStyle(
// //                                     fontSize: 12,
// //                                     color: Color(0xFFFF0000),
// //                                     decoration: TextDecoration.underline,
// //                                   ),
// //                                 ),
// //                                 TextSpan(
// //                                   text: '\nand ',
// //                                   style: TextStyle(
// //                                     fontSize: 12,
// //                                     color: Colors.black87,
// //                                   ),
// //                                 ),
// //                                 TextSpan(
// //                                   text: 'Privacy Policy',
// //                                   style: TextStyle(
// //                                     fontSize: 12,
// //                                     color: Color(0xFFFF0000),
// //                                     decoration: TextDecoration.underline,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   const SizedBox(height: 16),
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // ── Pay After Join Button ─────────────────────────────────────
// //           Padding(
// //             padding: const EdgeInsets.all(12),
// //             child: SizedBox(
// //               width: double.infinity,
// //               height: 50,
// //               child: ElevatedButton(
// //                 onPressed: _isAgreed ? _showBookingSuccessModal : null,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFFFF0000),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   elevation: 2,
// //                 ),
// //                 child: const Text(
// //                   'Pay After Join',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _imagePlaceholder() {
// //     return Container(
// //       width: double.infinity,
// //       height: 200,
// //       color: Colors.grey[200],
// //       child: const Icon(Icons.image, size: 60, color: Colors.grey),
// //     );
// //   }
// // }

// // // ─── Booking Success Modal ────────────────────────────────────────────────────

// // class _BookingSuccessModal extends StatefulWidget {
// //   final VoidCallback onImageTap;

// //   const _BookingSuccessModal({required this.onImageTap});

// //   @override
// //   State<_BookingSuccessModal> createState() => _BookingSuccessModalState();
// // }

// // class _BookingSuccessModalState extends State<_BookingSuccessModal>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animController;
// //   late Animation<double> _scaleAnim;
// //   late Animation<double> _fadeAnim;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 400),
// //     );
// //     _scaleAnim = CurvedAnimation(
// //       parent: _animController,
// //       curve: Curves.easeOutBack,
// //     );
// //     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
// //     _animController.forward();
// //   }

// //   @override
// //   void dispose() {
// //     _animController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return FadeTransition(
// //       opacity: _fadeAnim,
// //       child: ScaleTransition(
// //         scale: _scaleAnim,
// //         child: Container(
// //           margin: const EdgeInsets.symmetric(horizontal: 20),
// //           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.15),
// //                 blurRadius: 30,
// //                 offset: const Offset(0, 10),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               GestureDetector(
// //                 onTap: widget.onImageTap,
// //                 child: Image.asset(
// //                   'assets/booking.png',
// //                   width: 180,
// //                   height: 180,
// //                   fit: BoxFit.contain,
// //                   errorBuilder: (context, error, stackTrace) => Container(
// //                     width: 180,
// //                     height: 180,
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey[100],
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: const Icon(
// //                       Icons.hotel,
// //                       size: 80,
// //                       color: Colors.grey,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Text.rich(
// //                 TextSpan(
// //                   children: const [
// //                     TextSpan(
// //                       text: 'Hostel Booking ',
// //                       style: TextStyle(
// //                         color: Color(0xFFE53935),
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 18,
// //                       ),
// //                     ),
// //                     TextSpan(
// //                       text: 'Completed\nSuccessfully',
// //                       style: TextStyle(
// //                         color: Colors.black,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 18,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 textAlign: TextAlign.center,
// //               ),
// //               const SizedBox(height: 24),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
























// import 'dart:convert';
// import 'package:brando_app/views/history/booking_history.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// // ─── Models ──────────────────────────────────────────────────────────────────

// class SharingOption {
//   final String shareType;
//   final int acMonthlyPrice;
//   final int acDailyPrice;
//   final int nonAcMonthlyPrice;
//   final int nonAcDailyPrice;

//   SharingOption({
//     required this.shareType,
//     required this.acMonthlyPrice,
//     required this.acDailyPrice,
//     required this.nonAcMonthlyPrice,
//     required this.nonAcDailyPrice,
//   });

//   factory SharingOption.fromJson(Map<String, dynamic> json) {
//     return SharingOption(
//       shareType: json['shareType'] ?? '',
//       acMonthlyPrice: json['acMonthlyPrice'] ?? 0,
//       acDailyPrice: json['acDailyPrice'] ?? 0,
//       nonAcMonthlyPrice: json['nonAcMonthlyPrice'] ?? 0,
//       nonAcDailyPrice: json['nonAcDailyPrice'] ?? 0,
//     );
//   }
// }

// class HostelModel {
//   final String id;
//   final String name;
//   final String type; // "AC" or "NON-AC"
//   final double rating;
//   final String address;
//   final int monthlyAdvance;
//   final List<SharingOption> sharings;
//   final List<String> images;

//   HostelModel({
//     required this.id,
//     required this.name,
//     required this.type,
//     required this.rating,
//     required this.address,
//     required this.monthlyAdvance,
//     required this.sharings,
//     required this.images,
//   });

//   factory HostelModel.fromJson(Map<String, dynamic> json) {
//     return HostelModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       type: json['type'] ?? '',
//       rating: (json['rating'] ?? 0).toDouble(),
//       address: json['address'] ?? '',
//       monthlyAdvance: json['monthlyAdvance'] ?? 0,
//       sharings:
//           (json['sharings'] as List<dynamic>?)
//               ?.map((e) => SharingOption.fromJson(e))
//               .toList() ??
//           [],
//       images: List<String>.from(json['images'] ?? []),
//     );
//   }

//   bool get isAC => type.toUpperCase() == 'AC';
// }

// // ─── API Service ─────────────────────────────────────────────────────────────

// class HostelApiService {
//   static const String _baseUrl = 'http://31.97.206.144:2003/api/Admin';

//   static Future<HostelModel> getHostelById(String hostelId) async {
//     final uri = Uri.parse('$_baseUrl/getHostelById/$hostelId');
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body) as Map<String, dynamic>;
//       if (json['success'] == true && json['hostel'] != null) {
//         return HostelModel.fromJson(json['hostel']);
//       }
//       throw Exception('Invalid response format');
//     } else {
//       throw Exception('Failed to load hostel: ${response.statusCode}');
//     }
//   }
// }

// // ─── Detail Screen ────────────────────────────────────────────────────────────

// class DetailScreen extends StatefulWidget {
//   final String? hostelId;

//   const DetailScreen({super.key, this.hostelId});

//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }

// class _DetailScreenState extends State<DetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   bool _isAgreed = false;
//   int _selectedDateIndex = 0;
//   int _currentImageIndex = 0;

//   // NEW: Track selected sharing card index & AC toggle state
//   int? _selectedPriceIndex;
//   bool _isACToggled = true; // toggleable AC state

//   // API state
//   HostelModel? _hostel;
//   bool _isLoading = true;
//   String? _errorMessage;

//   // ── Dynamic dates: today + next 6 days ──────────────────────────────────
//   List<Map<String, dynamic>> get _dates {
//     final now = DateTime.now();
//     const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//     return List.generate(7, (i) {
//       final day = now.add(Duration(days: i));
//       return {
//         'day': i == 0 ? 'Today' : dayNames[day.weekday % 7],
//         'date': day.day,
//       };
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _fetchHostel();
//   }

//   Future<void> _fetchHostel() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });
//       final hostel = await HostelApiService.getHostelById(
//         widget.hostelId.toString(),
//       );
//       setState(() {
//         _hostel = hostel;
//         _isACToggled = hostel.isAC; // initialize toggle from API type
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> get _currentPrices {
//     if (_hostel == null) return [];
//     final isMonthly = _tabController.index == 0;

//     return _hostel!.sharings.map((s) {
//       int price;
//       if (isMonthly) {
//         price = _isACToggled ? s.acMonthlyPrice : s.nonAcMonthlyPrice;
//       } else {
//         price = _isACToggled ? s.acDailyPrice : s.nonAcDailyPrice;
//       }
//       return {
//         'share': s.shareType.toUpperCase(),
//         'price': price,
//         'priceFormatted': '${_formatPrice(price)}/-',
//       };
//     }).toList();
//   }

//   // Returns the currently selected price (raw int), or null if nothing selected
//   int? get _selectedPrice {
//     if (_selectedPriceIndex == null) return null;
//     final prices = _currentPrices;
//     if (_selectedPriceIndex! >= prices.length) return null;
//     return prices[_selectedPriceIndex!]['price'] as int;
//   }

//   String _formatPrice(int price) {
//     if (price >= 1000) {
//       final thousands = price ~/ 1000;
//       final remainder = price % 1000;
//       return remainder == 0
//           ? '$thousands,000'
//           : '$thousands,${remainder.toString().padLeft(3, '0')}';
//     }
//     return price.toString();
//   }

//   void _showBookingSuccessModal() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.black54,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: _BookingSuccessModal(
//             onImageTap: () {
//               Navigator.of(context).pop();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => const BookingHistory()),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   // ─── Build ───────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // App Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 8,
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: const Icon(Icons.arrow_back, color: Colors.black),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: _hostel != null
//                                   ? '${_hostel!.name} '
//                                   : 'HIFI ',
//                               style: const TextStyle(
//                                 color: Color(0xFFE53935),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             if (_hostel == null)
//                               const TextSpan(
//                                 text: 'Hostels',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 24),
//                 ],
//               ),
//             ),

//             // Body
//             if (_isLoading)
//               const Expanded(
//                 child: Center(
//                   child: CircularProgressIndicator(color: Color(0xFFE53935)),
//                 ),
//               )
//             else if (_errorMessage != null)
//               Expanded(
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.error_outline,
//                         color: Colors.red,
//                         size: 48,
//                       ),
//                       const SizedBox(height: 12),
//                       const Text(
//                         'Failed to load hostel details.',
//                         style: TextStyle(fontSize: 15, color: Colors.black87),
//                       ),
//                       const SizedBox(height: 8),
//                       TextButton.icon(
//                         onPressed: _fetchHostel,
//                         icon: const Icon(
//                           Icons.refresh,
//                           color: Color(0xFFE53935),
//                         ),
//                         label: const Text(
//                           'Retry',
//                           style: TextStyle(color: Color(0xFFE53935)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             else
//               _buildContent(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     final hostel = _hostel!;
//     final dates = _dates;
//     final prices = _currentPrices;

//     return Expanded(
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── Hostel Image Carousel ───────────────────────────────
//                   Stack(
//                     children: [
//                       if (hostel.images.isNotEmpty)
//                         Stack(
//                           alignment: Alignment.bottomCenter,
//                           children: [
//                             CarouselSlider(
//                               options: CarouselOptions(
//                                 height: 220,
//                                 viewportFraction: 1.0,
//                                 enlargeCenterPage: false,
//                                 autoPlay: hostel.images.length > 1,
//                                 autoPlayInterval: const Duration(seconds: 3),
//                                 autoPlayAnimationDuration: const Duration(
//                                   milliseconds: 600,
//                                 ),
//                                 autoPlayCurve: Curves.fastOutSlowIn,
//                                 onPageChanged: (index, reason) {
//                                   setState(() => _currentImageIndex = index);
//                                 },
//                               ),
//                               items: hostel.images.map((imageUrl) {
//                                 return Image.network(
//                                   imageUrl,
//                                   width: double.infinity,
//                                   height: 220,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder: (context, child, progress) {
//                                     if (progress == null) return child;
//                                     return Container(
//                                       width: double.infinity,
//                                       height: 220,
//                                       color: Colors.grey[200],
//                                       child: const Center(
//                                         child: CircularProgressIndicator(
//                                           color: Color(0xFFE53935),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       _imagePlaceholder(),
//                                 );
//                               }).toList(),
//                             ),

//                             // Dot Indicators
//                             if (hostel.images.length > 1)
//                               Positioned(
//                                 bottom: 10,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: hostel.images.asMap().entries.map((
//                                     entry,
//                                   ) {
//                                     final isActive =
//                                         entry.key == _currentImageIndex;
//                                     return AnimatedContainer(
//                                       duration: const Duration(
//                                         milliseconds: 300,
//                                       ),
//                                       width: isActive ? 20 : 8,
//                                       height: 8,
//                                       margin: const EdgeInsets.symmetric(
//                                         horizontal: 3,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: isActive
//                                             ? const Color(0xFFE53935)
//                                             : Colors.white.withOpacity(0.7),
//                                         borderRadius: BorderRadius.circular(4),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(
//                                               0.2,
//                                             ),
//                                             blurRadius: 3,
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),

//                             // Image Counter Badge
//                             Positioned(
//                               top: 10,
//                               right: 10,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   '${_currentImageIndex + 1}/${hostel.images.length}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       else
//                         _imagePlaceholder(),
//                     ],
//                   ),

//                   // ── Location Row ────────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on,
//                           color: Color(0xFFE53935),
//                           size: 18,
//                         ),
//                         Expanded(
//                           child: Text(
//                             hostel.address,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Icon(
//                           Icons.keyboard_arrow_down,
//                           color: Colors.black54,
//                         ),
//                         const SizedBox(width: 8),

//                         // ── AC Toggle (now interactive) ───────────────────
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _isACToggled = !_isACToggled;
//                               // Reset selected price when toggling AC
//                               _selectedPriceIndex = null;
//                             });
//                           },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 250),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _isACToggled
//                                   ? const Color(0xFF1565C0)
//                                   : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.ac_unit,
//                                   size: 16,
//                                   color: _isACToggled
//                                       ? Colors.white
//                                       : Colors.black54,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'AC',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.bold,
//                                     color: _isACToggled
//                                         ? Colors.white
//                                         : Colors.black54,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 6),
//                                 // Animated toggle pill
//                                 AnimatedContainer(
//                                   duration: const Duration(milliseconds: 250),
//                                   width: 36,
//                                   height: 20,
//                                   decoration: BoxDecoration(
//                                     color: _isACToggled
//                                         ? Colors.white24
//                                         : Colors.black12,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       AnimatedPositioned(
//                                         duration:
//                                             const Duration(milliseconds: 250),
//                                         curve: Curves.easeInOut,
//                                         left: _isACToggled ? 16 : 2,
//                                         top: 3,
//                                         child: Container(
//                                           width: 14,
//                                           height: 14,
//                                           decoration: const BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // ── Rating Row ──────────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 18),
//                         const SizedBox(width: 4),
//                         Text(
//                           hostel.rating.toStringAsFixed(1),
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   // ── Tab Bar ─────────────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Container(
//                       height: 42,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TabBar(
//                         controller: _tabController,
//                         onTap: (_) => setState(() {
//                           // Reset selection when switching monthly/daily
//                           _selectedPriceIndex = null;
//                         }),
//                         indicator: BoxDecoration(
//                           color: const Color(0xFFE53935),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         labelColor: Colors.white,
//                         unselectedLabelColor: Colors.black87,
//                         labelStyle: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 12,
//                         ),
//                         dividerColor: Colors.transparent,
//                         tabs: [
//                           Tab(
//                             text:
//                                 'Monthly Advance (${_formatPrice(hostel.monthlyAdvance)}/-)',
//                           ),
//                           const Tab(text: 'Daily'),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // ── Prices Header ───────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(
//                             text: _tabController.index == 0
//                                 ? 'Monthly Prices for '
//                                 : 'Daily Prices for ',
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                           TextSpan(
//                             text: _isACToggled ? 'AC' : 'Non-AC',
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFFE53935),
//                             ),
//                           ),
//                           const TextSpan(
//                             text: '  (tap a card to select)',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.black45,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // ── Price Grid (Selectable) ─────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 4,
//                             childAspectRatio: 1.3,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                           ),
//                       itemCount: prices.length,
//                       itemBuilder: (context, index) {
//                         final isSelected = _selectedPriceIndex == index;
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               // Toggle off if already selected
//                               _selectedPriceIndex =
//                                   isSelected ? null : index;
//                             });
//                           },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? const Color(0xFFB71C1C)
//                                   : const Color(0xFFE53935),
//                               borderRadius: BorderRadius.circular(6),
//                               border: isSelected
//                                   ? Border.all(
//                                       color: Colors.white,
//                                       width: 2,
//                                     )
//                                   : null,
//                               boxShadow: isSelected
//                                   ? [
//                                       BoxShadow(
//                                         color: const Color(
//                                           0xFFE53935,
//                                         ).withOpacity(0.5),
//                                         blurRadius: 8,
//                                         offset: const Offset(0, 3),
//                                       ),
//                                     ]
//                                   : [],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 if (isSelected)
//                                   const Icon(
//                                     Icons.check_circle,
//                                     color: Colors.white,
//                                     size: 14,
//                                   ),
//                                 if (isSelected) const SizedBox(height: 2),
//                                 Text(
//                                   prices[index]['share'],
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   prices[index]['priceFormatted'],
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // ── Select Date Section ─────────────────────────────────
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     child: Text(
//                       'Select Date To Book a Hostel',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   SizedBox(
//                     height: 70,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       itemCount: dates.length,
//                       itemBuilder: (context, index) {
//                         final isSelected = _selectedDateIndex == index;
//                         final isToday = index == 0;
//                         return GestureDetector(
//                           onTap: () =>
//                               setState(() => _selectedDateIndex = index),
//                           child: Container(
//                             width: isToday ? 64 : 52,
//                             margin: const EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? const Color(0xFFFF0000)
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                 color: isSelected
//                                     ? const Color(0xFFFF0000)
//                                     : Colors.grey[300]!,
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   dates[index]['day'],
//                                   style: TextStyle(
//                                     color: isSelected
//                                         ? Colors.white
//                                         : isToday
//                                         ? const Color(0xFFE53935)
//                                         : Colors.black54,
//                                     fontSize: isToday ? 11 : 12,
//                                     fontWeight: isToday
//                                         ? FontWeight.bold
//                                         : FontWeight.normal,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   '${dates[index]['date']}',
//                                   style: TextStyle(
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black87,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // ── Terms and Privacy ───────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                           value: _isAgreed,
//                           onChanged: (value) =>
//                               setState(() => _isAgreed = value ?? false),
//                           activeColor: const Color(0xFFFF0000),
//                           materialTapTargetSize:
//                               MaterialTapTargetSize.shrinkWrap,
//                           visualDensity: VisualDensity.compact,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text.rich(
//                             TextSpan(
//                               children: const [
//                                 TextSpan(
//                                   text: 'By signing up, you agree to our ',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: 'Terms of Use',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Color(0xFFFF0000),
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: '\nand ',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: 'Privacy Policy',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Color(0xFFFF0000),
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),

//           // ── Pay After Join Button (dynamic price) ─────────────────────
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: (_isAgreed && _selectedPriceIndex != null)
//                     ? _showBookingSuccessModal
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFF0000),
//                   disabledBackgroundColor: Colors.grey[300],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   elevation: 2,
//                 ),
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 200),
//                   child: Text(
//                     _selectedPrice != null
//                         ? 'Pay After Join  ₹${_formatPrice(_selectedPrice!)}/-'
//                         : 'Pay After Join',
//                     key: ValueKey(_selectedPrice),
//                     style: TextStyle(
//                       color: (_isAgreed && _selectedPriceIndex != null)
//                           ? Colors.white
//                           : Colors.black45,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _imagePlaceholder() {
//     return Container(
//       width: double.infinity,
//       height: 200,
//       color: Colors.grey[200],
//       child: const Icon(Icons.image, size: 60, color: Colors.grey),
//     );
//   }
// }

// // ─── Booking Success Modal ────────────────────────────────────────────────────

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





















import 'dart:convert';
import 'package:brando_app/views/history/booking_history.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class SharingOption {
  final String shareType;
  final int acMonthlyPrice;
  final int acDailyPrice;
  final int nonAcMonthlyPrice;
  final int nonAcDailyPrice;

  SharingOption({
    required this.shareType,
    required this.acMonthlyPrice,
    required this.acDailyPrice,
    required this.nonAcMonthlyPrice,
    required this.nonAcDailyPrice,
  });

  factory SharingOption.fromJson(Map<String, dynamic> json) {
    return SharingOption(
      shareType: json['shareType'] ?? '',
      acMonthlyPrice: json['acMonthlyPrice'] ?? 0,
      acDailyPrice: json['acDailyPrice'] ?? 0,
      nonAcMonthlyPrice: json['nonAcMonthlyPrice'] ?? 0,
      nonAcDailyPrice: json['nonAcDailyPrice'] ?? 0,
    );
  }
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
    return HostelModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      monthlyAdvance: json['monthlyAdvance'] ?? 0,
      sharings:
          (json['sharings'] as List<dynamic>?)
              ?.map((e) => SharingOption.fromJson(e))
              .toList() ??
          [],
      images: List<String>.from(json['images'] ?? []),
    );
  }

  bool get isAC => type.toUpperCase() == 'AC';
}

// ─── API Service ─────────────────────────────────────────────────────────────

class HostelApiService {
  static const String _baseUrl = 'http://31.97.206.144:2003/api/Admin';

  static Future<HostelModel> getHostelById(String hostelId) async {
    final uri = Uri.parse('$_baseUrl/getHostelById/$hostelId');
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
  late Razorpay _razorpay;

  bool _isAgreed = false;
  int _selectedDateIndex = 0;
  int _currentImageIndex = 0;

  int? _selectedPriceIndex;
  bool _isACToggled = true;
  bool _isPaymentProcessing = false;

  // API state
  HostelModel? _hostel;
  bool _isLoading = true;
  String? _errorMessage;

  // ── Dynamic dates: today + next 6 days ──────────────────────────────────
  List<Map<String, dynamic>> get _dates {
    final now = DateTime.now();
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return List.generate(7, (i) {
      final day = now.add(Duration(days: i));
      return {
        'day': i == 0 ? 'Today' : dayNames[day.weekday % 7],
        'date': day.day,
      };
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initRazorpay();
    _fetchHostel();
  }

  // ─── Razorpay Setup ───────────────────────────────────────────────────────

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() => _isPaymentProcessing = false);

    debugPrint('Transaaaaaaaactionnnnnnnnnnnnnnnnn iddddddddddddddddddd: ${response.paymentId}');
    debugPrint('Order ID: ${response.orderId}');
    debugPrint('Signature: ${response.signature}');

    _showBookingSuccessModal();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _isPaymentProcessing = false);

    debugPrint('Payment Error [${response.code}]: ${response.message}');

    final errorMsg = response.code == Razorpay.PAYMENT_CANCELLED
        ? 'Payment cancelled.'
        : 'Payment failed: ${response.message ?? 'Unknown error'}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMsg),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => _isPaymentProcessing = false);
    debugPrint('External Wallet: ${response.walletName}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  void _openRazorpayCheckout() {
    if (_selectedPrice == null || _hostel == null) return;

    setState(() => _isPaymentProcessing = true);

    // Razorpay expects amount in paise (1 INR = 100 paise)
    final amountInPaise = _selectedPrice! * 100;

    final selectedDate = _dates[_selectedDateIndex];
    final shareType = _currentPrices[_selectedPriceIndex!]['share'];
    final bookingType = _tabController.index == 0 ? 'Monthly' : 'Daily';
    final acType = _isACToggled ? 'AC' : 'Non-AC';

    var options = {
      'key': 'rzp_test_BxtRNvflG06PTV', 
      'amount': amountInPaise,
      'currency': 'INR',
      'name': _hostel!.name,
      'description':
          '$shareType • $bookingType • $acType • ${selectedDate['day']} ${selectedDate['date']}',
      'image': _hostel!.images.isNotEmpty ? _hostel!.images.first : '',
      // 'order_id': 'order_xxxx', // Optional: Pass Razorpay Order ID from backend
      'prefill': {
        'name': '',    // Pre-fill user name if available
        'email': '',   // Pre-fill user email if available
        'contact': '', // Pre-fill user phone if available
      },
      'notes': {
        'hostel_id': _hostel!.id,
        'hostel_name': _hostel!.name,
        'share_type': shareType,
        'booking_type': bookingType,
        'ac_type': acType,
        'booking_date': '${selectedDate['day']} ${selectedDate['date']}',
      },
      'theme': {
        'color': '#E53935',
      },
      'retry': {
        'enabled': true,
        'max_count': 3,
      },
      'send_sms_hash': true,
      'external': {
        'wallets': ['paytm', 'phonepe'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      setState(() => _isPaymentProcessing = false);
      debugPrint('Razorpay open error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open payment: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  // ─── Fetch & State ────────────────────────────────────────────────────────

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
        _isACToggled = hostel.isAC;
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
    _razorpay.clear(); // Always clear Razorpay listeners
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentPrices {
    if (_hostel == null) return [];
    final isMonthly = _tabController.index == 0;

    return _hostel!.sharings.map((s) {
      int price;
      if (isMonthly) {
        price = _isACToggled ? s.acMonthlyPrice : s.nonAcMonthlyPrice;
      } else {
        price = _isACToggled ? s.acDailyPrice : s.nonAcDailyPrice;
      }
      return {
        'share': s.shareType.toUpperCase(),
        'price': price,
        'priceFormatted': '${_formatPrice(price)}/-',
      };
    }).toList();
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
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Failed to load hostel details.',
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

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hostel Image Carousel ───────────────────────────────
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
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration: const Duration(
                                  milliseconds: 600,
                                ),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                onPageChanged: (index, reason) {
                                  setState(() => _currentImageIndex = index);
                                },
                              ),
                              items: hostel.images.map((imageUrl) {
                                return Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      width: double.infinity,
                                      height: 220,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFE53935),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      _imagePlaceholder(),
                                );
                              }).toList(),
                            ),

                            // Dot Indicators
                            if (hostel.images.length > 1)
                              Positioned(
                                bottom: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: hostel.images.asMap().entries.map((
                                    entry,
                                  ) {
                                    final isActive =
                                        entry.key == _currentImageIndex;
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: isActive ? 20 : 8,
                                      height: 8,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? const Color(0xFFE53935)
                                            : Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
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

                  // ── Location Row ────────────────────────────────────────
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

                        // ── AC Toggle ─────────────────────────────────────
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
                                  duration: const Duration(milliseconds: 250),
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
                                        duration:
                                            const Duration(milliseconds: 250),
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

                  // ── Rating Row ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
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

                  // ── Tab Bar ─────────────────────────────────────────────
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
                        onTap: (_) => setState(() {
                          _selectedPriceIndex = null;
                        }),
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

                  // ── Prices Header ───────────────────────────────────────
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

                  // ── Price Grid ──────────────────────────────────────────
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
                          onTap: () {
                            setState(() {
                              _selectedPriceIndex =
                                  isSelected ? null : index;
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

                  // ── Select Date Section ─────────────────────────────────
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

                  // ── Terms and Privacy ───────────────────────────────────
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
                              children: const [
                                TextSpan(
                                  text: 'By signing up, you agree to our ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Terms of Use',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF0000),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: '\nand ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF0000),
                                    decoration: TextDecoration.underline,
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

          // ── Pay After Join Button ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_isAgreed &&
                        _selectedPriceIndex != null &&
                        !_isPaymentProcessing)
                    ? _openRazorpayCheckout
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0000),
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: _isPaymentProcessing
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
                              ? 'Pay After Join  ₹${_formatPrice(_selectedPrice!)}/-'
                              : 'Pay After Join',
                          key: ValueKey(_selectedPrice),
                          style: TextStyle(
                            color: (_isAgreed && _selectedPriceIndex != null)
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

class _BookingSuccessModal extends StatefulWidget {
  final VoidCallback onImageTap;

  const _BookingSuccessModal({required this.onImageTap});

  @override
  State<_BookingSuccessModal> createState() => _BookingSuccessModalState();
}

class _BookingSuccessModalState extends State<_BookingSuccessModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: widget.onImageTap,
                child: Image.asset(
                  'assets/booking.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.hotel,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: const [
                    TextSpan(
                      text: 'Hostel Booking ',
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: 'Completed\nSuccessfully',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}