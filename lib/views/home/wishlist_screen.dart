import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminOffersScreen extends StatefulWidget {
  const AdminOffersScreen({super.key});

  @override
  State<AdminOffersScreen> createState() => _AdminOffersScreenState();
}

class _AdminOffersScreenState extends State<AdminOffersScreen> {
  List<dynamic> _offers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await http.get(
        Uri.parse('http://187.127.146.52:2003/api/admin/offers'),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          setState(() {
            _offers = jsonData['data'] ?? [];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load offers';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Offers',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        // leading: GestureDetector(
        //   onTap: () => Navigator.pop(context),
        //   child: Center(
        //     child: Container(
        //       width: 32,
        //       height: 32,
        //       margin: const EdgeInsets.only(left: 12),
        //       decoration: BoxDecoration(
        //         color: const Color(0xFFF5F5F0),
        //         shape: BoxShape.circle,
        //         border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
        //       ),
        //       child: const Icon(
        //         Icons.arrow_back_ios_new_rounded,
        //         size: 14,
        //         color: Color(0xFF5F5E5A),
        //       ),
        //     ),
        //   ),
        // ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 14),
        //     child: Stack(
        //       clipBehavior: Clip.none,
        //       children: [
        //         Container(
        //           width: 32,
        //           height: 32,
        //           decoration: BoxDecoration(
        //             color: const Color(0xFFF5F5F0),
        //             shape: BoxShape.circle,
        //             border: Border.all(
        //                 color: const Color(0xFFE0E0E0), width: 0.5),
        //           ),
        //           child: const Icon(
        //             Icons.notifications_outlined,
        //             size: 16,
        //             color: Color(0xFF5F5E5A),
        //           ),
        //         ),
        //         Positioned(
        //           top: 5,
        //           right: 5,
        //           child: Container(
        //             width: 7,
        //             height: 7,
        //             decoration: BoxDecoration(
        //               color: const Color(0xFFE84A4A),
        //               shape: BoxShape.circle,
        //               border: Border.all(color: Colors.white, width: 1.5),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE0E0E0)),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
          strokeWidth: 2,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFCEBEB),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 32, color: Color(0xFFE84A4A)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 12, color: Color(0xFF888780)),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _fetchOffers,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Try again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F1EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_offer_outlined,
                  size: 36, color: Color(0xFFB0B0B0)),
            ),
            const SizedBox(height: 16),
            const Text(
              'No offers yet',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Check back soon for new deals',
              style: TextStyle(fontSize: 12, color: Color(0xFF888780)),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'ALL OFFERS',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF888780),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 110),
          sliver: SliverList.separated(
            itemCount: _offers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) => _OfferCard(
              offer: _offers[index],
              index: index,
              total: _offers.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
class _OfferCard extends StatelessWidget {
  final dynamic offer;
  final int index;
  final int total;

  const _OfferCard({
    required this.offer,
    required this.index,
    required this.total,
  });

  static const _tagColors = [
    Color(0xFFEAF3DE),
    Color(0xFFE1F5EE),
    Color(0xFFFAEEDA),
  ];
  static const _tagTextColors = [
    Color(0xFF3B6D11),
    Color(0xFF0F6E56),
    Color(0xFF854F0B),
  ];
  static const _tags = ['Limited time', 'Members only', 'New arrival'];

  @override
  Widget build(BuildContext context) {
    final String title = offer['title'] ?? 'No title';
    final String description = offer['description'] ?? 'No description';
    final String imageUrl = offer['image'] ?? '';

    final tagIndex = index % _tags.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E8E4), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──────────────────────────────────
          Stack(
            children: [
              if (imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return _ImagePlaceholder(isLoading: true);
                  },
                  errorBuilder: (_, __, ___) =>
                      const _ImagePlaceholder(isLoading: false),
                )
              else
                const _ImagePlaceholder(isLoading: false),

              // index counter badge
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${index + 1} of $total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Body ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _tagColors[tagIndex],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _tags[tagIndex],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: _tagTextColors[tagIndex],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5F5E5A),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // ── Footer ──────────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF0F0EC), width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   children: const [
                //     Icon(Icons.remove_red_eye_outlined,
                //         size: 14, color: Color(0xFF3B6D11)),
                //     SizedBox(width: 4),
                //     Text(
                //       'View details',
                //       style: TextStyle(
                //         fontSize: 11,
                //         fontWeight: FontWeight.w500,
                //         color: Color(0xFF3B6D11),
                //       ),
                //     ),
                //   ],
                // ),
                // Container(
                //   width: 28,
                //   height: 28,
                //   decoration: const BoxDecoration(
                //     color: Color(0xFFEAF3DE),
                //     shape: BoxShape.circle,
                //   ),
                //   child: const Icon(
                //     Icons.share_outlined,
                //     size: 14,
                //     color: Color(0xFF3B6D11),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
class _ImagePlaceholder extends StatelessWidget {
  final bool isLoading;
  const _ImagePlaceholder({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      color: const Color(0xFFEEEEE8),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Color(0xFF4CAF50), strokeWidth: 2)
            : const Icon(Icons.image_not_supported_outlined,
                size: 36, color: Color(0xFFB0B0B0)),
      ),
    );
  }
}