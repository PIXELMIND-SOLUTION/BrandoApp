// import 'package:brando_app/config/theme_config.dart';
// import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
// import 'package:brando_app/views/Map/map_screen.dart';
// import 'package:brando_app/views/details/detail_screen.dart';
// import 'package:brando_app/widgets/toast_message.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class WishlistScreen extends StatefulWidget {
//   const WishlistScreen({super.key});

//   @override
//   State<WishlistScreen> createState() => _WishlistScreenState();
// }

// class _WishlistScreenState extends State<WishlistScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         context.read<WishlistProvider>().fetchWishlist();
//       }
//     });
//   }

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
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

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
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
//                 child: const Text(
//                   'Exit',
//                   style: TextStyle(color: AppColors.primary),
//                 ),
//               ),
//             ],
//           ),
//         );

//         if (shouldExit == true) {
//           if (mounted) {
//             SystemNavigator.pop();
//           }
//           return true;
//         }
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.lightBackground,
//         appBar: AppBar(
//           backgroundColor: AppColors.lightBackground,
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           title: const Text(
//             'Favourites',
//             style: TextStyle(
//               color: AppColors.lightText,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Consumer<WishlistProvider>(
//           builder: (context, wishlistProvider, _) {
//             if (wishlistProvider.status == WishlistStatus.loading) {
//               return const Center(
//                 child: CircularProgressIndicator(color: AppColors.primary),
//               );
//             }

//             if (wishlistProvider.status == WishlistStatus.error) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       color: AppColors.primary.withOpacity(0.5),
//                       size: 56,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       wishlistProvider.errorMessage ?? 'Something went wrong.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: AppColors.lightTextSecondary,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () => wishlistProvider.fetchWishlist(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         'Retry',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             if (wishlistProvider.wishlistItems.isEmpty) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 32),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Lottie.network(
//                         'https://assets9.lottiefiles.com/packages/lf20_ydo1amjm.json',
//                         width: 220,
//                         height: 220,
//                         fit: BoxFit.contain,
//                         repeat: true,
//                         errorBuilder: (_, __, ___) => Icon(
//                           Icons.favorite_border,
//                           size: 64,
//                           color: AppColors.primary.withOpacity(0.5),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       const Text(
//                         'No Favourites Yet',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.lightText,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Tap the ❤️ on any hostel to\nsave it here for later.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: AppColors.lightTextSecondary,
//                           height: 1.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return RefreshIndicator(
//               color: AppColors.primary,
//               onRefresh: () => wishlistProvider.fetchWishlist(),
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemCount: wishlistProvider.wishlistItems.length,
//                 itemBuilder: (context, index) {
//                   final item = wishlistProvider.wishlistItems[index];
//                   final hostel = item.hostel;
//                   if (hostel == null) return const SizedBox.shrink();
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DetailScreen(hostelId: hostel.id),
//                         ),
//                       );
//                     },
//                     child: _buildHostelCard(hostel, wishlistProvider),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildHostelCard(dynamic hostel, WishlistProvider wishlistProvider) {
//     final String hostelId = hostel.id ?? '';
//     final String name = hostel.name ?? 'Unknown';
//     final String rating = hostel.rating.toString();
//     final String address = hostel.address ?? '';
//     final List sharings = hostel.sharings ?? [];
//     final String firstImage =
//         (hostel.images != null && hostel.images.isNotEmpty)
//         ? hostel.images[0]
//         : '';
//     final String categoryName = hostel.category?.name ?? '';

//     final double? latitude = hostel.location?.latitude;
//     final double? longitude = hostel.location?.longitude;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: AppColors.lightBackground,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.lightBorder,
//             blurRadius: 8,
//             spreadRadius: 2,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: AppColors.lightBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   bottomLeft: Radius.circular(12),
//                 ),
//                 child: firstImage.isNotEmpty
//                     ? Image.network(
//                         firstImage,
//                         width: 120,
//                         height: 130,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => _placeholderImage(),
//                       )
//                     : Image.asset(
//                         'assets/hotelimage.png',
//                         width: 120,
//                         height: 130,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => _placeholderImage(),
//                       ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: RichText(
//                               text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: '${name.split(' ').first} ',
//                                     style: const TextStyle(
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: name.split(' ').length > 1
//                                         ? name.split(' ').skip(1).join(' ')
//                                         : '',
//                                     style: const TextStyle(
//                                       color: AppColors.lightText,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Selector<WishlistProvider, bool>(
//                             selector: (_, p) => p.isWishlisted(hostelId),
//                             builder: (context, wishlisted, _) {
//                               return GestureDetector(
//                                 onTap: hostelId.isEmpty
//                                     ? null
//                                     : () {
//                                         final wishlistProvider = context
//                                             .read<WishlistProvider>();
//                                         final isCurrentlyWishlisted =
//                                             wishlistProvider.isWishlisted(
//                                               hostelId,
//                                             );
//                                         wishlistProvider.toggleWishlist(
//                                           hostelId,
//                                         );

//                                         ToastHelper.show(
//                                           context,
//                                           message: isCurrentlyWishlisted
//                                               ? 'Removed from your favourites'
//                                               : '❤️  Added to favourites — $name',
//                                           type: isCurrentlyWishlisted
//                                               ? ToastType.warning
//                                               : ToastType.success,
//                                         );
//                                       },
//                                 child: AnimatedSwitcher(
//                                   duration: const Duration(milliseconds: 300),
//                                   transitionBuilder: (child, animation) =>
//                                       ScaleTransition(
//                                         scale: animation,
//                                         child: child,
//                                       ),
//                                   child: Icon(
//                                     wishlisted
//                                         ? Icons.favorite
//                                         : Icons.favorite_border,
//                                     key: ValueKey(wishlisted),
//                                     color: wishlisted
//                                         ? AppColors.primary
//                                         : AppColors.lightTextSecondary,
//                                     size: 22,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           _buildRatingBadge(rating),
//                           if (categoryName.isNotEmpty) ...[
//                             const SizedBox(width: 6),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 6,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(
//                                   color: AppColors.primary.withOpacity(0.2),
//                                 ),
//                               ),
//                               child: Text(
//                                 categoryName,
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(
//                             Icons.location_on,
//                             color: AppColors.primary,
//                             size: 12,
//                           ),
//                           const SizedBox(width: 2),
//                           Expanded(
//                             child: Text(
//                               address,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: AppColors.lightTextSecondary,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: sharings.map<Widget>((share) {
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 6),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     share.shareType,
//                                     style: TextStyle(
//                                       fontSize: 8,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.lightTextSecondary,
//                                     ),
//                                   ),
//                                   Text(
//                                     '₹${share.nonAcMonthlyPrice}/-',
//                                     style: const TextStyle(
//                                       fontSize: 9,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () => _makePhoneCall("9961593179"),
//                     icon: const Icon(Icons.call, size: 14, color: Colors.white),
//                     label: const Text(
//                       'Call',
//                       style: TextStyle(fontSize: 12, color: Colors.white),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: AppColors.primary,
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
//                     onPressed: () => _openWhatsApp("919961593179"),
//                     icon: Image.asset(
//                       'assets/whatsapp.png',
//                       width: 18,
//                       height: 18,
//                       errorBuilder: (_, __, ___) => const Icon(
//                         Icons.chat,
//                         size: 14,
//                         color: AppColors.success,
//                       ),
//                     ),
//                     label: Text(
//                       'Whatsapp',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.lightText,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: AppColors.primary,
//                       side: BorderSide(color: AppColors.lightBorder),
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
//                           builder: (context) => MapScreen(
//                             hostelName: name,
//                             hostelAddress: address,
//                             hostelLatitude: latitude,
//                             hostelLongitude: longitude,
//                           ),
//                         ),
//                       );
//                     },
//                     icon: Icon(
//                       Icons.location_on,
//                       size: 14,
//                       color: AppColors.primary,
//                     ),
//                     label: Text(
//                       'Location',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.lightText,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: AppColors.primary,
//                       side: const BorderSide(color: AppColors.primary),
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
//       color: AppColors.lightSurface,
//       child: Icon(Icons.hotel, size: 40, color: AppColors.lightTextSecondary),
//     );
//   }

//   Widget _buildRatingBadge(String rating) {
//     final double ratingValue = double.tryParse(rating) ?? 0;
//     final Color color = ratingValue >= 4
//         ? AppColors.success
//         : ratingValue >= 3
//         ? Colors.orange
//         : AppColors.error;

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

import 'package:flutter/material.dart';

class AdminOffersScreen extends StatelessWidget {
  const AdminOffersScreen({super.key});

  static const List<Map<String, dynamic>> _offers = [
    {
      'title': 'Summer Special',
      'description': 'Get 20% off on all hostel bookings',
      'discount': '20% off',
      'validUntil': 'Till Aug 31, 2024',
      'code': 'SUMMER20',
      'isActive': true,
      'icon': Icons.beach_access_outlined,
      'iconBg': Color(0xFFFAEEDA),
      'iconColor': Color(0xFFBA7517),
      'badgeBg': Color(0xFFEAF3DE),
      'badgeColor': Color(0xFF3B6D11),
    },
    {
      'title': 'Early Bird',
      'description': 'Book 7 days in advance and save 15%',
      'discount': '15% off',
      'validUntil': 'Till Dec 31, 2024',
      'code': 'EARLY15',
      'isActive': true,
      'icon': Icons.alarm_outlined,
      'iconBg': Color(0xFFEAF3DE),
      'iconColor': Color(0xFF3B6D11),
      'badgeBg': Color(0xFFEAF3DE),
      'badgeColor': Color(0xFF3B6D11),
    },
    {
      'title': 'Group Booking',
      'description': 'Book for 5+ people and get 25% off',
      'discount': '25% off',
      'validUntil': 'Till Oct 15, 2024',
      'code': 'GROUP25',
      'isActive': false,
      'icon': Icons.group_outlined,
      'iconBg': Color(0xFFEEEDFE),
      'iconColor': Color(0xFF534AB7),
      'badgeBg': Color(0xFFEEEDFE),
      'badgeColor': Color(0xFF534AB7),
    },
    {
      'title': 'Weekend Getaway',
      'description': 'Flat ₹500 off on weekend stays',
      'discount': '₹500 off',
      'validUntil': 'Till Sep 30, 2024',
      'code': 'WEEKEND500',
      'isActive': true,
      'icon': Icons.weekend_outlined,
      'iconBg': Color(0xFFE6F1FB),
      'iconColor': Color(0xFF185FA5),
      'badgeBg': Color(0xFFE6F1FB),
      'badgeColor': Color(0xFF185FA5),
    },
    {
      'title': 'First Booking',
      'description': 'Special 30% off for first time users',
      'discount': '30% off',
      'validUntil': 'Till Nov 30, 2024',
      'code': 'FIRST30',
      'isActive': true,
      'icon': Icons.star_outline,
      'iconBg': Color(0xFFFAEEDA),
      'iconColor': Color(0xFFBA7517),
      'badgeBg': Color(0xFFEAF3DE),
      'badgeColor': Color(0xFF3B6D11),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeCount = _offers.where((o) => o['isActive'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          'Manage offers',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
        ),
        centerTitle: true,
        elevation: 0,
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE0E0E0)),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.local_offer_outlined,
                      iconColor: const Color(0xFF3B6D11),
                      value: '$activeCount',
                      label: 'Active offers',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.layers_outlined,
                      iconColor: const Color(0xFF185FA5),
                      value: '${_offers.length}',
                      label: 'Total offers',
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _StatCard(
                      icon: Icons.timer_outlined,
                      iconColor: Color(0xFFBA7517),
                      value: '3',
                      label: 'Expiring soon',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text(
                'ALL OFFERS',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF888780),
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList.separated(
              itemCount: _offers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _OfferCard(offer: _offers[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF888780)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    final bool isActive = offer['isActive'] as bool;

    return Opacity(
      opacity: isActive ? 1.0 : 0.55,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + title + discount badge + status pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: offer['iconBg'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    offer['icon'] as IconData,
                    color: offer['iconColor'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    offer['title'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Discount badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: offer['badgeBg'] as Color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    offer['discount'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: offer['badgeColor'] as Color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Active / Inactive pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFEAF3DE)
                        : const Color(0xFFF1EFE8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B6D11),
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF3B6D11)
                              : const Color(0xFF5F5E5A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              offer['description'] as String,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5F5E5A),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            // Divider
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5E5)),
            const SizedBox(height: 10),
            // Meta row: code + validity
            Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  size: 14,
                  color: Color(0xFF888780),
                ),
                const SizedBox(width: 5),
                Text(
                  offer['code'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5F5E5A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF888780),
                ),
                const SizedBox(width: 5),
                Text(
                  offer['validUntil'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5F5E5A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
