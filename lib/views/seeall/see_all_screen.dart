// import 'dart:convert';
// import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
// import 'package:brando_app/views/Map/map_screen.dart';
// import 'package:brando_app/views/details/detail_screen.dart';
// import 'package:brando_app/views/search/search_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SeeAllScreen extends StatefulWidget {
//   const SeeAllScreen({super.key});

//   @override
//   State<SeeAllScreen> createState() => _SeeAllScreenState();
// }

// class _SeeAllScreenState extends State<SeeAllScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isAC = true;

//   List<Map<String, dynamic>> _categories = [];
//   Map<String, List<Map<String, dynamic>>> _hostelsByCategory = {};
//   bool _isLoadingCategories = true;
//   Set<String> _loadingCategoryIds = {};

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   static const String _baseUrl = 'http://187.127.146.52:2003/api';

//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//     _searchController.addListener(() {
//       setState(() => _searchQuery = _searchController.text.toLowerCase());
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchCategories() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/Admin/getallCategories'),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final cats = List<Map<String, dynamic>>.from(data['categories']);
//         setState(() {
//           _categories = cats;
//           _isLoadingCategories = false;
//           _tabController = TabController(length: cats.length, vsync: this);
//           _tabController.addListener(() {
//             if (!_tabController.indexIsChanging) {
//               _searchController.clear();
//               _onTabChanged(_tabController.index);
//             }
//           });
//         });
//         if (cats.isNotEmpty) {
//           _fetchHostelsForCategory(cats[0]['_id']);
//         }
//       }
//     } catch (e) {
//       setState(() => _isLoadingCategories = false);
//     }
//   }

//   Future<void> _fetchHostelsForCategory(String categoryId) async {
//     if (_hostelsByCategory.containsKey(categoryId)) return;
//     setState(() => _loadingCategoryIds.add(categoryId));
//     try {
//       final type = _isAC ? 'AC' : 'Non-AC';
//       final uri = Uri.parse(
//         '$_baseUrl/admin/hostelsbycategory?categoryId=$categoryId&type=$type',
//       );
//       final response = await http.get(uri);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final hostels = List<Map<String, dynamic>>.from(data['hostels'] ?? []);
//         setState(() {
//           _hostelsByCategory[categoryId] = hostels;
//           _loadingCategoryIds.remove(categoryId);
//         });
//       } else {
//         setState(() {
//           _hostelsByCategory[categoryId] = [];
//           _loadingCategoryIds.remove(categoryId);
//         });
//       }
//     } catch (_) {
//       setState(() {
//         _hostelsByCategory[categoryId] = [];
//         _loadingCategoryIds.remove(categoryId);
//       });
//     }
//   }

//   void _onTabChanged(int index) {
//     if (index < _categories.length) {
//       _fetchHostelsForCategory(_categories[index]['_id']);
//     }
//   }

//   Future<void> _refreshCurrentTab() async {
//     final index = _tabController.index;
//     if (index < _categories.length) {
//       final catId = _categories[index]['_id'];
//       _hostelsByCategory.remove(catId);
//       await _fetchHostelsForCategory(catId);
//     }
//   }

//   void _onACToggle(bool isAC) {
//     setState(() {
//       _isAC = isAC;
//       _hostelsByCategory.clear();
//     });
//     if (_categories.isNotEmpty) {
//       _fetchHostelsForCategory(_categories[_tabController.index]['_id']);
//     }
//   }

//   String _formatCategoryName(String rawName) {
//     return rawName
//         .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
//         .replaceAll('Pg', 'PG')
//         .replaceAll('Mens', "Men's")
//         .replaceAll('Womens', "Women's");
//   }

//   String _getSearchHint() {
//     if (_categories.isEmpty) return 'Search hostels...';
//     final index = _tabController.hasListeners ? _tabController.index : 0;
//     if (index >= _categories.length) return 'Search hostels...';

//     final catId = _categories[index]['_id'] as String;
//     final hostels = _hostelsByCategory[catId];

//     if (hostels == null || hostels.isEmpty) return 'Search hostels...';

//     final firstName = hostels[0]['name'] as String? ?? 'hostel';
//     return 'Search for "$firstName"';
//   }

//   String _formatPrice(dynamic price) {
//     final p = (price is int) ? price : (price as num?)?.toInt() ?? 0;
//     if (p >= 1000) {
//       final s = p.toString();
//       return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
//     }
//     return p.toString();
//   }

//   Future<void> _makePhoneCall(String phone) async {
//     final uri = Uri(scheme: 'tel', path: phone);
//     try {
//       await launchUrl(uri);
//     } catch (e) {
//       debugPrint('Could not launch phone call: $e');
//     }
//   }

//   Future<void> _openWhatsApp(String phone) async {
//     String cleaned = phone.replaceAll(RegExp(r'\D'), '');
//     if (!cleaned.startsWith('91') && cleaned.length == 10) {
//       cleaned = '91$cleaned';
//     }
//     final msg = Uri.encodeComponent('Hello, I am interested in your hostel.');
//     final url = Uri.parse('https://wa.me/$cleaned?text=$msg');
//     try {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } catch (e) {
//       debugPrint('Could not open WhatsApp: $e');
//     }
//   }

//   List<Map<String, dynamic>> _filteredHostels(String categoryId) {
//     final all = _hostelsByCategory[categoryId] ?? [];
//     if (_searchQuery.isEmpty) return all;
//     return all.where((h) {
//       final name = (h['name'] as String? ?? '').toLowerCase();
//       final address = (h['address'] as String? ?? '').toLowerCase();
//       return name.contains(_searchQuery) || address.contains(_searchQuery);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoadingCategories) {
//       return const Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: CircularProgressIndicator(color: Color(0xFFF80500)),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: const Text(
//           'Hostels',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildTopBar(),
//             _buildSearchBar(),
//             if (_categories.isNotEmpty) _buildTabBar(),
//             Expanded(
//               child: _categories.isEmpty
//                   ? const Center(child: Text('No categories found.'))
//                   : TabBarView(
//                       controller: _tabController,
//                       children: _categories.map((cat) {
//                         final catId = cat['_id'] as String;

//                         if (_loadingCategoryIds.contains(catId)) {
//                           return const Center(
//                             child: CircularProgressIndicator(
//                               color: Color(0xFFF80500),
//                             ),
//                           );
//                         }

//                         if (_hostelsByCategory.containsKey(catId)) {
//                           final filtered = _filteredHostels(catId);
//                           if (filtered.isEmpty) {
//                             return Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.search_off,
//                                     size: 56,
//                                     color: Colors.grey.shade300,
//                                   ),
//                                   const SizedBox(height: 12),
//                                   Text(
//                                     _searchQuery.isEmpty
//                                         ? 'No hostels found in this category.'
//                                         : 'No results for "$_searchQuery"',
//                                     style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 14,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return _buildHostelList(filtered, catId);
//                         }

//                         return const SizedBox.shrink();
//                       }).toList(),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           GestureDetector(
//             onTap: () => _onACToggle(!_isAC),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 250),
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _acToggleChip('AC', _isAC),
//                   _acToggleChip('Non AC', !_isAC),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _acToggleChip(String label, bool active) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: active ? Colors.black : Colors.transparent,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: active ? Colors.white : Colors.black54,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return AnimatedBuilder(
//       animation: _tabController,
//       builder: (context, _) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => SearchScreen()),
//               );
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.search, color: Colors.grey),
//                   const SizedBox(width: 10),
//                   Text(
//                     _getSearchHint(),
//                     style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTabBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: TabBar(
//           controller: _tabController,
//           indicator: BoxDecoration(
//             color: const Color(0xFFF80500),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           indicatorSize: TabBarIndicatorSize.tab,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.black87,
//           labelStyle: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 12,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 12,
//           ),
//           splashBorderRadius: BorderRadius.circular(30),
//           dividerColor: Colors.transparent,
//           isScrollable: _categories.length > 3,
//           tabs: _categories
//               .map(
//                 (cat) => Tab(text: _formatCategoryName(cat['name'] as String)),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildHostelList(List<Map<String, dynamic>> hostels, String catId) {
//     return RefreshIndicator(
//       color: const Color(0xFFF80500),
//       onRefresh: _refreshCurrentTab,
//       child: ListView.builder(
//         padding: const EdgeInsets.only(bottom: 20),
//         itemCount: hostels.length,
//         itemBuilder: (context, index) => _buildHostelCard(hostels[index]),
//       ),
//     );
//   }

//   // ── THE FIX: GestureDetector now wraps only the top row, not the entire card ──
//   Widget _buildHostelCard(Map<String, dynamic> hostel) {
//     final hostelId = hostel['_id'] as String? ?? '';
//     final name = hostel['name'] as String? ?? 'Hostel';
//     final rating = (hostel['rating'] ?? 0).toString();
//     final address = hostel['address'] as String? ?? '';
//     final imageUrl = (hostel['images'] as List?)?.isNotEmpty == true
//         ? hostel['images'][0] as String
//         : null;
//     final phone = hostel['phone'] as String? ?? '';
//     final latitude = hostel['latitude'] as double?;
//     final longitude = hostel['longitude'] as double?;

//     final rooms = hostel['rooms'] as Map<String, dynamic>?;
//     List<Map<String, String>> shares = [];
//     if (rooms != null) {
//       final allRooms = [
//         ...List<Map<String, dynamic>>.from(rooms['ac'] ?? []),
//         ...List<Map<String, dynamic>>.from(rooms['nonAc'] ?? []),
//       ];
//       shares = allRooms
//           .map(
//             (r) => {
//               'label': r['shareType'] as String? ?? '',
//               'price': '₹${_formatPrice(r['monthlyPrice'])}/-',
//             },
//           )
//           .toList();
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 8,
//             spreadRadius: 2,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Top section tappable → navigates to DetailScreen ──────────────
//           GestureDetector(
//             onTap: () {
//               if (hostelId.isNotEmpty) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => DetailScreen(hostelId: hostelId),
//                   ),
//                 );
//               }
//             },
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     bottomLeft: Radius.circular(12),
//                   ),
//                   child: imageUrl != null
//                       ? Image.network(
//                           imageUrl,
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

//                 // Details
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
//                                   children: [
//                                     TextSpan(
//                                       text: '${name.split(' ').first} ',
//                                       style: const TextStyle(
//                                         color: Color(0xFFF80500),
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: name.split(' ').length > 1
//                                           ? name.split(' ').sublist(1).join(' ')
//                                           : '',
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             // Wishlist heart — must stop propagation to parent GestureDetector
//                             Selector<WishlistProvider, bool>(
//                               selector: (_, p) => p.isWishlisted(hostelId),
//                               builder: (context, wishlisted, _) {
//                                 return GestureDetector(
//                                   onTap: hostelId.isEmpty
//                                       ? null
//                                       : () {
//                                           context
//                                               .read<WishlistProvider>()
//                                               .toggleWishlist(hostelId);
//                                         },
//                                   // Prevent the heart tap from bubbling up to the
//                                   // parent GestureDetector and triggering navigation
//                                   behavior: HitTestBehavior.opaque,
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
//                         _buildRatingBadge(rating),
//                         const SizedBox(height: 6),

//                         // Address
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
//                                 address,
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

//                         // Share price chips
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: shares.map<Widget>((share) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 6),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       share['label'] ?? '',
//                                       style: const TextStyle(
//                                         fontSize: 8,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     Text(
//                                       share['price'] ?? '',
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
//           ),

//           // ── Action buttons — outside GestureDetector, taps fire directly ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () => _makePhoneCall(phone),
//                     icon: const Icon(Icons.call, size: 14, color: Colors.white),
//                     label: const Text(
//                       'Call',
//                       style: TextStyle(fontSize: 12, color: Colors.white),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.red,
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () => _openWhatsApp(phone),
//                     icon: Image.asset(
//                       'assets/whatsapp.png',
//                       width: 18,
//                       height: 18,
//                       errorBuilder: (_, __, ___) =>
//                           const Icon(Icons.chat, size: 14, color: Colors.green),
//                     ),
//                     label: const Text(
//                       'Whatsapp',
//                       style: TextStyle(fontSize: 12, color: Colors.black),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: const Color(0xFFF80500),
//                       side: const BorderSide(
//                         color: Color.fromARGB(255, 141, 140, 140),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => MapScreen(
//                             hostelName: name,
//                             hostelAddress: address,
//                             hostelLatitude: latitude,
//                             hostelLongitude: longitude,
//                           ),
//                         ),
//                       );
//                     },
//                     icon: const Icon(
//                       Icons.location_on,
//                       size: 14,
//                       color: Colors.red,
//                     ),
//                     label: const Text(
//                       'Location',
//                       style: TextStyle(fontSize: 12, color: Colors.black),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red,
//                       side: const BorderSide(color: Colors.red),
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _placeholderImage() {
//     return Container(
//       width: 120,
//       height: 130,
//       color: Colors.grey.shade300,
//       child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
//     );
//   }

//   Widget _buildRatingBadge(String rating) {
//     final ratingValue = double.tryParse(rating) ?? 0;
//     final color = ratingValue >= 4
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
//         mainAxisSize: MainAxisSize.min,
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
import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
import 'package:brando_app/views/Map/map_screen.dart';
import 'package:brando_app/views/details/detail_screen.dart';
import 'package:brando_app/views/search/search_screen.dart';
import 'package:brando_app/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SeeAllScreen extends StatefulWidget {
  final String? selectedCategoryId;
  final String? selectedCategoryName;

  const SeeAllScreen({
    super.key,
    this.selectedCategoryId,
    this.selectedCategoryName,
  });

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all'; // 'all', 'ac', 'non-ac'

  List<Map<String, dynamic>> _categories = [];
  Map<String, List<Map<String, dynamic>>> _hostelsByCategory = {};
  bool _isLoadingCategories = true;
  Set<String> _loadingCategoryIds = {};

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const String _baseUrl = 'http://187.127.146.52:2003/api';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Admin/getallCategories'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cats = List<Map<String, dynamic>>.from(data['categories']);
        setState(() {
          _categories = cats;
          _isLoadingCategories = false;
          _tabController = TabController(
            length: cats.length,
            vsync: this,
            initialIndex: _getInitialTabIndex(cats),
          );
          _tabController.addListener(() {
            if (!_tabController.indexIsChanging) {
              _searchController.clear();
              _onTabChanged(_tabController.index);
            }
          });
        });
        if (cats.isNotEmpty) {
          final selectedIndex = _getInitialTabIndex(cats);
          await _fetchHostelsForCategory(cats[selectedIndex]['_id']);
        }
      } else {
        setState(() => _isLoadingCategories = false);
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      setState(() => _isLoadingCategories = false);
    }
  }

  int _getInitialTabIndex(List<Map<String, dynamic>> categories) {
    if (widget.selectedCategoryId != null) {
      final index = categories.indexWhere(
        (cat) => cat['_id'] == widget.selectedCategoryId,
      );
      if (index != -1) return index;
    }
    return 0;
  }

  Future<void> _fetchHostelsForCategory(String categoryId) async {
    if (_hostelsByCategory.containsKey(categoryId)) return;

    setState(() => _loadingCategoryIds.add(categoryId));

    try {
      String typeParam = '';
      if (_filterType == 'ac') {
        typeParam = 'AC';
      } else if (_filterType == 'non-ac') {
        typeParam = 'Non-AC';
      }

      final uri = Uri.parse(
        '$_baseUrl/admin/hostelsbycategory?categoryId=$categoryId&type=$typeParam',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> hostels = [];

        if (_filterType == 'all') {
          // Fetch both AC and Non-AC and combine
          final acUri = Uri.parse(
            '$_baseUrl/admin/hostelsbycategory?categoryId=$categoryId&type=AC',
          );
          final nonAcUri = Uri.parse(
            '$_baseUrl/admin/hostelsbycategory?categoryId=$categoryId&type=Non-AC',
          );

          final acResponse = await http.get(acUri);
          final nonAcResponse = await http.get(nonAcUri);

          if (acResponse.statusCode == 200) {
            final acData = jsonDecode(acResponse.body);
            hostels.addAll(
              List<Map<String, dynamic>>.from(acData['hostels'] ?? []),
            );
          }

          if (nonAcResponse.statusCode == 200) {
            final nonAcData = jsonDecode(nonAcResponse.body);
            hostels.addAll(
              List<Map<String, dynamic>>.from(nonAcData['hostels'] ?? []),
            );
          }
        } else {
          hostels = List<Map<String, dynamic>>.from(data['hostels'] ?? []);
        }

        setState(() {
          _hostelsByCategory[categoryId] = hostels;
          _loadingCategoryIds.remove(categoryId);
        });
      } else {
        setState(() {
          _hostelsByCategory[categoryId] = [];
          _loadingCategoryIds.remove(categoryId);
        });
      }
    } catch (e) {
      debugPrint('Error fetching hostels: $e');
      setState(() {
        _hostelsByCategory[categoryId] = [];
        _loadingCategoryIds.remove(categoryId);
      });
    }
  }

  void _onTabChanged(int index) {
    if (index < _categories.length) {
      _fetchHostelsForCategory(_categories[index]['_id']);
    }
  }

  Future<void> _refreshCurrentTab() async {
    final index = _tabController.index;
    if (index < _categories.length) {
      final catId = _categories[index]['_id'];
      _hostelsByCategory.remove(catId);
      await _fetchHostelsForCategory(catId);
    }
  }

  void _onFilterChange(String filterType) {
    setState(() {
      _filterType = filterType;
      _hostelsByCategory.clear();
    });
    if (_categories.isNotEmpty) {
      _fetchHostelsForCategory(_categories[_tabController.index]['_id']);
    }
  }

  String _formatCategoryName(String rawName) {
    return rawName
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .replaceAll('Pg', 'PG')
        .replaceAll('Mens', "Men's")
        .replaceAll('Womens', "Women's");
  }

  String _getSearchHint() {
    if (_categories.isEmpty) return 'Search hostels...';
    final index = _tabController.hasListeners ? _tabController.index : 0;
    if (index >= _categories.length) return 'Search hostels...';

    final catId = _categories[index]['_id'] as String;
    final hostels = _hostelsByCategory[catId];

    if (hostels == null || hostels.isEmpty) return 'Search hostels...';

    final firstName = hostels[0]['name'] as String? ?? 'hostel';
    return 'Search for "$firstName"';
  }

  String _formatPrice(dynamic price) {
    final p = (price is int) ? price : (price as num?)?.toInt() ?? 0;
    if (p >= 1000) {
      final s = p.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return p.toString();
  }

  Future<void> _makePhoneCall(String phone) async {
    if (phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('Could not launch phone call: $e');
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    if (phone.isEmpty) return;
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (!cleaned.startsWith('91') && cleaned.length == 10) {
      cleaned = '91$cleaned';
    }
    final msg = Uri.encodeComponent('Hello, I am interested in your hostel.');
    final url = Uri.parse('https://wa.me/$cleaned?text=$msg');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not open WhatsApp: $e');
    }
  }

  List<Map<String, dynamic>> _filteredHostels(String categoryId) {
    final all = _hostelsByCategory[categoryId] ?? [];
    if (_searchQuery.isEmpty) return all;
    return all.where((h) {
      final name = (h['name'] as String? ?? '').toLowerCase();
      final address = (h['address'] as String? ?? '').toLowerCase();
      return name.contains(_searchQuery) || address.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingCategories) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFF80500)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          widget.selectedCategoryName ?? 'Hostels',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _buildFilterBar(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            if (_categories.isNotEmpty) _buildTabBar(),
            Expanded(
              child: _categories.isEmpty
                  ? const Center(child: Text('No categories found.'))
                  : TabBarView(
                      controller: _tabController,
                      children: _categories.map((cat) {
                        final catId = cat['_id'] as String;

                        if (_loadingCategoryIds.contains(catId)) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFF80500),
                            ),
                          );
                        }

                        if (_hostelsByCategory.containsKey(catId)) {
                          final filtered = _filteredHostels(catId);
                          if (filtered.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 56,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _searchQuery.isEmpty
                                        ? 'No hostels found in this category.'
                                        : 'No results for "$_searchQuery"',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                          return _buildHostelList(filtered);
                        }

                        return const SizedBox.shrink();
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          _buildFilterChip('All', _filterType == 'all'),
          const SizedBox(width: 12),
          _buildFilterChip('AC', _filterType == 'ac'),
          const SizedBox(width: 12),
          _buildFilterChip('Non-AC', _filterType == 'non-ac'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        String filterType = 'all';
        if (label == 'AC') filterType = 'ac';
        if (label == 'Non-AC') filterType = 'non-ac';
        _onFilterChange(filterType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF80500) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SearchScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                _getSearchHint(),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: const Color(0xFFF80500),
            borderRadius: BorderRadius.circular(30),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black87,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          dividerColor: Colors.transparent,
          isScrollable: _categories.length > 3,
          tabs: _categories
              .map(
                (cat) => Tab(text: _formatCategoryName(cat['name'] as String)),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildHostelList(List<Map<String, dynamic>> hostels) {
    return RefreshIndicator(
      color: const Color(0xFFF80500),
      onRefresh: _refreshCurrentTab,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: hostels.length,
        itemBuilder: (context, index) => _buildHostelCard(hostels[index]),
      ),
    );
  }

  Widget _buildHostelCard(Map<String, dynamic> hostel) {
    final hostelId = hostel['_id'] as String? ?? '';
    final name = hostel['name'] as String? ?? 'Hostel';
    final rating = (hostel['rating'] ?? 0).toString();
    final address = hostel['address'] as String? ?? '';
    final imageUrl = (hostel['images'] as List?)?.isNotEmpty == true
        ? hostel['images'][0] as String
        : null;
    final phone = hostel['phone'] as String? ?? '';
    final latitude = hostel['latitude'] as double?;
    final longitude = hostel['longitude'] as double?;

    final rooms = hostel['rooms'] as Map<String, dynamic>?;
    List<Map<String, String>> shares = [];
    if (rooms != null) {
      final allRooms = [
        ...List<Map<String, dynamic>>.from(rooms['ac'] ?? []),
        ...List<Map<String, dynamic>>.from(rooms['nonAc'] ?? []),
      ];
      shares = allRooms
          .map(
            (r) => {
              'label': r['shareType'] as String? ?? '',
              'price': '₹${_formatPrice(r['monthlyPrice'])}/-',
            },
          )
          .toList();
    }

    return Container(
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
          GestureDetector(
            onTap: () {
              if (hostelId.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(hostelId: hostelId),
                  ),
                );
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 120,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
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
                                  children: [
                                    TextSpan(
                                      text: '${name.split(' ').first} ',
                                      style: const TextStyle(
                                        color: Color(0xFFF80500),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: name.split(' ').length > 1
                                          ? name.split(' ').sublist(1).join(' ')
                                          : '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Selector<WishlistProvider, bool>(
                              selector: (_, p) => p.isWishlisted(hostelId),
                              builder: (context, wishlisted, _) {
                                return GestureDetector(
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
                                                : '❤️ Added to wishlist — $name',
                                            type: isCurrentlyWishlisted
                                                ? ToastType.warning
                                                : ToastType.success,
                                          );
                                        },
                                  behavior: HitTestBehavior.opaque,
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
                        _buildRatingBadge(rating),
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
                                address,
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: shares.map<Widget>((share) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Column(
                                  children: [
                                    Text(
                                      share['label'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      share['price'] ?? '',
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makePhoneCall(phone),
                    icon: const Icon(Icons.call, size: 14, color: Colors.white),
                    label: const Text(
                      'Call',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFF80500),
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
                    onPressed: () => _openWhatsApp(phone),
                    icon: Image.asset(
                      'assets/whatsapp.png',
                      width: 18,
                      height: 18,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.chat, size: 14, color: Colors.green),
                    ),
                    label: const Text(
                      'Whatsapp',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
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
                          builder: (_) => MapScreen(
                            hostelName: name,
                            hostelAddress: address,
                            hostelLatitude: latitude,
                            hostelLongitude: longitude,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFFF80500),
                    ),
                    label: const Text(
                      'Location',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFF80500)),
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
    final ratingValue = double.tryParse(rating) ?? 0;
    final color = ratingValue >= 4
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
        mainAxisSize: MainAxisSize.min,
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
