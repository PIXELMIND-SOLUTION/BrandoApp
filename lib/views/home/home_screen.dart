// import 'dart:convert';
// import 'package:brando_app/views/details/detail_screen.dart';
// import 'package:brando_app/views/notifications/notification_screen.dart';
// import 'package:brando_app/views/search/search_screen.dart';
// import 'package:brando_app/views/seeall/see_all_screen.dart';
// import 'package:brando_app/widgets/wishlist_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentCarouselIndex = 0;

//   bool _isAC = false;

//   final CarouselSliderController _carouselController =
//       CarouselSliderController();

//   // final List<String> _carouselImages = [
//   //   'assets/carouselimage.png',
//   //   'assets/carouselimage.png',
//   //   'assets/carouselimage.png',
//   // ];

//   List<String> _carouselImages = [];
//   bool _isLoadingBanner = true;

//   final List<Map<String, dynamic>> _hostels = [
//     {
//       'id': '1',
//       'name': 'HIFI HOSTELS',
//       'rating': '4.5',
//       'isNew': true,
//       'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
//       'tag': '6KM Away',
//       'isFavorite': true,
//       'shares': [
//         {'label': '1 SHARE', 'price': '5,000/-'},
//         {'label': '2 SHARE', 'price': '3,500/-'},
//         {'label': '3 SHARE', 'price': '3,000/-'},
//         {'label': '4 SHARE', 'price': '2,800/-'},
//         {'label': '5 SHARE', 'price': '6,000/-'},
//       ],
//     },
//     {
//       'id': '2',
//       'name': 'HIFI HOSTELS',
//       'rating': '3.5',
//       'isNew': false,
//       'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
//       'tag': '6KM Away',
//       'isFavorite': false,
//       'shares': [
//         {'label': '1 SHARE', 'price': '5,000/-'},
//         {'label': '2 SHARE', 'price': '3,500/-'},
//         {'label': '3 SHARE', 'price': '3,000/-'},
//         {'label': '4 SHARE', 'price': '2,800/-'},
//         {'label': '5 SHARE', 'price': '6,000/-'},
//       ],
//     },
//     {
//       'id': '3',
//       'name': 'HIFI HOSTELS',
//       'rating': '1.5',
//       'isNew': false,
//       'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
//       'tag': '6KM Away',
//       'isFavorite': false,
//       'shares': [
//         {'label': '1 SHARE', 'price': '5,000/-'},
//         {'label': '2 SHARE', 'price': '3,500/-'},
//         {'label': '3 SHARE', 'price': '3,000/-'},
//         {'label': '4 SHARE', 'price': '2,800/-'},
//         {'label': '5 SHARE', 'price': '6,000/-'},
//       ],
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchBanners();
//   }

//   Future<void> fetchBanners() async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://31.97.206.144:2003/api/Admin/getAllBanners"),
//       );

//       print('Status: ${response.statusCode}');
//       print('Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['success'] == true) {
//           List images = data['banners'][0]['images'];

//           setState(() {
//             _carouselImages = images
//                 .map<String>((img) => img.toString())
//                 .toList();
//             _isLoadingBanner = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint("Banner API error: $e");
//     }
//   }

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       throw 'Could not launch $phoneUri';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTopBar(),
//               _buildSearchBar(context),
//               _buildCarouselBanner(),
//               _buildRecommendedSection(),
//               ..._hostels.map((hostel) => _buildHostelCard(hostel)),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on, color: Colors.red, size: 18),
//           const SizedBox(width: 4),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Location',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 46, 46, 46),
//                   ),
//                 ),
//                 Row(
//                   children: const [
//                     Expanded(
//                       child: Text(
//                         'Kphb Hyderabad Kukatpally ...',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Icon(Icons.arrow_drop_down, size: 20),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           Row(
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FlutterSwitch(
//                     width: 80,
//                     height: 30,
//                     valueFontSize: 10,
//                     toggleSize: 24,
//                     value: _isAC,
//                     borderRadius: 20,
//                     activeText: 'AC',
//                     inactiveText: 'Non-AC',
//                     showOnOff: true,
//                     activeColor: Colors.red,
//                     inactiveColor: Colors.grey.shade400,
//                     onToggle: (val) {
//                       setState(() {
//                         _isAC = val;
//                       });

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           backgroundColor: Colors.green,
//                           content: Text(
//                             val
//                                 ? "Room preference updated to AC successfully."
//                                 : "Room preference updated to Non-AC successfully.",
//                           ),
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               // _topIconButton(Icons.toggle_on_outlined),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => NotificationScreen(),
//                     ),
//                   );
//                 },
//                 child: _topIconButton(Icons.notifications_none),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _topIconButton(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Icon(icon, size: 20, color: Colors.black87),
//     );
//   }

//   Widget _buildSearchBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: TextField(
//           readOnly: true, // 🔥 Important
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SearchScreen()),
//             );
//           },
//           decoration: InputDecoration(
//             hintText: 'Search for "HiFi Hostel"',
//             hintStyle: TextStyle(
//               color: Colors.red.shade400,
//               fontSize: 14,
//               fontStyle: FontStyle.italic,
//             ),
//             prefixIcon: const Icon(Icons.search, color: Colors.grey),
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(vertical: 12),
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildCarouselBanner() {
//     if (_isLoadingBanner) {
//       return const Padding(
//         padding: EdgeInsets.all(20),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_carouselImages.isEmpty) {
//       return const SizedBox();
//     }

//     return Column(
//       children: [
//         CarouselSlider(
//           carouselController: _carouselController,
//           options: CarouselOptions(
//             height: 180,
//             viewportFraction: 1.0,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             onPageChanged: (index, reason) {
//               setState(() => _currentCarouselIndex = index);
//             },
//           ),
//           items: _carouselImages.map((imageUrl) {
//             return Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return const Center(child: CircularProgressIndicator());
//                   },
//                   errorBuilder: (context, error, stackTrace) => SizedBox(),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 8),

//         /// indicators
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: _carouselImages.asMap().entries.map((entry) {
//             return GestureDetector(
//               onTap: () => _carouselController.animateToPage(entry.key),
//               child: Container(
//                 width: entry.key == _currentCarouselIndex ? 20 : 8,
//                 height: 8,
//                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(4),
//                   color: entry.key == _currentCarouselIndex
//                       ? Colors.red
//                       : Colors.grey.shade400,
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//   Widget _buildRecommendedSection() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           RichText(
//             text: const TextSpan(
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               children: [
//                 TextSpan(
//                   text: 'Recommended ',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 TextSpan(
//                   text: 'Hostels',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SeeAllScreen()),
//               );
//             },
//             child: Text(
//               'See all',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHostelCard(Map<String, dynamic> hostel) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DetailScreen()),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 8,
//               spreadRadius: 2,
//               offset: const Offset(0, 2),
//             ),
//           ],
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                     bottomLeft: Radius.circular(12),
//                     bottomRight: Radius.circular(12),
//                   ),
//                   child: Image.asset(
//                     'assets/hotelimage.png',
//                     width: 120,
//                     height: 130,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       width: 120,
//                       height: 130,
//                       color: Colors.grey.shade300,
//                       child: const Icon(
//                         Icons.hotel,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             RichText(
//                               text: TextSpan(
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: hostel['name'].split(' ')[0] + ' ',
//                                     style: const TextStyle(
//                                       color: Color(0xFFF80500), // HIFI color
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: hostel['name'].split(' ').length > 1
//                                         ? hostel['name'].split(' ')[1]
//                                         : '',
//                                     style: const TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ValueListenableBuilder<List<Map<String, dynamic>>>(
//                               valueListenable: WishlistManager().wishlist,
//                               builder: (context, _, __) {
//                                 return GestureDetector(
//                                   onTap: () =>
//                                       WishlistManager().toggle(context, hostel),
//                                   child: Icon(
//                                     WishlistManager().isFavourite(hostel)
//                                         ? Icons.favorite
//                                         : Icons.favorite_border,
//                                     color: WishlistManager().isFavourite(hostel)
//                                         ? Colors.red
//                                         : Colors.grey,
//                                     size: 20,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             _buildRatingBadge(hostel['rating']),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Icon(
//                               Icons.location_on,
//                               color: Colors.red,
//                               size: 12,
//                             ),
//                             const SizedBox(width: 2),
//                             Expanded(
//                               child: RichText(
//                                 text: TextSpan(
//                                   style: const TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.grey,
//                                   ),
//                                   children: [
//                                     TextSpan(text: hostel['location']),
//                                     TextSpan(
//                                       text: '  ${hostel['tag']}',
//                                       style: const TextStyle(
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: (hostel['shares'] as List).map<Widget>((
//                               share,
//                             ) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 6),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       share['label'],
//                                       style: const TextStyle(
//                                         fontSize: 8,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     Text(
//                                       share['price'],
//                                       style: const TextStyle(
//                                         fontSize: 9,
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         _makePhoneCall("9961593179");
//                       },
//                       icon: const Icon(
//                         Icons.call,
//                         size: 14,
//                         color: Colors.white,
//                       ),
//                       label: const Text(
//                         'Call',
//                         style: TextStyle(fontSize: 12, color: Colors.white),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {},
//                       icon: Image.asset(
//                         'assets/whatsapp.png',
//                         width: 18,
//                         height: 18,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const Icon(
//                               Icons.chat,
//                               size: 14,
//                               color: Colors.green,
//                             ),
//                       ),
//                       label: const Text(
//                         'Whatsapp',
//                         style: TextStyle(fontSize: 12, color: Colors.black),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Color(0xFFF80500),
//                         side: const BorderSide(
//                           color: Color.fromARGB(255, 141, 140, 140),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.location_on,
//                         size: 14,
//                         color: Colors.red,
//                       ),
//                       label: const Text(
//                         'Location',
//                         style: TextStyle(fontSize: 12, color: Colors.black),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                         side: const BorderSide(color: Colors.red),
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
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

//   Widget _buildRatingBadge(String rating) {
//     Color color;
//     double ratingValue = double.tryParse(rating) ?? 0;
//     if (ratingValue >= 4) {
//       color = Colors.green;
//     } else if (ratingValue >= 3) {
//       color = Colors.orange;
//     } else {
//       color = Colors.red;
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Row(
//         children: [
//           Text(
//             rating,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(width: 2),
//           const Icon(Icons.star, color: Colors.white, size: 11),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/location/location_provider.dart';
import 'package:brando_app/views/details/detail_screen.dart';
import 'package:brando_app/views/location/location_screen.dart';
import 'package:brando_app/views/notifications/notification_screen.dart';
import 'package:brando_app/views/search/search_screen.dart';
import 'package:brando_app/views/seeall/see_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentCarouselIndex = 0;
  bool _isAC = false;

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<String> _carouselImages = [];
  bool _isLoadingBanner = true;

  // Holds the display address string from LocationScreen
  String _currentAddress = 'Kphb Hyderabad Kukatpally ...';

  @override
  void initState() {
    super.initState();
    fetchBanners();
    _loadInitialHostels();
  }

  /// On first load, fetch nearby hostels using the stored userId
  Future<void> _loadInitialHostels() async {
    final userId = AppPreferences.getUserId();
    if (userId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hostelProvider = Provider.of<HostelProvider>(
        context,
        listen: false,
      );
      hostelProvider.fetchNearbyHostels();
    });
  }

  Future<void> fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse("http://31.97.206.144:2003/api/Admin/getAllBanners"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List images = data['banners'][0]['images'];
          setState(() {
            _carouselImages = images
                .map<String>((img) => img.toString())
                .toList();
            _isLoadingBanner = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Banner API error: $e");
      setState(() => _isLoadingBanner = false);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  // Future<void> _openWhatsApp(String phoneNumber) async {
  //   final url = Uri.parse("https://wa.me/$phoneNumber");

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Could not open WhatsApp")));
  //   }
  // }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final message = Uri.encodeComponent(
      "Hello, I am interested in your hostel.",
    );
    final url = Uri.parse("https://wa.me/$phoneNumber?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Navigate to LocationScreen, then update address + reload hostels on return
  Future<void> _openLocationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationScreen()),
    );

    if (result != null && result is Map && mounted) {
      final address = result['address'] as String?;

      setState(() {
        if (address != null && address.isNotEmpty) {
          // // Trim to a short display string
          // final parts = address.split(',');
          // _currentAddress = parts.length > 1
          //     ? '${parts[0].trim()}, ${parts[1].trim()}...'
          //     : address;

          final parts = address.split(',');
          _currentAddress = parts.length > 2
              ? '${parts[0].trim()}, ${parts[1].trim()}, ${parts[2].trim()}...'
              : parts.length > 1
              ? '${parts[0].trim()}, ${parts[1].trim()}...'
              : address;
        }
      });

      // Hostels are already fetched inside LocationScreen via HostelProvider,
      // but we trigger a filter refresh in case AC toggle changed
      final hostelProvider = Provider.of<HostelProvider>(
        context,
        listen: false,
      );
      hostelProvider.setTypeFilter(_isAC ? 'AC' : 'NON-AC');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildSearchBar(context),
              _buildCarouselBanner(),
              _buildRecommendedSection(),
              _buildHostelList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.red, size: 18),
          const SizedBox(width: 4),

          // ── Tappable location row ──────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: _openLocationScreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              FlutterSwitch(
                width: 80,
                height: 30,
                valueFontSize: 10,
                toggleSize: 24,
                value: _isAC,
                borderRadius: 20,
                activeText: 'AC',
                inactiveText: 'Non-AC',
                showOnOff: true,
                activeColor: Colors.red,
                inactiveColor: Colors.grey.shade400,
                onToggle: (val) {
                  setState(() => _isAC = val);

                  // Apply AC/NON-AC filter on the already-fetched hostel list
                  final hostelProvider = Provider.of<HostelProvider>(
                    context,
                    listen: false,
                  );
                  hostelProvider.setTypeFilter(val ? 'AC' : 'NON-AC');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        val
                            ? "Room preference updated to AC successfully."
                            : "Room preference updated to Non-AC successfully.",
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                child: _topIconButton(Icons.notifications_none),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TextField(
          readOnly: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          decoration: InputDecoration(
            hintText: 'Search for "HiFi Hostel"',
            hintStyle: TextStyle(
              color: Colors.red.shade400,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselBanner() {
    if (_isLoadingBanner) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_carouselImages.isEmpty) return const SizedBox();

    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 180,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() => _currentCarouselIndex = index);
            },
          ),
          items: _carouselImages.map((imageUrl) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _carouselImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: entry.key == _currentCarouselIndex ? 20 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: entry.key == _currentCarouselIndex
                      ? Colors.red
                      : Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'Recommended ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Hostels',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeeAllScreen()),
              );
            },
            child: const Text(
              'See all',
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hostel list driven by HostelProvider ──────────────────────────────────
  Widget _buildHostelList() {
    return Consumer<HostelProvider>(
      builder: (context, hostelProvider, _) {
        // Loading state
        if (hostelProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        }

        // Error state
        if (hostelProvider.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade300,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hostelProvider.errorMessage ?? 'Something went wrong.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => hostelProvider.fetchNearbyHostels(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (hostelProvider.hostels.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.apartment_outlined,
                    color: Colors.grey.shade400,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hostels found nearby.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try changing your location to discover hostels.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _openLocationScreen,
                    icon: const Icon(Icons.location_on, size: 16),
                    label: const Text('Change Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Loaded hostels list
        return Column(
          children: hostelProvider.hostels
              .map((hostel) => _buildHostelCard(hostel))
              .toList(),
        );
      },
    );
  }

  Widget _buildHostelCard(dynamic hostel) {
    // Support both HostelModel (from API) and legacy Map<String, dynamic>
    final bool isHostelModel = hostel is! Map;

    final String name = isHostelModel
        ? hostel.name
        : (hostel['name'] ?? 'Unknown');
    final String rating = isHostelModel
        ? hostel.rating.toString()
        : (hostel['rating'] ?? '0').toString();
    final String location = isHostelModel
        ? hostel.address
        : (hostel['location'] ?? '');
    final String type = isHostelModel ? hostel.type : '';
    final List shares = isHostelModel
        ? hostel.sharings
        : (hostel['shares'] ?? []);
    final String firstImage = isHostelModel && hostel.images.isNotEmpty
        ? hostel.images[0]
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(hostelId: hostel.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hostel image ──────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: firstImage.isNotEmpty
                      ? Image.network(
                          firstImage, // ← remove the base URL prefix
                          width: 120,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : Image.asset(
                          'assets/hotelimage.png',
                          width: 120,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        ),
                ),

                // ── Hostel info ───────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${name.split(' ').first} ',
                                      style: const TextStyle(
                                        color: Color(0xFFF80500),
                                      ),
                                    ),
                                    TextSpan(
                                      text: name.split(' ').length > 1
                                          ? name.split(' ')[1]
                                          : '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Favorite button (only for map-based legacy cards)
                            // if (!isHostelModel)
                            //  ValueListenableBuilder<List<Map<String, dynamic>>>(
                            //     valueListenable:
                            //         WishlistManager().wishlist,
                            //     builder: (context, _, __) {
                            //       return GestureDetector(
                            //         onTap: () => WishlistManager()
                            //             .toggle(context, hostel),
                            //         child: Icon(
                            //           WishlistManager()
                            //                   .isFavourite(hostel)
                            //               ? Icons.favorite
                            //               : Icons.favorite_border,
                            //           color: WishlistManager()
                            //                   .isFavourite(hostel)
                            //               ? Colors.red
                            //               : Colors.grey,
                            //           size: 20,
                            //         ),
                            //       );
                            //     },
                            //   ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildRatingBadge(rating),
                            if (type.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: type == 'AC'
                                      ? Colors.blue.shade50
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: type == 'AC'
                                        ? Colors.blue.shade200
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: type == 'AC'
                                        ? Colors.blue
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Sharing price chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: shares.map<Widget>((share) {
                              final label = isHostelModel
                                  ? share.shareType
                                  : share['label'];
                              final price = isHostelModel
                                  ? '₹${share.monthlyPrice}/-'
                                  : share['price'];
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Column(
                                  children: [
                                    Text(
                                      label,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      price,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Action buttons ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _makePhoneCall("9961593179"),
                      icon: const Icon(
                        Icons.call,
                        size: 14,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Call',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _openWhatsApp(
                          "919961593179",
                        ); // number with country code
                      },
                      icon: Image.asset(
                        'assets/whatsapp.png',
                        width: 18,
                        height: 18,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.chat,
                          size: 14,
                          color: Colors.green,
                        ),
                      ),
                      label: const Text(
                        'Whatsapp',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF80500),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 141, 140, 140),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: OutlinedButton.icon(
                  //     onPressed: () {},
                  //     icon: Image.asset(
                  //       'assets/whatsapp.png',
                  //       width: 18,
                  //       height: 18,
                  //       errorBuilder: (_, __, ___) => const Icon(
                  //         Icons.chat,
                  //         size: 14,
                  //         color: Colors.green,
                  //       ),
                  //     ),
                  //     label: const Text(
                  //       'Whatsapp',
                  //       style: TextStyle(fontSize: 12, color: Colors.black),
                  //     ),
                  //     style: OutlinedButton.styleFrom(
                  //       foregroundColor: const Color(0xFFF80500),
                  //       side: const BorderSide(
                  //         color: Color.fromARGB(255, 141, 140, 140),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(vertical: 6),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(6),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Location',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
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

  Widget _placeholderImage() {
    return Container(
      width: 120,
      height: 130,
      color: Colors.grey.shade300,
      child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
    );
  }

  Widget _buildRatingBadge(String rating) {
    final double ratingValue = double.tryParse(rating) ?? 0;
    final Color color = ratingValue >= 4
        ? Colors.green
        : ratingValue >= 3
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            rating,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star, color: Colors.white, size: 11),
        ],
      ),
    );
  }
}
