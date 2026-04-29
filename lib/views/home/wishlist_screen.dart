import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
import 'package:brando_app/views/Map/map_screen.dart';
import 'package:brando_app/views/details/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WishlistProvider>().fetchWishlist();
      }
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final message = Uri.encodeComponent(
      "Hello, I am interested in your hostel.",
    );
    final url = Uri.parse("https://wa.me/$phoneNumber?text=$message");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
          canPop: false,
    onPopInvoked: (bool didPop) async {
      if (didPop) return;
      
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
      
      if (shouldExit == true) {
        if (context.mounted) {
          // ignore: deprecated_member_use
          SystemNavigator.pop();
        }
      }
    },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Favourites',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<WishlistProvider>(
          builder: (context, wishlistProvider, _) {
            // ── Loading ──────────────────────────────────────────────────────
            if (wishlistProvider.status == WishlistStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            }
      
            // ── Error ────────────────────────────────────────────────────────
            if (wishlistProvider.status == WishlistStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade300,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      wishlistProvider.errorMessage ?? 'Something went wrong.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => wishlistProvider.fetchWishlist(),
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
              );
            }
      
            // ── Empty ────────────────────────────────────────────────────────
            if (wishlistProvider.wishlistItems.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No favourites yet',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tap the heart on any hostel to save it here.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              );
            }
      
            // ── List ─────────────────────────────────────────────────────────
            return RefreshIndicator(
              color: Colors.red,
              onRefresh: () => wishlistProvider.fetchWishlist(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: wishlistProvider.wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = wishlistProvider.wishlistItems[index];
                  final hostel = item.hostel;
                  if (hostel == null) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(hostelId: hostel.id,)));
                    },
                    child: _buildHostelCard(hostel, wishlistProvider));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHostelCard(dynamic hostel, WishlistProvider wishlistProvider) {
    final String hostelId = hostel.id ?? '';
    final String name = hostel.name ?? 'Unknown';
    final String rating = hostel.rating.toString();
    final String address = hostel.address ?? '';
    final List sharings = hostel.sharings ?? [];
    final String firstImage =
        (hostel.images != null && hostel.images.isNotEmpty)
        ? hostel.images[0]
        : '';
    final String categoryName = hostel.category?.name ?? '';

      final double? latitude = hostel.location?.latitude;
  final double? longitude = hostel.location?.longitude;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ───────────────────────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
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

              // ── Details ─────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${name.split(' ').first} ',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: name.split(' ').length > 1
                                        ? name.split(' ').skip(1).join(' ')
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

                          // ── Heart / Remove button ──────────────────────
                          Selector<WishlistProvider, bool>(
                            selector: (_, p) => p.isWishlisted(hostelId),
                            builder: (context, wishlisted, _) {
                              return GestureDetector(
                                onTap: hostelId.isEmpty
                                    ? null
                                    : () {
                                        context
                                            .read<WishlistProvider>()
                                            .toggleWishlist(hostelId);
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

                      // ── Rating + Category ──────────────────────────────
                      Row(
                        children: [
                          _buildRatingBadge(rating),
                          if (categoryName.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                categoryName,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 6),

                      // ── Address ────────────────────────────────────────
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

                      // ── Sharing Prices ─────────────────────────────────
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: sharings.map<Widget>((share) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Column(
                                children: [
                                  Text(
                                    share.shareType,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    '₹${share.nonAcMonthlyPrice}/-',
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

          // ── Action Buttons ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makePhoneCall("9961593179"),
                    icon: const Icon(Icons.call, size: 14, color: Colors.white),
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
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.chat, size: 14, color: Colors.green),
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
