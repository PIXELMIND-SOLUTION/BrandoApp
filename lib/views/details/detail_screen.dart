// import 'package:brando_app/views/history/booking_history.dart';
// import 'package:flutter/material.dart';

// class DetailScreen extends StatefulWidget {
//   const DetailScreen({super.key});

//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }

// class _DetailScreenState extends State<DetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isAC = false;

//   bool _isAgreed = false;
//   int _selectedDateIndex = 0;

//   final List<Map<String, dynamic>> _dates = [
//     {'day': 'Sun', 'date': 13},
//     {'day': 'Mon', 'date': 14},
//     {'day': 'Tue', 'date': 15},
//     {'day': 'Wed', 'date': 16},
//     {'day': 'Thu', 'date': 17},
//     {'day': 'Fri', 'date': 18},
//     {'day': 'Sat', 'date': 19},
//   ];

//   final List<Map<String, dynamic>> _monthlyNonAcPrices = [
//     {'share': '1 SHARE', 'price': '5,000/-'},
//     {'share': '2 SHARE', 'price': '5,000/-'},
//     {'share': '3 SHARE', 'price': '5,000/-'},
//     {'share': '4 SHARE', 'price': '5,000/-'},
//     {'share': '1 SHARE', 'price': '5,000/-'},
//     {'share': '2 SHARE', 'price': '5,000/-'},
//   ];

//   final List<Map<String, dynamic>> _monthlyAcPrices = [
//     {'share': '1 SHARE', 'price': '7,000/-'},
//     {'share': '2 SHARE', 'price': '6,500/-'},
//     {'share': '3 SHARE', 'price': '6,000/-'},
//     {'share': '4 SHARE', 'price': '5,500/-'},
//     {'share': '1 SHARE', 'price': '7,000/-'},
//     {'share': '2 SHARE', 'price': '6,500/-'},
//   ];

//   final List<Map<String, dynamic>> _dailyPrices = [
//     {'share': '1 SHARE', 'price': '500/-'},
//     {'share': '2 SHARE', 'price': '450/-'},
//     {'share': '3 SHARE', 'price': '400/-'},
//     {'share': '4 SHARE', 'price': '350/-'},
//     {'share': '1 SHARE', 'price': '500/-'},
//     {'share': '2 SHARE', 'price': '450/-'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
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
//               Navigator.of(context).pop(); // close dialog
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => const BookingHistory()),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prices = _tabController.index == 0
//         ? (_isAC ? _monthlyAcPrices : _monthlyNonAcPrices)
//         : _dailyPrices;

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
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     icon: const Icon(Icons.arrow_back, color: Colors.black),
//                   ),
//                   const Expanded(
//                     child: Center(
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'HIFI ',
//                               style: TextStyle(
//                                 color: Color(0xFFE53935),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'Hostels',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 24),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Hostel Image
//                     Stack(
//                       children: [
//                         ClipRRect(
//                           child: Image.asset(
//                             'assets/detailimage.png',
//                             width: double.infinity,
//                             height: 200,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Container(
//                                   width: double.infinity,
//                                   height: 200,
//                                   color: Colors.grey[200],
//                                   child: const Icon(
//                                     Icons.image,
//                                     size: 60,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     // Location Row
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             color: Color(0xFFE53935),
//                             size: 18,
//                           ),
//                           const Expanded(
//                             child: Text(
//                               'Kphb Hyderabad Kukatpally ...',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Colors.black54,
//                           ),
//                           const SizedBox(width: 8),
//                           // AC Toggle
//                           GestureDetector(
//                             onTap: () => setState(() => _isAC = !_isAC),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: _isAC
//                                     ? const Color(0xFF1565C0)
//                                     : Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.ac_unit,
//                                     size: 16,
//                                     color: _isAC
//                                         ? Colors.white
//                                         : Colors.black54,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     _isAC ? 'AC' : 'AC',
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                       color: _isAC
//                                           ? Colors.white
//                                           : Colors.black54,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Container(
//                                     width: 28,
//                                     height: 16,
//                                     decoration: BoxDecoration(
//                                       color: _isAC
//                                           ? Colors.white24
//                                           : Colors.black12,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Align(
//                                       alignment: _isAC
//                                           ? Alignment.centerRight
//                                           : Alignment.centerLeft,
//                                       child: Container(
//                                         width: 14,
//                                         height: 14,
//                                         margin: const EdgeInsets.symmetric(
//                                           horizontal: 1,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: _isAC
//                                               ? Colors.white
//                                               : Colors.white70,
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Tab Bar
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Container(
//                         height: 42,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: TabBar(
//                           controller: _tabController,
//                           onTap: (_) => setState(() {}),
//                           indicator: BoxDecoration(
//                             color: const Color(0xFFE53935),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           indicatorSize: TabBarIndicatorSize.tab,
//                           labelColor: Colors.white,
//                           unselectedLabelColor: Colors.black87,
//                           labelStyle: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                           ),
//                           dividerColor: Colors.transparent,
//                           tabs: const [
//                             Tab(text: 'Monthly Advance (1,000/-)'),
//                             Tab(text: 'Daily'),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Monthly Prices Header
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: _tabController.index == 0
//                                   ? 'Monthly Prices for '
//                                   : 'Daily Prices for ',
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             TextSpan(
//                               text: _isAC ? 'AC' : 'Non- Ac',
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFE53935),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     // Price Grid
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 4,
//                               childAspectRatio: 1.3,
//                               crossAxisSpacing: 8,
//                               mainAxisSpacing: 8,
//                             ),
//                         itemCount: prices.length,
//                         itemBuilder: (context, index) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFE53935),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
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
//                                   prices[index]['price'],
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Select Date Section
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         'Select Date To Book a Hostel',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     // Date Selector
//                     SizedBox(
//                       height: 70,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         itemCount: _dates.length,
//                         itemBuilder: (context, index) {
//                           final isSelected = _selectedDateIndex == index;
//                           return GestureDetector(
//                             onTap: () =>
//                                 setState(() => _selectedDateIndex = index),
//                             child: Container(
//                               width: 52,
//                               margin: const EdgeInsets.only(right: 8),
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? const Color(0xFFFF0000)
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: isSelected
//                                       ? const Color(0xFFFF0000)
//                                       : Colors.grey[300]!,
//                                 ),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     _dates[index]['day'],
//                                     style: TextStyle(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.black54,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     '${_dates[index]['date']}',
//                                     style: TextStyle(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.black87,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Terms and Privacy
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Checkbox(
//                           //   value: true,
//                           //   onChanged: (_) {},
//                           //   activeColor: const Color(0xFFFF0000),
//                           //   materialTapTargetSize:
//                           //       MaterialTapTargetSize.shrinkWrap,
//                           //   visualDensity: VisualDensity.compact,
//                           // ),
//                           Checkbox(
//                             value: _isAgreed,
//                             onChanged: (value) {
//                               setState(() {
//                                 _isAgreed = value ?? false;
//                               });
//                             },
//                             activeColor: const Color(0xFFFF0000),
//                             materialTapTargetSize:
//                                 MaterialTapTargetSize.shrinkWrap,
//                             visualDensity: VisualDensity.compact,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text.rich(
//                               TextSpan(
//                                 children: [
//                                   const TextSpan(
//                                     text: 'By signing up, you agree to our ',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                   const TextSpan(
//                                     text: 'Terms of Use',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFFFF0000),
//                                       decoration: TextDecoration.underline,
//                                     ),
//                                   ),
//                                   const TextSpan(
//                                     text: '\nand ',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                   const TextSpan(
//                                     text: 'Privacy Policy',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFFFF0000),
//                                       decoration: TextDecoration.underline,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),

//             // Pay After Join Button
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isAgreed ? _showBookingSuccessModal : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFF0000),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: const Text(
//                     'Pay After Join',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
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
//               // Tappable booking image → navigates to History
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

//               // Success text
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     const TextSpan(
//                       text: 'Hostel Booking ',
//                       style: TextStyle(
//                         color: Color(0xFFE53935),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const TextSpan(
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

//               const SizedBox(height: 8),

//               // Hint text
//               // const Text(
//               //   'Tap the image to view your booking history',
//               //   style: TextStyle(
//               //     fontSize: 12,
//               //     color: Colors.black45,
//               //   ),
//               //   textAlign: TextAlign.center,
//               // ),
//               const SizedBox(height: 24),

//               // View History Button
//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 46,
//               //   child: ElevatedButton(
//               //     onPressed: widget.onImageTap,
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: const Color(0xFFFF0000),
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(10),
//               //       ),
//               //       elevation: 0,
//               //     ),
//               //     child: const Text(
//               //       'View History',
//               //       style: TextStyle(
//               //         color: Colors.white,
//               //         fontSize: 15,
//               //         fontWeight: FontWeight.w600,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

















import 'package:brando_app/views/history/booking_history.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAC = false;

  bool _isAgreed = false;
  int _selectedDateIndex = 0;

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

  final List<Map<String, dynamic>> _monthlyNonAcPrices = [
    {'share': '1 SHARE', 'price': '5,000/-'},
    {'share': '2 SHARE', 'price': '5,000/-'},
    {'share': '3 SHARE', 'price': '5,000/-'},
    {'share': '4 SHARE', 'price': '5,000/-'},
    {'share': '1 SHARE', 'price': '5,000/-'},
    {'share': '2 SHARE', 'price': '5,000/-'},
  ];

  final List<Map<String, dynamic>> _monthlyAcPrices = [
    {'share': '1 SHARE', 'price': '7,000/-'},
    {'share': '2 SHARE', 'price': '6,500/-'},
    {'share': '3 SHARE', 'price': '6,000/-'},
    {'share': '4 SHARE', 'price': '5,500/-'},
    {'share': '1 SHARE', 'price': '7,000/-'},
    {'share': '2 SHARE', 'price': '6,500/-'},
  ];

  final List<Map<String, dynamic>> _dailyPrices = [
    {'share': '1 SHARE', 'price': '500/-'},
    {'share': '2 SHARE', 'price': '450/-'},
    {'share': '3 SHARE', 'price': '400/-'},
    {'share': '4 SHARE', 'price': '350/-'},
    {'share': '1 SHARE', 'price': '500/-'},
    {'share': '2 SHARE', 'price': '450/-'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final dates = _dates; // evaluated once per build
    final prices = _tabController.index == 0
        ? (_isAC ? _monthlyAcPrices : _monthlyNonAcPrices)
        : _dailyPrices;

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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'HIFI ',
                              style: TextStyle(
                                color: Color(0xFFE53935),
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
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hostel Image
                    Stack(
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            'assets/detailimage.png',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),

                    // Location Row
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
                          const Expanded(
                            child: Text(
                              'Kphb Hyderabad Kukatpally ...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          // AC Toggle
                          GestureDetector(
                            onTap: () => setState(() => _isAC = !_isAC),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _isAC
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
                                    color: _isAC
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'AC',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _isAC
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 28,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _isAC
                                          ? Colors.white24
                                          : Colors.black12,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Align(
                                      alignment: _isAC
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _isAC
                                              ? Colors.white
                                              : Colors.white70,
                                          shape: BoxShape.circle,
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

                    // Tab Bar
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
                          onTap: (_) => setState(() {}),
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
                          tabs: const [
                            Tab(text: 'Monthly Advance (1,000/-)'),
                            Tab(text: 'Daily'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Monthly / Daily Prices Header
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
                              text: _isAC ? 'AC' : 'Non- Ac',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Price Grid
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
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE53935),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                  prices[index]['price'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Select Date Section
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

                    // ── Dynamic Date Selector ──────────────────────────────
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
                              // Give "Today" a bit more room for the label
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

                    // Terms and Privacy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _isAgreed,
                            onChanged: (value) {
                              setState(() {
                                _isAgreed = value ?? false;
                              });
                            },
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
                                    text: 'By signing up, you agree to our ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'Terms of Use',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFFF0000),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '\nand ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const TextSpan(
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

            // Pay After Join Button
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isAgreed ? _showBookingSuccessModal : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Pay After Join',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
                  children: [
                    const TextSpan(
                      text: 'Hostel Booking ',
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const TextSpan(
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