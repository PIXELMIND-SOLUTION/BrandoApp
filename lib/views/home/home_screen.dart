import 'package:brando_app/views/details/detail_screen.dart';
import 'package:brando_app/views/notifications/notification_screen.dart';
import 'package:brando_app/views/search/search_screen.dart';
import 'package:brando_app/views/seeall/see_all_screen.dart';
import 'package:brando_app/widgets/wishlist_manager.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_switch/flutter_switch.dart';

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

  final List<String> _carouselImages = [
    'assets/carouselimage.png',
    'assets/carouselimage.png',
    'assets/carouselimage.png',
  ];

  final List<Map<String, dynamic>> _hostels = [
    {
      'id': '1',
      'name': 'HIFI HOSTELS',
      'rating': '4.5',
      'isNew': true,
      'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
      'tag': '6KM Away',
      'isFavorite': true,
      'shares': [
        {'label': '1 SHARE', 'price': '5,000/-'},
        {'label': '2 SHARE', 'price': '3,500/-'},
        {'label': '3 SHARE', 'price': '3,000/-'},
        {'label': '4 SHARE', 'price': '2,800/-'},
        {'label': '5 SHARE', 'price': '6,000/-'},
      ],
    },
    {
      'id': '2',
      'name': 'HIFI HOSTELS',
      'rating': '3.5',
      'isNew': false,
      'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
      'tag': '6KM Away',
      'isFavorite': false,
      'shares': [
        {'label': '1 SHARE', 'price': '5,000/-'},
        {'label': '2 SHARE', 'price': '3,500/-'},
        {'label': '3 SHARE', 'price': '3,000/-'},
        {'label': '4 SHARE', 'price': '2,800/-'},
        {'label': '5 SHARE', 'price': '6,000/-'},
      ],
    },
    {
      'id': '3',
      'name': 'HIFI HOSTELS',
      'rating': '1.5',
      'isNew': false,
      'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
      'tag': '6KM Away',
      'isFavorite': false,
      'shares': [
        {'label': '1 SHARE', 'price': '5,000/-'},
        {'label': '2 SHARE', 'price': '3,500/-'},
        {'label': '3 SHARE', 'price': '3,000/-'},
        {'label': '4 SHARE', 'price': '2,800/-'},
        {'label': '5 SHARE', 'price': '6,000/-'},
      ],
    },
  ];

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
              ..._hostels.map((hostel) => _buildHostelCard(hostel)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTopBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //     child: Row(
  //       children: [
  //         const Icon(Icons.location_on, color: Colors.red, size: 18),
  //         const SizedBox(width: 4),
  //         Expanded(
  //           child: Row(
  //             children: [
  //               const Text(
  //                 'Kphb Hyderabad Kukatpally ...',
  //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               const Icon(Icons.arrow_drop_down, size: 20),
  //             ],
  //           ),
  //         ),
  //         Row(
  //           children: [
  //             _topIconButton(Icons.toggle_on_outlined),
  //             const SizedBox(width: 8),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => NotificationScreen(),
  //                   ),
  //                 );
  //               },
  //               child: _topIconButton(Icons.notifications_none),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.red, size: 18),
          const SizedBox(width: 4),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 46, 46, 46),
                  ),
                ),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Kphb Hyderabad Kukatpally ...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ],
            ),
          ),

          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
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
                      setState(() {
                        _isAC = val;
                      });
                    },
                  ),
                ],
              ),
              // _topIconButton(Icons.toggle_on_outlined),
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

  // Widget _buildSearchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade100,
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: Colors.grey.shade300),
  //       ),
  //       child: TextField(
  //         decoration: InputDecoration(
  //           hintText: 'Search for "HiFi Hostel"',
  //           hintStyle: TextStyle(
  //             color: Colors.red.shade400,
  //             fontSize: 14,
  //             fontStyle: FontStyle.italic,
  //           ),
  //           prefixIcon: const Icon(Icons.search, color: Colors.grey),
  //           border: InputBorder.none,
  //           contentPadding: const EdgeInsets.symmetric(vertical: 12),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
          readOnly: true, // 🔥 Important
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
          items: _carouselImages.map((imagePath) {
            return Builder(
              builder: (context) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildBannerFallback(),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                width: entry.value == _currentCarouselIndex ? 20 : 8,
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

  Widget _buildBannerFallback() {
    return Container(
      color: Colors.grey.shade300,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(6),
                    child: const Text(
                      'HOSTEL ROOMS\nAvailable',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 12),
                      Text(
                        'Bakeriya at\nNana Arida\'s Junction',
                        style: TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: const Text(
                      '0244439660',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey.shade400,
              child: const Center(
                child: Icon(Icons.hotel, size: 60, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
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
            child: Text(
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

  Widget _buildHostelCard(Map<String, dynamic> hostel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen()),
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/hotelimage.png',
                    width: 120,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 130,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.hotel,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
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
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: hostel['name'].split(' ')[0] + ' ',
                                    style: const TextStyle(
                                      color: Color(0xFFF80500), // HIFI color
                                    ),
                                  ),
                                  TextSpan(
                                    text: hostel['name'].split(' ').length > 1
                                        ? hostel['name'].split(' ')[1]
                                        : '',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                            // Text(
                            //   hostel['name'],
                            //   style: const TextStyle(
                            //     color: Colors.red,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            // Icon(
                            //   hostel['isFavorite']
                            //       ? Icons.favorite
                            //       : Icons.favorite_border,
                            //   color: hostel['isFavorite']
                            //       ? Colors.red
                            //       : Colors.grey,
                            //   size: 20,
                            // ),

                            // In _buildHostelCard(), replace the static heart icon with:
                            ValueListenableBuilder<List<Map<String, dynamic>>>(
                              valueListenable: WishlistManager().wishlist,
                              builder: (context, _, __) {
                                return GestureDetector(
                                  onTap: () =>
                                      WishlistManager().toggle(context, hostel),
                                  child: Icon(
                                    WishlistManager().isFavourite(hostel)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: WishlistManager().isFavourite(hostel)
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildRatingBadge(hostel['rating']),
                            // if (hostel['isNew']) ...[
                            //   const SizedBox(width: 6),
                            //   Container(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 6, vertical: 2),
                            //     decoration: BoxDecoration(
                            //       color: Colors.green,
                            //       borderRadius: BorderRadius.circular(4),
                            //     ),
                            //     child: const Text(
                            //       'New',
                            //       style:
                            //           TextStyle(color: Colors.white, fontSize: 10),
                            //     ),
                            //   ),
                            // ],
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
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(text: hostel['location']),
                                    TextSpan(
                                      text: '  ${hostel['tag']}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: (hostel['shares'] as List).map<Widget>((
                              share,
                            ) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Column(
                                  children: [
                                    Text(
                                      share['label'],
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      share['price'],
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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
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
                        // side: const BorderSide(color: Colors.green),
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
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/whatsapp.png',
                        width: 18,
                        height: 18,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
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
                        foregroundColor: Color(0xFFF80500),
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
                      onPressed: () {},
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

  Widget _buildRatingBadge(String rating) {
    Color color;
    double ratingValue = double.tryParse(rating) ?? 0;
    if (ratingValue >= 4) {
      color = Colors.green;
    } else if (ratingValue >= 3) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
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
