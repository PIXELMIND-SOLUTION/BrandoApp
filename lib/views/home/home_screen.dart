// import 'dart:async';
// import 'dart:convert';
// import 'package:brando_app/helper/shared_preference.dart';
// import 'package:brando_app/provider/location/location_provider.dart';
// import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
// import 'package:brando_app/views/Map/map_screen.dart';
// import 'package:brando_app/views/details/detail_screen.dart';
// import 'package:brando_app/views/location/location_screen.dart';
// import 'package:brando_app/views/notifications/notification_screen.dart';
// import 'package:brando_app/views/search/search_screen.dart';
// import 'package:brando_app/views/seeall/see_all_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
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
//         context.read<WishlistProvider>().fetchWishlist();
//       }
//     });
//   }

//   // ─── Location ─────────────────────────────────────────────────────────────

//   Future<void> _fetchCurrentLocation() async {
//     setState(() {
//       _isFetchingLocation = true;
//       _currentAddress = 'Fetching location...';
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         setState(() {
//           _currentAddress = 'Location services disabled';
//           _isFetchingLocation = false;
//         });
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _currentAddress = 'Location permission denied';
//             _isFetchingLocation = false;
//           });
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _currentAddress = 'Location permission permanently denied';
//           _isFetchingLocation = false;
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

//   // Future<void> _loadInitialHostels() async {
//   //   final userId = AppPreferences.getUserId();
//   //   if (userId == null) return;

//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     final hostelProvider = Provider.of<HostelProvider>(
//   //       context,
//   //       listen: false,
//   //     );
//   //     hostelProvider.fetchNearbyHostels();
//   //   });
//   // }

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
//         Uri.parse("http://31.97.206.144:2003/api/Admin/getAllBanners"),
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
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
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

//   // ─── Build ─────────────────────────────────────────────────────────────────

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
//               _buildHostelList(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ─── Top Bar ───────────────────────────────────────────────────────────────

//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: _fetchCurrentLocation,
//             child: _isFetchingLocation
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(
//                       color: Colors.red,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Icon(Icons.location_on, color: Colors.red, size: 18),
//           ),
//           const SizedBox(width: 4),
//           Expanded(
//             child: GestureDetector(
//               onTap: _openLocationScreen,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Location',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 46, 46, 46),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           _currentAddress,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const Icon(Icons.arrow_drop_down, size: 20),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               FlutterSwitch(
//                 width: 80,
//                 height: 30,
//                 valueFontSize: 10,
//                 toggleSize: 24,
//                 value: _isAC,
//                 borderRadius: 20,
//                 activeText: 'AC',
//                 inactiveText: 'Non-AC',
//                 showOnOff: true,
//                 activeColor: Colors.red,
//                 inactiveColor: Colors.grey.shade400,
//                 onToggle: (val) {
//                   setState(() => _isAC = val);

//                   final hostelProvider = Provider.of<HostelProvider>(
//                     context,
//                     listen: false,
//                   );
//                   hostelProvider.setTypeFilter(val ? 'AC' : 'NON-AC');

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: Colors.green,
//                       content: Text(
//                         val
//                             ? "Room preference updated to AC successfully."
//                             : "Room preference updated to Non-AC successfully.",
//                       ),
//                       duration: const Duration(seconds: 2),
//                     ),
//                   );
//                 },
//               ),
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

//   // ─── Search Bar ────────────────────────────────────────────────────────────

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
//           readOnly: true,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SearchScreen()),
//             );
//           },
//           decoration: InputDecoration(
//             hintText: 'Search for "$_searchHintHostelName"',
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
//                   errorBuilder: (context, error, stackTrace) =>
//                       const SizedBox(),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 8),
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

//   Widget _buildHostelList() {
//     return Consumer<HostelProvider>(
//       builder: (context, hostelProvider, _) {
//         if (hostelProvider.isLoading) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 40),
//             child: Center(child: CircularProgressIndicator(color: Colors.red)),
//           );
//         }

//         if (hostelProvider.hasError) {
//           return Padding(
//             padding: const EdgeInsets.all(24),
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     color: Colors.red.shade300,
//                     size: 48,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     hostelProvider.errorMessage ?? 'Something went wrong.',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.grey, fontSize: 14),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => hostelProvider.fetchNearbyHostels(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Retry',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (hostelProvider.hostels.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.apartment_outlined,
//                     color: Colors.grey.shade400,
//                     size: 64,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'No hostels found nearby.',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Try changing your location to discover hostels.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 13, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: _openLocationScreen,
//                     icon: const Icon(Icons.location_on, size: 16),
//                     label: const Text('Change Location'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
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
//     final String type = '';
//     final List shares = isHostelModel
//         ? hostel.sharings
//         : (hostel['shares'] ?? []);
//     final String firstImage = isHostelModel && hostel.images.isNotEmpty
//         ? hostel.images[0]
//         : '';

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
//                             // Hostel name
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
//                                   onTap: hostelId.isEmpty
//                                       ? null
//                                       : () {
//                                           context
//                                               .read<WishlistProvider>()
//                                               .toggleWishlist(hostelId);
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

//                         // ── Rating + Type ─────────────────────────────────
//                         Row(
//                           children: [
//                             _buildRatingBadge(rating),
//                             if (type.isNotEmpty) ...[
//                               const SizedBox(width: 6),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 6,
//                                   vertical: 2,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: type == 'AC'
//                                       ? Colors.blue.shade50
//                                       : Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(4),
//                                   border: Border.all(
//                                     color: type == 'AC'
//                                         ? Colors.blue.shade200
//                                         : Colors.grey.shade300,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   type,
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w600,
//                                     color: type == 'AC'
//                                         ? Colors.blue
//                                         : Colors.grey.shade600,
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

//                         // ── Sharing Prices ────────────────────────────────
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: shares.map<Widget>((share) {
//                               final label = isHostelModel
//                                   ? share.shareType
//                                   : share['label'];
//                               // final price = isHostelModel
//                               //     ? '₹${_isAC ? share.acMonthlyPrice : share.nonAcMonthlyPrice}/-'
//                               //     : share['price'];

//                               final price = isHostelModel
//                                   ? '₹${share.monthlyPrice}/-' // ← was using acMonthlyPrice/nonAcMonthlyPrice
//                                   : share['price'];
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 6),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       label,
//                                       style: const TextStyle(
//                                         fontSize: 8,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     Text(
//                                       price,
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

//             // ── Action Buttons ────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _makePhoneCall("9961593179"),
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
//                       onPressed: () => _openWhatsApp("919961593179"),
//                       icon: Image.asset(
//                         'assets/whatsapp.png',
//                         width: 18,
//                         height: 18,
//                         errorBuilder: (_, __, ___) => const Icon(
//                           Icons.chat,
//                           size: 14,
//                           color: Colors.green,
//                         ),
//                       ),
//                       label: const Text(
//                         'Whatsapp',
//                         style: TextStyle(fontSize: 12, color: Colors.black),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: const Color(0xFFF80500),
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
//                       onPressed: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => LocationScreen(),
//                         //   ),
//                         // );

//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MapScreen(
//                               hostelLatitude: isHostelModel
//                                   ? hostel.location.latitude
//                                   : null,
//                               hostelLongitude: isHostelModel
//                                   ? hostel.location.longitude
//                                   : null,
//                               hostelName: name,
//                               hostelAddress: location,
//                               // hostelLatitude:  isHostelModel ? hostel.latitude  : null,
//                               // hostelLongitude: isHostelModel ? hostel.longitude : null,
//                               // hostelName:    name,
//                               // hostelAddress: location,
//                             ),
//                           ),
//                         );
//                       },
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

// ignore_for_file: unnecessary_cast

// import 'dart:async';
// import 'dart:convert';
// import 'package:brando_app/helper/shared_preference.dart';
// import 'package:brando_app/provider/location/location_provider.dart';
// import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
// import 'package:brando_app/views/Map/map_screen.dart';
// import 'package:brando_app/views/details/detail_screen.dart';
// import 'package:brando_app/views/location/location_screen.dart';
// import 'package:brando_app/views/notifications/notification_screen.dart';
// import 'package:brando_app/views/search/search_screen.dart';
// import 'package:brando_app/views/seeall/see_all_screen.dart';
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
//         context.read<WishlistProvider>().fetchWishlist();
//       }
//     });
//   }

//   Future<void> _handleRefresh() async {
//     await Future.wait([
//       fetchBanners(),
//       _fetchCurrentLocation(),
//       _refreshHostels(),
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
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         setState(() {
//           _currentAddress = 'Location services disabled';
//           _isFetchingLocation = false;
//         });
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _currentAddress = 'Location permission denied';
//             _isFetchingLocation = false;
//           });
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _currentAddress = 'Location permission permanently denied';
//           _isFetchingLocation = false;
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
//           child: RefreshIndicator(
//             color: Colors.red,
//             onRefresh: _handleRefresh,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTopBar(),
//                   _buildSearchBar(context),
//                   _buildCarouselBanner(),
//                   _buildRecommendedSection(),
//                   _buildHostelList(),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ─── Top Bar ───────────────────────────────────────────────────────────────

//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: _fetchCurrentLocation,
//             child: _isFetchingLocation
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(
//                       color: Colors.red,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Icon(Icons.location_on, color: Colors.red, size: 18),
//           ),
//           const SizedBox(width: 4),
//           Expanded(
//             child: GestureDetector(
//               onTap: _openLocationScreen,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Location',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 46, 46, 46),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           _currentAddress,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const Icon(Icons.arrow_drop_down, size: 20),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               FlutterSwitch(
//                 width: 80,
//                 height: 30,
//                 valueFontSize: 10,
//                 toggleSize: 24,
//                 value: _isAC,
//                 borderRadius: 20,
//                 activeText: 'AC',
//                 inactiveText: 'Non-AC',
//                 showOnOff: true,
//                 activeColor: Colors.red,
//                 inactiveColor: Colors.grey.shade400,

//                 // onToggle: (val) {
//                 //   setState(() => _isAC = val);

//                 //   final hostelProvider = Provider.of<HostelProvider>(
//                 //     context,
//                 //     listen: false,
//                 //   );
//                 //   hostelProvider.setTypeFilter(val ? 'AC' : 'NON-AC');

//                 //   ScaffoldMessenger.of(context).showSnackBar(
//                 //     SnackBar(
//                 //       backgroundColor: Colors.green,
//                 //       content: Text(
//                 //         val
//                 //             ? "Room preference updated to AC successfully."
//                 //             : "Room preference updated to Non-AC successfully.",
//                 //       ),
//                 //       duration: const Duration(seconds: 2),
//                 //     ),
//                 //   );
//                 // },
//                 onToggle: (val) {
//                   setState(() => _isAC = val);

//                   final hostelProvider = Provider.of<HostelProvider>(
//                     context,
//                     listen: false,
//                   );
//                   hostelProvider.setTypeFilter(val ? 'AC' : 'NON-AC');

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: Colors.green,
//                       content: Text(
//                         val
//                             ? "Room preference updated to AC successfully."
//                             : "Room preference updated to Non-AC successfully.",
//                       ),
//                       duration: const Duration(seconds: 2),
//                     ),
//                   );
//                 },
//               ),
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

//   // ─── Search Bar ────────────────────────────────────────────────────────────

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
//           readOnly: true,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SearchScreen()),
//             );
//           },
//           decoration: InputDecoration(
//             hintText: 'Search for "$_searchHintHostelName"',
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
//                   errorBuilder: (context, error, stackTrace) =>
//                       const SizedBox(),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 8),
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

//   Widget _buildHostelList() {
//     return Consumer<HostelProvider>(
//       builder: (context, hostelProvider, _) {
//         if (hostelProvider.isLoading) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 40),
//             child: Center(child: CircularProgressIndicator(color: Colors.red)),
//           );
//         }

//         if (hostelProvider.hasError) {
//           return Padding(
//             padding: const EdgeInsets.all(24),
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     color: Colors.red.shade300,
//                     size: 48,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     hostelProvider.errorMessage ?? 'Something went wrong.',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.grey, fontSize: 14),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => hostelProvider.fetchNearbyHostels(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Retry',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         // ── Empty State with Lottie ──────────────────────────────────────────
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
//                     // Fallback if network fails:
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

//   // Widget _buildHostelList() {
//   //   return Consumer<HostelProvider>(
//   //     builder: (context, hostelProvider, _) {
//   //       if (hostelProvider.isLoading) {
//   //         return const Padding(
//   //           padding: EdgeInsets.symmetric(vertical: 40),
//   //           child: Center(child: CircularProgressIndicator(color: Colors.red)),
//   //         );
//   //       }

//   //       if (hostelProvider.hasError) {
//   //         return Padding(
//   //           padding: const EdgeInsets.all(24),
//   //           child: Center(
//   //             child: Column(
//   //               children: [
//   //                 Icon(
//   //                   Icons.error_outline,
//   //                   color: Colors.red.shade300,
//   //                   size: 48,
//   //                 ),
//   //                 const SizedBox(height: 12),
//   //                 Text(
//   //                   hostelProvider.errorMessage ?? 'Something went wrong.',
//   //                   textAlign: TextAlign.center,
//   //                   style: const TextStyle(color: Colors.grey, fontSize: 14),
//   //                 ),
//   //                 const SizedBox(height: 16),
//   //                 ElevatedButton(
//   //                   onPressed: () => hostelProvider.fetchNearbyHostels(),
//   //                   style: ElevatedButton.styleFrom(
//   //                     backgroundColor: Colors.red,
//   //                     shape: RoundedRectangleBorder(
//   //                       borderRadius: BorderRadius.circular(8),
//   //                     ),
//   //                   ),
//   //                   child: const Text(
//   //                     'Retry',
//   //                     style: TextStyle(color: Colors.white),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         );
//   //       }

//   //       if (hostelProvider.hostels.isEmpty) {
//   //         return Padding(
//   //           padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//   //           child: Center(
//   //             child: Column(
//   //               children: [
//   //                 Icon(
//   //                   Icons.apartment_outlined,
//   //                   color: Colors.grey.shade400,
//   //                   size: 64,
//   //                 ),
//   //                 const SizedBox(height: 16),
//   //                 const Text(
//   //                   'No hostels found nearby.',
//   //                   style: TextStyle(
//   //                     fontSize: 16,
//   //                     fontWeight: FontWeight.w500,
//   //                     color: Colors.grey,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 8),
//   //                 const Text(
//   //                   'Try changing your location to discover hostels.',
//   //                   textAlign: TextAlign.center,
//   //                   style: TextStyle(fontSize: 13, color: Colors.grey),
//   //                 ),
//   //                 const SizedBox(height: 20),
//   //                 ElevatedButton.icon(
//   //                   onPressed: _openLocationScreen,
//   //                   icon: const Icon(Icons.location_on, size: 16),
//   //                   label: const Text('Change Location'),
//   //                   style: ElevatedButton.styleFrom(
//   //                     backgroundColor: Colors.red,
//   //                     foregroundColor: Colors.white,
//   //                     shape: RoundedRectangleBorder(
//   //                       borderRadius: BorderRadius.circular(8),
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         );
//   //       }

//   //       return Column(
//   //         children: hostelProvider.hostels
//   //             .map((hostel) => _buildHostelCard(hostel))
//   //             .toList(),
//   //       );
//   //     },
//   //   );
//   // }

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
//     final String type = '';
//     final List shares = isHostelModel
//         ? hostel.sharings
//         : (hostel['shares'] ?? []);
//     final String firstImage = isHostelModel && hostel.images.isNotEmpty
//         ? hostel.images[0]
//         : '';

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
//                                   onTap: hostelId.isEmpty
//                                       ? null
//                                       : () {
//                                           context
//                                               .read<WishlistProvider>()
//                                               .toggleWishlist(hostelId);
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

//                         // ── Rating + Type ─────────────────────────────────
//                         Row(
//                           children: [
//                             _buildRatingBadge(rating),
//                             if (type.isNotEmpty) ...[
//                               const SizedBox(width: 6),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 6,
//                                   vertical: 2,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: type == 'AC'
//                                       ? Colors.blue.shade50
//                                       : Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(4),
//                                   border: Border.all(
//                                     color: type == 'AC'
//                                         ? Colors.blue.shade200
//                                         : Colors.grey.shade300,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   type,
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w600,
//                                     color: type == 'AC'
//                                         ? Colors.blue
//                                         : Colors.grey.shade600,
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

//                         // ── Sharing Prices ────────────────────────────────
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: shares.map<Widget>((share) {
//                               final label = isHostelModel
//                                   ? share.shareType
//                                   : share['label'];
//                               final price = isHostelModel
//                                   ? '₹${share.monthlyPrice}/-'
//                                   : share['price'];
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 6),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       label,
//                                       style: const TextStyle(
//                                         fontSize: 8,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     Text(
//                                       price,
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

//             // ── Action Buttons ────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//               child: Column(
//                 children: [
//                   // ── Row 1: Call | WhatsApp | Location ──────────────────
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

//                   const SizedBox(height: 6),

//                   // // ── Row 2: Book Now (full width) ────────────────────────
//                   // Selector<BookingProvider, BookingStatus>(
//                   //   selector: (_, provider) => provider.status,
//                   //   builder: (context, status, _) {
//                   //     final isLoading = status == BookingStatus.loading;
//                   //     return SizedBox(
//                   //       width: double.infinity,
//                   //       child: ElevatedButton.icon(
//                   //         onPressed: isLoading
//                   //             ? null
//                   //             : () => _handleBookNow(
//                   //                   hostelId: hostelId,
//                   //                   hostelName: name,
//                   //                 ),
//                   //         icon: isLoading
//                   //             ? const SizedBox(
//                   //                 width: 14,
//                   //                 height: 14,
//                   //                 child: CircularProgressIndicator(
//                   //                   color: Colors.white,
//                   //                   strokeWidth: 2,
//                   //                 ),
//                   //               )
//                   //             : const Icon(
//                   //                 Icons.book_online,
//                   //                 size: 14,
//                   //                 color: Colors.white,
//                   //               ),
//                   //         label: Text(
//                   //           isLoading ? 'Sending...' : 'Book Now',
//                   //           style: const TextStyle(
//                   //             fontSize: 13,
//                   //             color: Colors.white,
//                   //             fontWeight: FontWeight.w600,
//                   //           ),
//                   //         ),
//                   //         style: ElevatedButton.styleFrom(
//                   //           backgroundColor: const Color(0xFFF80500),
//                   //           disabledBackgroundColor:
//                   //               Colors.red.shade200,
//                   //           padding: const EdgeInsets.symmetric(vertical: 10),
//                   //           elevation: 0,
//                   //           shape: RoundedRectangleBorder(
//                   //             borderRadius: BorderRadius.circular(6),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     );
//                   //   },
//                   // ),
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
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/location/location_provider.dart';
import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
import 'package:brando_app/views/Map/map_screen.dart';
import 'package:brando_app/views/details/detail_screen.dart';
import 'package:brando_app/views/location/location_screen.dart';
import 'package:brando_app/views/notifications/notification_screen.dart';
import 'package:brando_app/views/search/search_screen.dart';
import 'package:brando_app/views/seeall/see_all_screen.dart';
import 'package:brando_app/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
        context.read<WishlistProvider>().fetchWishlist();
      }
    });
  }

  Future<void> _handleRefresh() async {
    await Future.wait([
      fetchBanners(),
      _fetchCurrentLocation(),
      _refreshHostels(),
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
          // _currentAddress = 'Location services disabled';
          // _isFetchingLocation = false;
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
            // _currentAddress = 'Location permission denied';
            // _isFetchingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationPermissionDenied = true;
          _currentAddress = 'Permission denied';
          _isFetchingLocation = false;
          // _currentAddress = 'Location permission permanently denied';
          // _isFetchingLocation = false;
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

  // ─── Actions ───────────────────────────────────────────────────────────────

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
    return WillPopScope(
      onWillPop: () async {
        if (_isDialogOpen) return false;

        _isDialogOpen = true;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        _isDialogOpen = false;

        if (shouldExit == true) {
          if (mounted) {
            SystemNavigator.pop();
          }
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.red,
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
        ),
      ),
    );
  }

  // ─── Top Bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: _fetchCurrentLocation,
            child: _isFetchingLocation
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.location_on, color: Colors.red, size: 18),
          ),
          const SizedBox(width: 4),
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

  // ─── Search Bar ────────────────────────────────────────────────────────────

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
            hintText: 'Search for "$_searchHintHostelName"',
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

  // ─── Carousel ──────────────────────────────────────────────────────────────

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

  // ─── Recommended Section ───────────────────────────────────────────────────

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

  // ─── Hostel List ───────────────────────────────────────────────────────────

  Widget _buildHostelList() {
    if (_locationPermissionDenied || _locationServiceDisabled) {
      return _buildLocationPermissionScreen();
    }
    return Consumer<HostelProvider>(
      builder: (context, hostelProvider, _) {
        if (hostelProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        }

        // if (hostelProvider.hasError) {
        //   return Padding(
        //     padding: const EdgeInsets.all(24),
        //     child: Center(
        //       child: Column(
        //         children: [
        //           Icon(
        //             Icons.error_outline,
        //             color: Colors.red.shade300,
        //             size: 48,
        //           ),
        //           const SizedBox(height: 12),
        //           Text(
        //             hostelProvider.errorMessage ?? 'Something went wrong.',
        //             textAlign: TextAlign.center,
        //             style: const TextStyle(color: Colors.grey, fontSize: 14),
        //           ),
        //           const SizedBox(height: 16),
        //           ElevatedButton(
        //             onPressed: () => hostelProvider.fetchNearbyHostels(),
        //             style: ElevatedButton.styleFrom(
        //               backgroundColor: Colors.red,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //             ),
        //             child: const Text(
        //               'Retry',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }

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
                      color: Colors.red.shade300,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // const Text(
                  //   'Oops! Something Went Wrong',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xFF2E2E2E),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  // Text(
                  //   hostelProvider.errorMessage ?? 'We couldn\'t load hostels.\nPlease try again.',
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 13,
                  //     height: 1.5,
                  //   ),
                  // ),
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
                        backgroundColor: Colors.red,
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
                      color: Colors.grey.shade400,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No Hostels Found Nearby',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We couldn\'t find any hostels around your\ncurrent location. Try changing it!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
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
                      backgroundColor: Colors.red,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lottie animation — GPS/location themed
          Lottie.network(
            isServiceOff
                ? 'https://assets4.lottiefiles.com/packages/lf20_UJNc2t.json' // GPS searching
                : 'https://assets9.lottiefiles.com/packages/lf20_qwL4Ajt1zX.json', // location pin
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
                color: Colors.red.shade300,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Title
          Text(
            isServiceOff ? 'Location Is Turned Off' : 'Location Access Needed',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle
          Text(
            isServiceOff
                ? 'Please enable location services on your device so we can find hostels near you.'
                : 'We need your location to show nearby hostels.\nTap below to grant access.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 28),

          // CTA Button
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
                backgroundColor: Colors.red,
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

          // Secondary: manual location pick
          TextButton.icon(
            onPressed: _openLocationScreen,
            icon: const Icon(Icons.search, size: 16, color: Colors.red),
            label: const Text(
              'Search a location manually',
              style: TextStyle(
                color: Colors.red,
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

  // ─── Hostel Card ───────────────────────────────────────────────────────────

  Widget _buildHostelCard(dynamic hostel) {
    final bool isHostelModel = hostel is! Map;

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

    // ── Filter sharings based on AC/Non-AC toggle ──────────────────────────
    final String selectedType = _isAC ? 'AC' : 'Non-AC';
    final List filteredShares = allShares.where((share) {
      final String shareType = isHostelModel
          ? (share.type ?? '')
          : (share['type'] ?? '');
      return shareType == selectedType;
    }).toList();

    // Fall back to all shares if none match the selected type
    final List displayShares = filteredShares.isNotEmpty
        ? filteredShares
        : allShares;

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
                // ── Hostel Image ──────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: firstImage.isNotEmpty
                      ? Image.network(
                          firstImage,
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

                // ── Card Details ──────────────────────────────────────────
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
                            Selector<WishlistProvider, bool>(
                              selector: (_, provider) =>
                                  provider.isWishlisted(hostelId),
                              builder: (context, wishlisted, _) {
                                return GestureDetector(
                                  // onTap: hostelId.isEmpty
                                  //     ? null
                                  //     : () {
                                  //         context
                                  //             .read<WishlistProvider>()
                                  //             .toggleWishlist(hostelId);
                                  //       },

                                  // Replace the onTap inside the Selector<WishlistProvider> block
                                  onTap: hostelId.isEmpty
                                      ? null
                                      : () {
                                          final wishlistProvider = context
                                              .read<WishlistProvider>();
                                          final isCurrentlyWishlisted =
                                              wishlistProvider.isWishlisted(
                                                hostelId,
                                              );
                                          wishlistProvider.toggleWishlist(
                                            hostelId,
                                          );

                                          ToastHelper.show(
                                            context,
                                            message: isCurrentlyWishlisted
                                                ? 'Removed from your wishlist'
                                                : '❤️  Added to wishlist — $name',
                                            type: isCurrentlyWishlisted
                                                ? ToastType.warning
                                                : ToastType.success,
                                          );
                                        },
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) =>
                                        ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                    child: Icon(
                                      wishlisted
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      key: ValueKey(wishlisted),
                                      color: wishlisted
                                          ? Colors.red
                                          : Colors.grey.shade400,
                                      size: 22,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // ── Rating + AC/Non-AC Badge ──────────────────────
                        Row(
                          children: [
                            _buildRatingBadge(rating),
                            const SizedBox(width: 6),
                            // Show current filter type as a badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _isAC
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _isAC
                                      ? Colors.blue.shade200
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
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            // Show "No AC" warning if hostel doesn't support selected type
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

                        // ── Address ───────────────────────────────────────
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

                        // ── Filtered Sharing Prices ───────────────────────
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
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.red.shade100,
                                    ),
                                  ),
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
                                        priceText,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.red,
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

            // ── Action Buttons ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                children: [
                  Row(
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
                          onPressed: () => _openWhatsApp("919961593179"),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

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
