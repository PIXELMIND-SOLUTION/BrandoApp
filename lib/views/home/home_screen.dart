// import 'dart:async';
// import 'dart:convert';
// import 'package:brando_app/helper/shared_preference.dart';
// import 'package:brando_app/provider/auth/profile_provider.dart';
// import 'package:brando_app/provider/category/category_provider.dart';
// import 'package:brando_app/provider/location/location_provider.dart';
// import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
// import 'package:brando_app/views/Map/map_screen.dart';
// import 'package:brando_app/views/details/detail_screen.dart';
// import 'package:brando_app/views/location/location_screen.dart';
// import 'package:brando_app/views/notifications/notification_screen.dart';
// import 'package:brando_app/views/search/search_screen.dart';
// import 'package:brando_app/views/seeall/see_all_screen.dart';
// import 'package:brando_app/widgets/category_widget.dart';
// import 'package:brando_app/widgets/toast_message.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentCarouselIndex = 0;
//   bool _isAC = false;
//   bool _isFetchingLocation = false;

//   String _searchHintHostelName = 'Hostel';
//   int _hintIndex = 0;
//   Timer? _hintTimer;

//   bool _locationPermissionDenied = false;
//   bool _locationServiceDisabled = false;

//   bool _isDialogOpen = false;

//   void _startHintCycling(List<String> names) {
//     _hintTimer?.cancel();
//     if (names.isEmpty) return;

//     _hintTimer = Timer.periodic(const Duration(seconds: 2), (_) {
//       if (!mounted) return;
//       setState(() {
//         _hintIndex = (_hintIndex + 1) % names.length;
//         _searchHintHostelName = names[_hintIndex];
//       });
//     });
//   }

//   final CarouselSliderController _carouselController =
//       CarouselSliderController();

//   List<String> _carouselImages = [];
//   bool _isLoadingBanner = true;

//   String _currentAddress = 'Fetching location...';

//   @override
//   void initState() {
//     super.initState();
//     fetchBanners();
//     _fetchCurrentLocation();
//     _loadInitialHostels();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         context.read<CategoryProvider>().fetchCategories();

//         context.read<WishlistProvider>().fetchWishlist();

//         context.read<ProfileProvider>().fetchProfile().then((_) {
//           final name = context.read<ProfileProvider>().profile?.name ?? '';
//         });
//       }
//     });
//   }

//   Future<void> _handleRefresh() async {
//     await Future.wait([
//       fetchBanners(),
//       _fetchCurrentLocation(),
//       _refreshHostels(),
//       context.read<CategoryProvider>().fetchCategories(), // Add this
//     ]);
//   }

//   Future<void> _refreshHostels() async {
//     final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
//     await hostelProvider.fetchNearbyHostels();

//     if (mounted && hostelProvider.hostels.isNotEmpty) {
//       final names = hostelProvider.hostels
//           .map((h) => h.name as String)
//           .toList();
//       setState(() => _searchHintHostelName = names.first);
//       _startHintCycling(names);
//     }
//   }

//   Future<void> _fetchCurrentLocation() async {
//     setState(() {
//       _isFetchingLocation = true;
//       _currentAddress = 'Fetching location...';
//       _locationPermissionDenied = false;
//       _locationServiceDisabled = false;
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         setState(() {
//           _locationServiceDisabled = true;
//           _currentAddress = 'Location off';
//           _isFetchingLocation = false;
//           // _currentAddress = 'Location services disabled';
//           // _isFetchingLocation = false;
//         });
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _locationPermissionDenied = true;
//             _currentAddress = 'Permission denied';
//             _isFetchingLocation = false;
//             // _currentAddress = 'Location permission denied';
//             // _isFetchingLocation = false;
//           });
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _locationPermissionDenied = true;
//           _currentAddress = 'Permission denied';
//           _isFetchingLocation = false;
//           // _currentAddress = 'Location permission permanently denied';
//           // _isFetchingLocation = false;
//         });
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       await _getAddressFromLatLng(position.latitude, position.longitude);

//       if (mounted) {
//         final hostelProvider = Provider.of<HostelProvider>(
//           context,
//           listen: false,
//         );
//         hostelProvider.updateLocationAndFetch(
//           latitude: position.latitude,
//           longitude: position.longitude,
//         );
//       }
//     } catch (e) {
//       debugPrint("Location fetch error: $e");
//       setState(() {
//         _currentAddress = 'Could not fetch location';
//         _isFetchingLocation = false;
//       });
//     }
//   }

//   Future<void> _getAddressFromLatLng(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

//       if (placemarks.isNotEmpty) {
//         final Placemark place = placemarks.first;

//         final List<String> parts = [
//           if (place.subLocality != null && place.subLocality!.isNotEmpty)
//             place.subLocality!,
//           if (place.locality != null && place.locality!.isNotEmpty)
//             place.locality!,
//           if (place.subAdministrativeArea != null &&
//               place.subAdministrativeArea!.isNotEmpty)
//             place.subAdministrativeArea!,
//         ];

//         final String address = parts.isNotEmpty
//             ? parts.take(3).join(', ')
//             : '${place.administrativeArea ?? ''}, ${place.country ?? ''}';

//         setState(() {
//           _currentAddress = address.isNotEmpty ? address : 'Location found';
//           _isFetchingLocation = false;
//         });
//       } else {
//         setState(() {
//           _currentAddress = 'Location found';
//           _isFetchingLocation = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Geocoding error: $e");
//       setState(() {
//         _currentAddress = 'Location found';
//         _isFetchingLocation = false;
//       });
//     }
//   }

//   Future<void> _loadInitialHostels() async {
//     final userId = AppPreferences.getUserId();
//     if (userId == null) return;

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final hostelProvider = Provider.of<HostelProvider>(
//         context,
//         listen: false,
//       );
//       await hostelProvider.fetchNearbyHostels();

//       if (mounted && hostelProvider.hostels.isNotEmpty) {
//         final names = hostelProvider.hostels
//             .map((h) => h.name as String)
//             .toList();
//         setState(() => _searchHintHostelName = names.first);
//         _startHintCycling(names);
//       }
//     });
//   }

//   Future<void> fetchBanners() async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://187.127.146.52:2003/api/Admin/getAllBanners"),
//       );

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
//       setState(() => _isLoadingBanner = false);
//     }
//   }

//   // ─── Actions ───────────────────────────────────────────────────────────────

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       throw 'Could not launch $phoneUri';
//     }
//   }

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

//   Future<void> _openLocationScreen() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const LocationScreen()),
//     );

//     if (result != null && result is Map && mounted) {
//       final address = result['address'] as String?;

//       setState(() {
//         if (address != null && address.isNotEmpty) {
//           final parts = address.split(',');
//           _currentAddress = parts.length > 2
//               ? '${parts[0].trim()}, ${parts[1].trim()}, ${parts[2].trim()}...'
//               : parts.length > 1
//               ? '${parts[0].trim()}, ${parts[1].trim()}...'
//               : address;
//         }
//       });

//       final hostelProvider = Provider.of<HostelProvider>(
//         context,
//         listen: false,
//       );
//       hostelProvider.setTypeFilter(_isAC ? 'AC' : 'NON-AC');
//     }
//   }

//   @override
//   void dispose() {
//     _hintTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_isDialogOpen) return false;

//         _isDialogOpen = true;

//         final shouldExit = await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Exit App'),
//             content: const Text('Are you sure you want to exit?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: const Text('Exit', style: TextStyle(color: Colors.red)),
//               ),
//             ],
//           ),
//         );

//         _isDialogOpen = false;

//         if (shouldExit == true) {
//           if (mounted) {
//             SystemNavigator.pop();
//           }
//           return true;
//         }
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           top: false,
//           child: RefreshIndicator(
//             color: Colors.red,
//             onRefresh: _handleRefresh,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTopBar(),
//                   const SizedBox(height: 20),

//                   _buildCarouselBanner(),
//                   const SizedBox(height: 20),
//                   // Add Category Widget here
//                   const CategoryWidget(scrollDirection: Axis.horizontal),
//                   _buildRecommendedSection(),
//                   _buildHostelList(),
//                   _buildNearbySection(),
//                   _buildRecList(),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopBar() {
//     return Consumer<ProfileProvider>(
//       builder: (context, profileProvider, _) {
//         final profile = profileProvider.profile;
//         final displayName = profile?.name ?? 'Guest';
//         final profileImageUrl = profile?.profileImage;

//         return Container(
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF63183F), // Light red
//                 Color(0xFF63183F), // Dark red
//                 Color(0xFF63183F), // Deep red
//               ],
//               stops: [0.0, 0.6, 1.0],
//             ),
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),

//               // Top section with profile, location, and notification
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                 child: Row(
//                   children: [
//                     // Profile Image Section (Left side)
//                     GestureDetector(
//                       onTap: () {
//                         // Navigate to profile screen
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(builder: (context) => ProfileScreen()),
//                         // );
//                       },
//                       child: Container(
//                         width: 45,
//                         height: 45,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 2),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 8,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: ClipOval(
//                           child:
//                               profileImageUrl != null &&
//                                   profileImageUrl.isNotEmpty
//                               ? Image.network(
//                                   profileImageUrl,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return _buildProfilePlaceholder(
//                                       displayName,
//                                     );
//                                   },
//                                   loadingBuilder:
//                                       (context, child, loadingProgress) {
//                                         if (loadingProgress == null)
//                                           return child;
//                                         return const Center(
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             color: Colors.white,
//                                           ),
//                                         );
//                                       },
//                                 )
//                               : _buildProfilePlaceholder(displayName),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(width: 12),

//                     // Location Section
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: _openLocationScreen,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Location',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white70,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     _currentAddress,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Notification icon
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NotificationScreen(),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.notifications_none,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Greeting text (Uncommented and using profile name)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Hi, ${displayName.split(' ').first} 👋',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'Discover hostels, BHKs & RK rooms around you.',
//                         style: TextStyle(fontSize: 14, color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Search Bar - Card style
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     // Search Bar
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: TextField(
//                           readOnly: true,
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SearchScreen(),
//                               ),
//                             );
//                           },
//                           decoration: InputDecoration(
//                             hintText: 'Search for "$_searchHintHostelName"',
//                             hintStyle: TextStyle(
//                               color: const Color.fromARGB(255, 230, 67, 67),
//                               fontSize: 14,
//                             ),
//                             prefixIcon: Icon(
//                               Icons.search,
//                               color: Colors.grey.shade600,
//                               size: 25,
//                             ),
//                             suffixIcon: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _isAC = !_isAC;
//                                 });
//                                 final hostelProvider =
//                                     Provider.of<HostelProvider>(
//                                       context,
//                                       listen: false,
//                                     );
//                                 hostelProvider.setTypeFilter(
//                                   _isAC ? 'AC' : 'NON-AC',
//                                 );

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     backgroundColor: Colors.green,
//                                     content: Text(
//                                       _isAC
//                                           ? "Room preference updated to AC successfully."
//                                           : "Room preference updated to Non-AC successfully.",
//                                     ),
//                                     duration: const Duration(seconds: 2),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.all(8),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: _isAC
//                                       ? Colors.red
//                                       : Colors.grey.shade200,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.ac_unit,
//                                       size: 16,
//                                       color: _isAC
//                                           ? Colors.white
//                                           : Colors.grey.shade600,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       _isAC ? 'AC' : 'Non-AC',
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w600,
//                                         color: _isAC
//                                             ? Colors.white
//                                             : Colors.grey.shade700,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(
//                               vertical: 14,
//                               horizontal: 8,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Helper method to build profile placeholder
//   Widget _buildProfilePlaceholder(String displayName) {
//     return Container(
//       color: Colors.red.shade400,
//       child: Center(
//         child: Text(
//           displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   // ─── Carousel ──────────────────────────────────────────────────────────────

//   Widget _buildCarouselBanner() {
//     if (_isLoadingBanner) {
//       return const Padding(
//         padding: EdgeInsets.all(20),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_carouselImages.isEmpty) return const SizedBox();

//     return Column(
//       children: [
//         CarouselSlider(
//           carouselController: _carouselController,
//           options: CarouselOptions(
//             height: 120,
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
//                   fit: BoxFit.fill,
//                   width: double.infinity,
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return const Center(child: CircularProgressIndicator());
//                   },
//                   errorBuilder: (context, error, stackTrace) =>
//                       const SizedBox(),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         // const SizedBox(height: 8),
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.center,
//         //   children: _carouselImages.asMap().entries.map((entry) {
//         //     return GestureDetector(
//         //       onTap: () => _carouselController.animateToPage(entry.key),
//         //       child: Container(
//         //         width: entry.key == _currentCarouselIndex ? 20 : 8,
//         //         height: 8,
//         //         margin: const EdgeInsets.symmetric(horizontal: 3),
//         //         decoration: BoxDecoration(
//         //           borderRadius: BorderRadius.circular(4),
//         //           color: entry.key == _currentCarouselIndex
//         //               ? Colors.red
//         //               : Colors.grey.shade400,
//         //         ),
//         //       ),
//         //     );
//         //   }).toList(),
//         // ),
//       ],
//     );
//   }

//   // ─── Recommended Section ───────────────────────────────────────────────────

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
//             child: const Text(
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
//   // ─── Hostel List ───────────────────────────────────────────────────────────

//   Widget _buildNearbySection() {
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
//                   text: 'Nearby ',
//                   style: TextStyle(color: Colors.black),
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
//             child: const Text(
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

//   Widget _buildHostelList() {
//     if (_locationPermissionDenied || _locationServiceDisabled) {
//       return _buildLocationPermissionScreen();
//     }
//     return Consumer<HostelProvider>(
//       builder: (context, hostelProvider, _) {
//         if (hostelProvider.isLoading) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 40),
//             child: Center(child: CircularProgressIndicator(color: Colors.red)),
//           );
//         }

//         // if (hostelProvider.hasError) {
//         //   return Padding(
//         //     padding: const EdgeInsets.all(24),
//         //     child: Center(
//         //       child: Column(
//         //         children: [
//         //           Icon(
//         //             Icons.error_outline,
//         //             color: Colors.red.shade300,
//         //             size: 48,
//         //           ),
//         //           const SizedBox(height: 12),
//         //           Text(
//         //             hostelProvider.errorMessage ?? 'Something went wrong.',
//         //             textAlign: TextAlign.center,
//         //             style: const TextStyle(color: Colors.grey, fontSize: 14),
//         //           ),
//         //           const SizedBox(height: 16),
//         //           ElevatedButton(
//         //             onPressed: () => hostelProvider.fetchNearbyHostels(),
//         //             style: ElevatedButton.styleFrom(
//         //               backgroundColor: Colors.red,
//         //               shape: RoundedRectangleBorder(
//         //                 borderRadius: BorderRadius.circular(8),
//         //               ),
//         //             ),
//         //             child: const Text(
//         //               'Retry',
//         //               style: TextStyle(color: Colors.white),
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     ),
//         //   );
//         // }

//         if (hostelProvider.hasError) {
//           return Padding(
//             padding: const EdgeInsets.all(24),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Lottie.network(
//                     'https://assets2.lottiefiles.com/packages/lf20_qh5z2fdq.json',
//                     width: 220,
//                     height: 220,
//                     fit: BoxFit.contain,
//                     repeat: true,
//                     errorBuilder: (_, __, ___) => Icon(
//                       Icons.error_outline,
//                       color: Colors.red.shade300,
//                       size: 64,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // const Text(
//                   //   'Oops! Something Went Wrong',
//                   //   style: TextStyle(
//                   //     fontSize: 18,
//                   //     fontWeight: FontWeight.bold,
//                   //     color: Color(0xFF2E2E2E),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 8),
//                   // Text(
//                   //   hostelProvider.errorMessage ?? 'We couldn\'t load hostels.\nPlease try again.',
//                   //   textAlign: TextAlign.center,
//                   //   style: const TextStyle(
//                   //     color: Colors.grey,
//                   //     fontSize: 13,
//                   //     height: 1.5,
//                   //   ),
//                   // ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () => hostelProvider.fetchRecoHostels(),
//                       icon: const Icon(Icons.refresh_rounded, size: 18),
//                       label: const Text(
//                         'Refresh',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (hostelProvider.recommendedHostels.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Lottie.network(
//                     'https://assets10.lottiefiles.com/packages/lf20_hl5n0bwb.json',
//                     width: 220,
//                     height: 220,
//                     fit: BoxFit.contain,
//                     repeat: true,
//                     errorBuilder: (_, __, ___) => Icon(
//                       Icons.apartment_outlined,
//                       color: Colors.grey.shade400,
//                       size: 64,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'No Hostels Found Nearby',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2E2E2E),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'We couldn\'t find any hostels around your\ncurrent location. Try changing it!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey,
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: _openLocationScreen,
//                     icon: const Icon(Icons.location_on, size: 16),
//                     label: const Text(
//                       'Change Location',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 28,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       elevation: 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         return Column(
//           children: hostelProvider.recommendedHostels
//               .map((hostel) => _buildHostelCard(hostel))
//               .toList(),
//         );
//       },
//     );
//   }

//   Widget _buildRecList() {
//     if (_locationPermissionDenied || _locationServiceDisabled) {
//       return _buildLocationPermissionScreen();
//     }
//     return Consumer<HostelProvider>(
//       builder: (context, hostelProvider, _) {
//         if (hostelProvider.isLoading) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 40),
//             child: Center(child: CircularProgressIndicator(color: Colors.red)),
//           );
//         }

//         // if (hostelProvider.hasError) {
//         //   return Padding(
//         //     padding: const EdgeInsets.all(24),
//         //     child: Center(
//         //       child: Column(
//         //         children: [
//         //           Icon(
//         //             Icons.error_outline,
//         //             color: Colors.red.shade300,
//         //             size: 48,
//         //           ),
//         //           const SizedBox(height: 12),
//         //           Text(
//         //             hostelProvider.errorMessage ?? 'Something went wrong.',
//         //             textAlign: TextAlign.center,
//         //             style: const TextStyle(color: Colors.grey, fontSize: 14),
//         //           ),
//         //           const SizedBox(height: 16),
//         //           ElevatedButton(
//         //             onPressed: () => hostelProvider.fetchNearbyHostels(),
//         //             style: ElevatedButton.styleFrom(
//         //               backgroundColor: Colors.red,
//         //               shape: RoundedRectangleBorder(
//         //                 borderRadius: BorderRadius.circular(8),
//         //               ),
//         //             ),
//         //             child: const Text(
//         //               'Retry',
//         //               style: TextStyle(color: Colors.white),
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     ),
//         //   );
//         // }

//         if (hostelProvider.hasError) {
//           return Padding(
//             padding: const EdgeInsets.all(24),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Lottie.network(
//                     'https://assets2.lottiefiles.com/packages/lf20_qh5z2fdq.json',
//                     width: 220,
//                     height: 220,
//                     fit: BoxFit.contain,
//                     repeat: true,
//                     errorBuilder: (_, __, ___) => Icon(
//                       Icons.error_outline,
//                       color: Colors.red.shade300,
//                       size: 64,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // const Text(
//                   //   'Oops! Something Went Wrong',
//                   //   style: TextStyle(
//                   //     fontSize: 18,
//                   //     fontWeight: FontWeight.bold,
//                   //     color: Color(0xFF2E2E2E),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 8),
//                   // Text(
//                   //   hostelProvider.errorMessage ?? 'We couldn\'t load hostels.\nPlease try again.',
//                   //   textAlign: TextAlign.center,
//                   //   style: const TextStyle(
//                   //     color: Colors.grey,
//                   //     fontSize: 13,
//                   //     height: 1.5,
//                   //   ),
//                   // ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () => hostelProvider.fetchNearbyHostels(),
//                       icon: const Icon(Icons.refresh_rounded, size: 18),
//                       label: const Text(
//                         'Refresh',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (hostelProvider.hostels.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Lottie.network(
//                     'https://assets10.lottiefiles.com/packages/lf20_hl5n0bwb.json',
//                     width: 220,
//                     height: 220,
//                     fit: BoxFit.contain,
//                     repeat: true,
//                     errorBuilder: (_, __, ___) => Icon(
//                       Icons.apartment_outlined,
//                       color: Colors.grey.shade400,
//                       size: 64,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'No Hostels Found Nearby',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2E2E2E),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'We couldn\'t find any hostels around your\ncurrent location. Try changing it!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey,
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: _openLocationScreen,
//                     icon: const Icon(Icons.location_on, size: 16),
//                     label: const Text(
//                       'Change Location',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 28,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       elevation: 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         return Column(
//           children: hostelProvider.hostels
//               .map((hostel) => _buildHostelCard(hostel))
//               .toList(),
//         );
//       },
//     );
//   }

//   Widget _buildLocationPermissionScreen() {
//     final bool isServiceOff = _locationServiceDisabled;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Lottie animation — GPS/location themed
//           Lottie.network(
//             isServiceOff
//                 ? 'https://assets4.lottiefiles.com/packages/lf20_UJNc2t.json' // GPS searching
//                 : 'https://assets9.lottiefiles.com/packages/lf20_qwL4Ajt1zX.json', // location pin
//             width: 240,
//             height: 240,
//             fit: BoxFit.contain,
//             repeat: true,
//             errorBuilder: (_, __, ___) => Lottie.network(
//               'https://assets10.lottiefiles.com/packages/lf20_myejiggj.json',
//               width: 240,
//               height: 240,
//               repeat: true,
//               errorBuilder: (_, __, ___) => Icon(
//                 Icons.location_off_rounded,
//                 size: 80,
//                 color: Colors.red.shade300,
//               ),
//             ),
//           ),

//           const SizedBox(height: 4),

//           // Title
//           Text(
//             isServiceOff ? 'Location Is Turned Off' : 'Location Access Needed',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2E2E2E),
//               letterSpacing: -0.3,
//             ),
//           ),

//           const SizedBox(height: 10),

//           // Subtitle
//           Text(
//             isServiceOff
//                 ? 'Please enable location services on your device so we can find hostels near you.'
//                 : 'We need your location to show nearby hostels.\nTap below to grant access.',
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Colors.grey,
//               height: 1.6,
//             ),
//           ),

//           const SizedBox(height: 28),

//           // CTA Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: isServiceOff
//                   ? () async {
//                       await Geolocator.openLocationSettings();
//                     }
//                   : () async {
//                       if (_locationPermissionDenied) {
//                         await Geolocator.openAppSettings();
//                       } else {
//                         await _fetchCurrentLocation();
//                       }
//                     },
//               icon: Icon(
//                 isServiceOff ? Icons.settings : Icons.my_location_rounded,
//                 size: 18,
//               ),
//               label: Text(
//                 isServiceOff ? 'Open Location Settings' : 'Enable Location',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 2,
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           // Secondary: manual location pick
//           TextButton.icon(
//             onPressed: _openLocationScreen,
//             icon: const Icon(Icons.search, size: 16, color: Colors.red),
//             label: const Text(
//               'Search a location manually',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // ─── Hostel Card ───────────────────────────────────────────────────────────

//   Widget _buildHostelCard(dynamic hostel) {
//     final bool isHostelModel = hostel is! Map;

//     final String hostelId = isHostelModel ? hostel.id : (hostel['_id'] ?? '');
//     final String name = isHostelModel
//         ? hostel.name
//         : (hostel['name'] ?? 'Unknown');
//     final String rating = isHostelModel
//         ? hostel.rating.toString()
//         : (hostel['rating'] ?? '0').toString();
//     final String location = isHostelModel
//         ? hostel.address
//         : (hostel['location'] ?? '');
//     final List allShares = isHostelModel
//         ? hostel.sharings
//         : (hostel['shares'] ?? []);
//     final String firstImage = isHostelModel && hostel.images.isNotEmpty
//         ? hostel.images[0]
//         : '';

//     // ── Filter sharings based on AC/Non-AC toggle ──────────────────────────
//     final String selectedType = _isAC ? 'AC' : 'Non-AC';
//     final List filteredShares = allShares.where((share) {
//       final String shareType = isHostelModel
//           ? (share.type ?? '')
//           : (share['type'] ?? '');
//       return shareType == selectedType;
//     }).toList();

//     // Fall back to all shares if none match the selected type
//     final List displayShares = filteredShares.isNotEmpty
//         ? filteredShares
//         : allShares;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailScreen(hostelId: hostelId),
//           ),
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
//                 // ── Hostel Image ──────────────────────────────────────────
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: firstImage.isNotEmpty
//                       ? Image.network(
//                           firstImage,
//                           width: 120,
//                           height: 130,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => _placeholderImage(),
//                         )
//                       : Image.asset(
//                           'assets/hotelimage.png',
//                           width: 120,
//                           height: 130,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => _placeholderImage(),
//                         ),
//                 ),

//                 // ── Card Details ──────────────────────────────────────────
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: RichText(
//                                 text: TextSpan(
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: '${name.split(' ').first} ',
//                                       style: const TextStyle(
//                                         color: Color(0xFFF80500),
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: name.split(' ').length > 1
//                                           ? name.split(' ')[1]
//                                           : '',
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Selector<WishlistProvider, bool>(
//                               selector: (_, provider) =>
//                                   provider.isWishlisted(hostelId),
//                               builder: (context, wishlisted, _) {
//                                 return GestureDetector(
//                                   // onTap: hostelId.isEmpty
//                                   //     ? null
//                                   //     : () {
//                                   //         context
//                                   //             .read<WishlistProvider>()
//                                   //             .toggleWishlist(hostelId);
//                                   //       },

//                                   // Replace the onTap inside the Selector<WishlistProvider> block
//                                   onTap: hostelId.isEmpty
//                                       ? null
//                                       : () {
//                                           final wishlistProvider = context
//                                               .read<WishlistProvider>();
//                                           final isCurrentlyWishlisted =
//                                               wishlistProvider.isWishlisted(
//                                                 hostelId,
//                                               );
//                                           wishlistProvider.toggleWishlist(
//                                             hostelId,
//                                           );

//                                           ToastHelper.show(
//                                             context,
//                                             message: isCurrentlyWishlisted
//                                                 ? 'Removed from your wishlist'
//                                                 : '❤️  Added to wishlist — $name',
//                                             type: isCurrentlyWishlisted
//                                                 ? ToastType.warning
//                                                 : ToastType.success,
//                                           );
//                                         },
//                                   child: AnimatedSwitcher(
//                                     duration: const Duration(milliseconds: 300),
//                                     transitionBuilder: (child, animation) =>
//                                         ScaleTransition(
//                                           scale: animation,
//                                           child: child,
//                                         ),
//                                     child: Icon(
//                                       wishlisted
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       key: ValueKey(wishlisted),
//                                       color: wishlisted
//                                           ? Colors.red
//                                           : Colors.grey.shade400,
//                                       size: 22,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 4),

//                         // ── Rating + AC/Non-AC Badge ──────────────────────
//                         Row(
//                           children: [
//                             _buildRatingBadge(rating),
//                             const SizedBox(width: 6),
//                             // Show current filter type as a badge
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 6,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: _isAC
//                                     ? Colors.blue.shade50
//                                     : Colors.grey.shade100,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(
//                                   color: _isAC
//                                       ? Colors.blue.shade200
//                                       : Colors.grey.shade300,
//                                 ),
//                               ),
//                               child: Text(
//                                 _isAC ? 'AC' : 'Non-AC',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600,
//                                   color: _isAC
//                                       ? Colors.blue
//                                       : Colors.grey.shade600,
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(width: 6),

//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 6,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.purple.shade50,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(
//                                   color: Colors.purple.shade200,
//                                 ),
//                               ),
//                               child: Text(
//                                 hostel.categoryId.name,
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.purple.shade700,
//                                 ),
//                               ),
//                             ),
//                             // Show "No AC" warning if hostel doesn't support selected type
//                             if (filteredShares.isEmpty) ...[
//                               const SizedBox(width: 4),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 5,
//                                   vertical: 2,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.orange.shade50,
//                                   borderRadius: BorderRadius.circular(4),
//                                   border: Border.all(
//                                     color: Colors.orange.shade300,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'N/A',
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.orange.shade700,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),

//                         const SizedBox(height: 6),

//                         // ── Address ───────────────────────────────────────
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
//                               child: Text(
//                                 location,
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 8),

//                         // ── Filtered Sharing Prices ───────────────────────
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: displayShares.map<Widget>((share) {
//                               final String label = isHostelModel
//                                   ? share.shareType
//                                   : (share['shareType'] ??
//                                         share['label'] ??
//                                         '');
//                               final int monthlyPrice = isHostelModel
//                                   ? share.monthlyPrice
//                                   : (share['monthlyPrice'] ?? 0);
//                               final String priceText = '₹$monthlyPrice/-';

//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 8),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 6,
//                                     vertical: 3,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.red.shade50,
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(
//                                       color: Colors.red.shade100,
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         label,
//                                         style: const TextStyle(
//                                           fontSize: 8,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                       Text(
//                                         priceText,
//                                         style: const TextStyle(
//                                           fontSize: 9,
//                                           color: Colors.red,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
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

//             // ── Action Buttons ────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () => _makePhoneCall("9961593179"),
//                           icon: const Icon(
//                             Icons.call,
//                             size: 14,
//                             color: Colors.white,
//                           ),
//                           label: const Text(
//                             'Call',
//                             style: TextStyle(fontSize: 12, color: Colors.white),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             foregroundColor: Colors.red,
//                             padding: const EdgeInsets.symmetric(vertical: 6),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () => _openWhatsApp("919961593179"),
//                           icon: Image.asset(
//                             'assets/whatsapp.png',
//                             width: 18,
//                             height: 18,
//                             errorBuilder: (_, __, ___) => const Icon(
//                               Icons.chat,
//                               size: 14,
//                               color: Colors.green,
//                             ),
//                           ),
//                           label: const Text(
//                             'Whatsapp',
//                             style: TextStyle(fontSize: 12, color: Colors.black),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: const Color(0xFFF80500),
//                             side: const BorderSide(
//                               color: Color.fromARGB(255, 141, 140, 140),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 6),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MapScreen(
//                                   hostelLatitude: isHostelModel
//                                       ? hostel.location.latitude
//                                       : null,
//                                   hostelLongitude: isHostelModel
//                                       ? hostel.location.longitude
//                                       : null,
//                                   hostelName: name,
//                                   hostelAddress: location,
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(
//                             Icons.location_on,
//                             size: 14,
//                             color: Colors.red,
//                           ),
//                           label: const Text(
//                             'Location',
//                             style: TextStyle(fontSize: 12, color: Colors.black),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.red,
//                             side: const BorderSide(color: Colors.red),
//                             padding: const EdgeInsets.symmetric(vertical: 6),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─── Helpers ───────────────────────────────────────────────────────────────

//   Widget _placeholderImage() {
//     return Container(
//       width: 120,
//       height: 130,
//       color: Colors.grey.shade300,
//       child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
//     );
//   }

//   Widget _buildRatingBadge(String rating) {
//     final double ratingValue = double.tryParse(rating) ?? 0;
//     final Color color = ratingValue >= 4
//         ? Colors.green
//         : ratingValue >= 3
//         ? Colors.orange
//         : Colors.red;

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

import 'dart:async';
import 'dart:convert';
import 'package:brando_app/config/theme_config.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/auth/profile_provider.dart';
import 'package:brando_app/provider/category/category_provider.dart';
import 'package:brando_app/provider/location/location_provider.dart';
import 'package:brando_app/provider/theme_provider.dart';
import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
import 'package:brando_app/views/Ecommerce/product_banner_widget.dart';
import 'package:brando_app/views/Map/map_screen.dart';
import 'package:brando_app/views/details/detail_screen.dart';
import 'package:brando_app/views/home/qrscanner.dart';
import 'package:brando_app/views/location/location_screen.dart';
import 'package:brando_app/views/navbar/navbar_screen.dart';
import 'package:brando_app/views/notifications/notification_screen.dart';
import 'package:brando_app/views/search/search_screen.dart';
import 'package:brando_app/views/seeall/see_all_screen.dart';
import 'package:brando_app/widgets/app_back_control.dart';
import 'package:brando_app/widgets/category_widget.dart';
import 'package:brando_app/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
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
  bool _isFetchingLocation = false;

  String _searchHintHostelName = 'Hostel';
  int _hintIndex = 0;
  Timer? _hintTimer;

  bool _locationPermissionDenied = false;
  bool _locationServiceDisabled = false;

  bool _isDialogOpen = false;
  bool _isExiting = false;


  void _startHintCycling(List<String> names) {
    _hintTimer?.cancel();
    if (names.isEmpty) return;

    _hintTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() {
        _hintIndex = (_hintIndex + 1) % names.length;
        _searchHintHostelName = names[_hintIndex];
      });
    });
  }

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<String> _carouselImages = [];
  bool _isLoadingBanner = true;

  String _currentAddress = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    fetchBanners();
    _fetchCurrentLocation();
    _loadInitialHostels();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CategoryProvider>().fetchCategories();
        context.read<WishlistProvider>().fetchWishlist();
        context.read<ProfileProvider>().fetchProfile();
      }
    });
  }

  Future<void> _handleRefresh() async {
    await Future.wait([
      fetchBanners(),
      _fetchCurrentLocation(),
      _refreshHostels(),
      context.read<CategoryProvider>().fetchCategories(),
    ]);
  }

  Future<void> _refreshHostels() async {
    final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
    await hostelProvider.fetchNearbyHostels();

    if (mounted && hostelProvider.hostels.isNotEmpty) {
      final names = hostelProvider.hostels
          .map((h) => h.name as String)
          .toList();
      setState(() => _searchHintHostelName = names.first);
      _startHintCycling(names);
    }
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _currentAddress = 'Fetching location...';
      _locationPermissionDenied = false;
      _locationServiceDisabled = false;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationServiceDisabled = true;
          _currentAddress = 'Location off';
          _isFetchingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationPermissionDenied = true;
            _currentAddress = 'Permission denied';
            _isFetchingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationPermissionDenied = true;
          _currentAddress = 'Permission denied';
          _isFetchingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _getAddressFromLatLng(position.latitude, position.longitude);

      if (mounted) {
        final hostelProvider = Provider.of<HostelProvider>(
          context,
          listen: false,
        );
        hostelProvider.updateLocationAndFetch(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      debugPrint("Location fetch error: $e");
      setState(() {
        _currentAddress = 'Could not fetch location';
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        final List<String> parts = [
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality!,
          if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.isNotEmpty)
            place.subAdministrativeArea!,
        ];

        final String address = parts.isNotEmpty
            ? parts.take(3).join(', ')
            : '${place.administrativeArea ?? ''}, ${place.country ?? ''}';

        setState(() {
          _currentAddress = address.isNotEmpty ? address : 'Location found';
          _isFetchingLocation = false;
        });
      } else {
        setState(() {
          _currentAddress = 'Location found';
          _isFetchingLocation = false;
        });
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
      setState(() {
        _currentAddress = 'Location found';
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _loadInitialHostels() async {
    final userId = AppPreferences.getUserId();
    if (userId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hostelProvider = Provider.of<HostelProvider>(
        context,
        listen: false,
      );
      await hostelProvider.fetchNearbyHostels();

      if (mounted && hostelProvider.hostels.isNotEmpty) {
        final names = hostelProvider.hostels
            .map((h) => h.name as String)
            .toList();
        setState(() => _searchHintHostelName = names.first);
        _startHintCycling(names);
      }
    });
  }

  Future<void> fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse("http://187.127.146.52:2003/api/Admin/getAllBanners"),
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

  Future<void> _openLocationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationScreen()),
    );

    if (result != null && result is Map && mounted) {
      final address = result['address'] as String?;

      setState(() {
        if (address != null && address.isNotEmpty) {
          final parts = address.split(',');
          _currentAddress = parts.length > 2
              ? '${parts[0].trim()}, ${parts[1].trim()}, ${parts[2].trim()}...'
              : parts.length > 1
              ? '${parts[0].trim()}, ${parts[1].trim()}...'
              : address;
        }
      });

      final hostelProvider = Provider.of<HostelProvider>(
        context,
        listen: false,
      );
      hostelProvider.setTypeFilter(_isAC ? 'AC' : 'NON-AC');
    }
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

return AppBackControl(
        showConfirmationDialog: true,
      dialogTitle: 'Exit App?',
      dialogMessage: 'Are you sure you want to exit the app?',
      confirmText: 'Exit',
      cancelText: 'Stay',
      onBackPressed: () {
        print('User exiting app');
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  _buildCarouselBanner(),
                  const SizedBox(height: 20),
                  const CategoryWidget(scrollDirection: Axis.horizontal),
                  _buildRecommendedSection(),
                  _buildHostelList(),
                  _buildNearbySection(),
                  _buildRecList(),
                  // const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductBannerWidget(),
                  ),
                                    const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final profile = profileProvider.profile;
        final displayName = profile?.name ?? 'Guest';
        final profileImageUrl = profile?.profileImage;

        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile screen
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child:
                              profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? Image.network(
                                  profileImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildProfilePlaceholder(
                                      displayName,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                )
                              : _buildProfilePlaceholder(displayName),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _openLocationScreen,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _currentAddress,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QRScannerScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 8),
                    // GestureDetector(
                    //   onTap: () {
                    //     Provider.of<ThemeProvider>(
                    //       context,
                    //       listen: false,
                    //     ).toggleTheme();
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white.withOpacity(0.2),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Icon(
                    //       isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    //       size: 20,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${displayName.split(' ').first} 👋',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Discover hostels, BHKs & RK rooms around you.',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'Search for "$_searchHintHostelName"',
                            hintStyle: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : Colors.grey.shade600,
                              size: 25,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isAC = !_isAC;
                                });
                                final hostelProvider =
                                    Provider.of<HostelProvider>(
                                      context,
                                      listen: false,
                                    );
                                hostelProvider.setTypeFilter(
                                  _isAC ? 'AC' : 'NON-AC',
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.success,
                                    content: Text(
                                      _isAC
                                          ? "Room preference updated to AC successfully."
                                          : "Room preference updated to Non-AC successfully.",
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _isAC
                                      ? AppColors.primary
                                      : isDarkMode
                                      ? AppColors.darkSurface
                                      : Colors.grey.shade200,
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
                                          : isDarkMode
                                          ? AppColors.darkTextSecondary
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _isAC ? 'AC' : 'Non-AC',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _isAC
                                            ? Colors.white
                                            : isDarkMode
                                            ? AppColors.darkTextSecondary
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfilePlaceholder(String displayName) {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Text(
          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
            height: 120,
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
                  fit: BoxFit.fill,
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
      ],
    );
  }

  Widget _buildRecommendedSection() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.darkText : AppColors.lightText,
              ),
              children: const [TextSpan(text: 'Recommended ')],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeeAllScreen()),
              );
            },
            child: Text(
              'See all',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbySection() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.darkText : AppColors.lightText,
              ),
              children: const [TextSpan(text: 'Nearby ')],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeeAllScreen()),
              );
            },
            child: Text(
              'See all',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostelList() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    if (_locationPermissionDenied || _locationServiceDisabled) {
      return _buildLocationPermissionScreen();
    }
    return Consumer<HostelProvider>(
      builder: (context, hostelProvider, _) {
        if (hostelProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (hostelProvider.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_qh5z2fdq.json',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    repeat: true,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.error_outline,
                      color: AppColors.error.withOpacity(0.5),
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => hostelProvider.fetchRecoHostels(),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text(
                        'Refresh',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (hostelProvider.recommendedHostels.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                    'https://assets10.lottiefiles.com/packages/lf20_hl5n0bwb.json',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    repeat: true,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.apartment_outlined,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade400,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No Hostels Found Nearby',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We couldn\'t find any hostels around your\ncurrent location. Try changing it!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _openLocationScreen,
                    icon: const Icon(Icons.location_on, size: 16),
                    label: const Text(
                      'Change Location',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: hostelProvider.recommendedHostels
              .map((hostel) => _buildHostelCard(hostel))
              .toList(),
        );
      },
    );
  }

  Widget _buildRecList() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    if (_locationPermissionDenied || _locationServiceDisabled) {
      return _buildLocationPermissionScreen();
    }
    return Consumer<HostelProvider>(
      builder: (context, hostelProvider, _) {
        if (hostelProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (hostelProvider.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_qh5z2fdq.json',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    repeat: true,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.error_outline,
                      color: AppColors.error.withOpacity(0.5),
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => hostelProvider.fetchNearbyHostels(),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text(
                        'Refresh',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (hostelProvider.hostels.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                    'https://assets10.lottiefiles.com/packages/lf20_hl5n0bwb.json',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    repeat: true,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.apartment_outlined,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade400,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No Hostels Found Nearby',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We couldn\'t find any hostels around your\ncurrent location. Try changing it!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _openLocationScreen,
                    icon: const Icon(Icons.location_on, size: 16),
                    label: const Text(
                      'Change Location',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: hostelProvider.hostels
              .map((hostel) => _buildHostelCard(hostel))
              .toList(),
        );
      },
    );
  }

  Widget _buildLocationPermissionScreen() {
    final bool isServiceOff = _locationServiceDisabled;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.network(
            isServiceOff
                ? 'https://assets4.lottiefiles.com/packages/lf20_UJNc2t.json'
                : 'https://assets9.lottiefiles.com/packages/lf20_qwL4Ajt1zX.json',
            width: 240,
            height: 240,
            fit: BoxFit.contain,
            repeat: true,
            errorBuilder: (_, __, ___) => Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_myejiggj.json',
              width: 240,
              height: 240,
              repeat: true,
              errorBuilder: (_, __, ___) => Icon(
                Icons.location_off_rounded,
                size: 80,
                color: AppColors.error.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isServiceOff ? 'Location Is Turned Off' : 'Location Access Needed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.darkText : AppColors.lightText,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isServiceOff
                ? 'Please enable location services on your device so we can find hostels near you.'
                : 'We need your location to show nearby hostels.\nTap below to grant access.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? AppColors.darkTextSecondary : Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isServiceOff
                  ? () async {
                      await Geolocator.openLocationSettings();
                    }
                  : () async {
                      if (_locationPermissionDenied) {
                        await Geolocator.openAppSettings();
                      } else {
                        await _fetchCurrentLocation();
                      }
                    },
              icon: Icon(
                isServiceOff ? Icons.settings : Icons.my_location_rounded,
                size: 18,
              ),
              label: Text(
                isServiceOff ? 'Open Location Settings' : 'Enable Location',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _openLocationScreen,
            icon: const Icon(Icons.search, size: 16, color: AppColors.primary),
            label: Text(
              'Search a location manually',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHostelCard(dynamic hostel) {
    final bool isHostelModel = hostel is! Map;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final String hostelId = isHostelModel ? hostel.id : (hostel['_id'] ?? '');
    final String name = isHostelModel
        ? hostel.name
        : (hostel['name'] ?? 'Unknown');
    final String rating = isHostelModel
        ? hostel.rating.toString()
        : (hostel['rating'] ?? '0').toString();
    final String location = isHostelModel
        ? hostel.address
        : (hostel['location'] ?? '');
    final List allShares = isHostelModel
        ? hostel.sharings
        : (hostel['shares'] ?? []);
    final String firstImage = isHostelModel && hostel.images.isNotEmpty
        ? hostel.images[0]
        : '';

    final String selectedType = _isAC ? 'AC' : 'Non-AC';
    final List filteredShares = allShares.where((share) {
      final String shareType = isHostelModel
          ? (share.type ?? '')
          : (share['type'] ?? '');
      return shareType == selectedType;
    }).toList();

    final List displayShares = filteredShares.isNotEmpty
        ? filteredShares
        : allShares;
final PageController _pageController = PageController();
int _currentPage = 0;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(hostelId: hostelId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.shade200,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// In your State class


// In your build widget
ClipRRect(
  child: hostel.images.isNotEmpty
      ? SizedBox(
          width: 120,
          height: 130,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: hostel.images.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    hostel.images[index],
                    width: 120,
                    height: 130,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
                  );
                },
              ),

              // Dot indicators at the bottom
// Dot indicators at the bottom
Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: Container(
    padding: const EdgeInsets.only(bottom: 4, top: 12),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.black.withOpacity(0.35),
          Colors.transparent,
        ],
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(hostel.images.length, (index) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 3,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      }),
    ),
  ),
),
            ],
          ),
        )
      : Image.asset(
          'assets/hotelimage.png',
          width: 120,
          height: 130,
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => _placeholderImage(),
        ),
),
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
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: name.split(' ').length > 1
                                          ? name.split(' ')[1]
                                          : '',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? AppColors.darkText
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Selector<WishlistProvider, bool>(
                            //   selector: (_, provider) =>
                            //       provider.isWishlisted(hostelId),
                            //   builder: (context, wishlisted, _) {
                            //     return GestureDetector(
                            //       onTap: hostelId.isEmpty
                            //           ? null
                            //           : () {
                            //               final wishlistProvider = context
                            //                   .read<WishlistProvider>();
                            //               final isCurrentlyWishlisted =
                            //                   wishlistProvider.isWishlisted(
                            //                     hostelId,
                            //                   );
                            //               wishlistProvider.toggleWishlist(
                            //                 hostelId,
                            //               );

                            //               ToastHelper.show(
                            //                 context,
                            //                 message: isCurrentlyWishlisted
                            //                     ? 'Removed from your wishlist'
                            //                     : '❤️  Added to wishlist — $name',
                            //                 type: isCurrentlyWishlisted
                            //                     ? ToastType.warning
                            //                     : ToastType.success,
                            //               );
                            //             },
                            //       child: AnimatedSwitcher(
                            //         duration: const Duration(milliseconds: 300),
                            //         transitionBuilder: (child, animation) =>
                            //             ScaleTransition(
                            //               scale: animation,
                            //               child: child,
                            //             ),
                            //         child: Icon(
                            //           wishlisted
                            //               ? Icons.favorite
                            //               : Icons.favorite_border,
                            //           key: ValueKey(wishlisted),
                            //           color: wishlisted
                            //               ? AppColors.error
                            //               : isDarkMode
                            //               ? AppColors.darkTextSecondary
                            //               : Colors.grey.shade400,
                            //           size: 22,
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildRatingBadge(rating),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _isAC
                                    ? Colors.blue.shade50
                                    : isDarkMode
                                    ? AppColors.darkSurface
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _isAC
                                      ? Colors.blue.shade200
                                      : isDarkMode
                                      ? AppColors.darkBorder
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                _isAC ? 'AC' : 'Non-AC',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _isAC
                                      ? Colors.blue
                                      : isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.purple.shade200,
                                ),
                              ),
                              child: Text(
                                hostel.categoryId.name,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ),
                            if (filteredShares.isEmpty) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.orange.shade300,
                                  ),
                                ),
                                child: Text(
                                  'N/A',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade700,
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
                            Icon(
                              Icons.location_on,
                              color: AppColors.secondary,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: displayShares.map<Widget>((share) {
                              final String label = isHostelModel
                                  ? share.shareType
                                  : (share['shareType'] ??
                                        share['label'] ??
                                        '');
                              final int monthlyPrice = isHostelModel
                                  ? share.monthlyPrice
                                  : (share['monthlyPrice'] ?? 0);
                              final String priceText = '₹$monthlyPrice/-';

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppColors.primary.withOpacity(0.2)
                                        : AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? AppColors.primary.withOpacity(0.3)
                                          : AppColors.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode
                                              ? AppColors.darkTextSecondary
                                              : Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        priceText,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
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
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
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
                      onPressed: () => _openWhatsApp("919961593179"),
                      icon: Image.asset(
                        'assets/whatsapp.png',
                        width: 18,
                        height: 18,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.chat,
                          size: 14,
                          color: AppColors.success,
                        ),
                      ),
                      label: Text(
                        'Whatsapp',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? AppColors.darkText : Colors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        side: BorderSide(
                          color: isDarkMode
                              ? AppColors.darkBorder
                              : Colors.grey.shade400,
                        ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(
                              hostelLatitude: isHostelModel
                                  ? hostel.location.latitude
                                  : null,
                              hostelLongitude: isHostelModel
                                  ? hostel.location.longitude
                                  : null,
                              hostelName: name,
                              hostelAddress: location,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? AppColors.darkText : Colors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
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
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      width: 120,
      height: 130,
      color: isDarkMode ? AppColors.darkSurface : Colors.grey.shade300,
      child: Icon(
        Icons.hotel,
        size: 40,
        color: isDarkMode ? AppColors.darkTextSecondary : Colors.grey,
      ),
    );
  }

  Widget _buildRatingBadge(String rating) {
    final double ratingValue = double.tryParse(rating) ?? 0;
    final Color color = ratingValue >= 4
        ? AppColors.success
        : ratingValue >= 3
        ? Colors.orange
        : AppColors.error;

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
