// import 'package:brando_app/widgets/wishlist_manager.dart';
// import 'package:flutter/material.dart';

// class SeeAllScreen extends StatefulWidget {
//   const SeeAllScreen({super.key});

//   @override
//   State<SeeAllScreen> createState() => _SeeAllScreenState();
// }

// class _SeeAllScreenState extends State<SeeAllScreen> {
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
//             'id': '2',

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
//     // {
//     //   'name': 'HIFI HOSTELS',
//     //   'rating': '1.5',
//     //   'isNew': false,
//     //   'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
//     //   'tag': '6KM Away',
//     //   'isFavorite': false,
//     //   'shares': [
//     //     {'label': '1 SHARE', 'price': '5,000/-'},
//     //     {'label': '2 SHARE', 'price': '3,500/-'},
//     //     {'label': '3 SHARE', 'price': '3,000/-'},
//     //     {'label': '4 SHARE', 'price': '2,800/-'},
//     //     {'label': '5 SHARE', 'price': '6,000/-'},
//     //   ],
//     // },
//     {
//       'id': '3',
//       'name': 'HIFI HOSTELS',
//       'rating': '4.0',
//       'isNew': true,
//       'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
//       'tag': '8KM Away',
//       'isFavorite': false,
//       'shares': [
//         {'label': '1 SHARE', 'price': '5,500/-'},
//         {'label': '2 SHARE', 'price': '4,000/-'},
//         {'label': '3 SHARE', 'price': '3,200/-'},
//         {'label': '4 SHARE', 'price': '2,900/-'},
//         {'label': '5 SHARE', 'price': '2,500/-'},
//       ],
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
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
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 itemCount: _hostels.length,
//                 itemBuilder: (context, index) =>
//                     _buildHostelCard(_hostels[index]),
//               ),
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
//         children: [
//           const Icon(Icons.location_on, color: Colors.red, size: 18),
//           const SizedBox(width: 4),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
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
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.toggle_on, color: Colors.white, size: 18),
//                 SizedBox(width: 4),
//                 Text(
//                   'AC',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: TextField(
//           decoration: InputDecoration(
//             hintText: 'Search for "Hifi Hostel"',
//             hintStyle: TextStyle(
//               color: Colors.grey.shade500,
//               fontSize: 14,
//             ),
//             prefixIcon: const Icon(Icons.search, color: Colors.grey),
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(vertical: 12),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHostelCard(Map<String, dynamic> hostel) {
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
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(12),
//                   topLeft: Radius.circular(12),
//                   bottomLeft: Radius.circular(12),
//                   bottomRight: Radius.circular(12)
//                 ),
//                 child: Image.asset(
//                   'assets/hotelimage.png',
//                   width: 120,
//                   height: 130,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: 120,
//                     height: 130,
//                     color: Colors.grey.shade300,
//                     child: const Icon(
//                       Icons.hotel,
//                       size: 40,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
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
//                           RichText(
//                             text: TextSpan(
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                               children: [
//                                 TextSpan(
//                                   text: hostel['name'].split(' ')[0] + ' ',
//                                   style: const TextStyle(
//                                     color: Color(0xFFF80500),
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: hostel['name'].split(' ').length > 1
//                                       ? hostel['name'].split(' ')[1]
//                                       : '',
//                                   style: const TextStyle(color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ValueListenableBuilder<List<Map<String, dynamic>>>(
//                             valueListenable: WishlistManager().wishlist,
//                             builder: (context, _, __) {
//                               return GestureDetector(
//                                 onTap: () =>
//                                     WishlistManager().toggle(context, hostel),
//                                 child: Icon(
//                                   WishlistManager().isFavourite(hostel)
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: WishlistManager().isFavourite(hostel)
//                                       ? Colors.red
//                                       : Colors.grey,
//                                   size: 20,
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       _buildRatingBadge(hostel['rating']),
//                       const SizedBox(height: 6),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             color: Colors.red,
//                             size: 12,
//                           ),
//                           const SizedBox(width: 2),
//                           Expanded(
//                             child: RichText(
//                               text: TextSpan(
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                                 children: [
//                                   TextSpan(text: hostel['location']),
//                                   TextSpan(
//                                     text: '  ${hostel['tag']}',
//                                     style: const TextStyle(
//                                       color: Colors.red,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children:
//                               (hostel['shares'] as List).map<Widget>((share) {
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 6),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     share['label'],
//                                     style: const TextStyle(
//                                       fontSize: 8,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                   Text(
//                                     share['price'],
//                                     style: const TextStyle(
//                                       fontSize: 9,
//                                       color: Colors.red,
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
//                     onPressed: () {},
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
//                     onPressed: () {},
//                     icon: Image.asset(
//                       'assets/whatsapp.png',
//                       width: 18,
//                       height: 18,
//                       errorBuilder: (context, error, stackTrace) =>
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
//                     onPressed: () {},
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

import 'package:brando_app/views/details/detail_screen.dart';
import 'package:brando_app/widgets/wishlist_manager.dart';
import 'package:flutter/material.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAC = true;

  final List<Map<String, dynamic>> _menHostels = [
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
      'rating': '4.0',
      'isNew': true,
      'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
      'tag': '8KM Away',
      'isFavorite': false,
      'shares': [
        {'label': '1 SHARE', 'price': '5,500/-'},
        {'label': '2 SHARE', 'price': '4,000/-'},
        {'label': '3 SHARE', 'price': '3,200/-'},
        {'label': '4 SHARE', 'price': '2,900/-'},
        {'label': '5 SHARE', 'price': '2,500/-'},
      ],
    },
  ];

  final List<Map<String, dynamic>> _womenHostels = [
    {
      'id': '4',
      'name': 'HIFI HOSTELS',
      'rating': '4.8',
      'isNew': true,
      'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
      'tag': '4KM Away',
      'isFavorite': false,
      'shares': [
        {'label': '1 SHARE', 'price': '5,200/-'},
        {'label': '2 SHARE', 'price': '3,800/-'},
        {'label': '3 SHARE', 'price': '3,100/-'},
        {'label': '4 SHARE', 'price': '2,900/-'},
        {'label': '5 SHARE', 'price': '2,600/-'},
      ],
    },
    {
      'id': '5',
      'name': 'HIFI HOSTELS',
      'rating': '4.2',
      'isNew': false,
      'location': 'Kphb Hyderabad Kukatpally Hyderabad, 12000',
      'tag': '5KM Away',
      'isFavorite': true,
      'shares': [
        {'label': '1 SHARE', 'price': '4,800/-'},
        {'label': '2 SHARE', 'price': '3,400/-'},
        {'label': '3 SHARE', 'price': '2,900/-'},
        {'label': '4 SHARE', 'price': '2,700/-'},
        {'label': '5 SHARE', 'price': '2,400/-'},
      ],
    },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Hostels',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHostelList(_menHostels),
                  _buildHostelList(_womenHostels),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTabBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade100,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: Colors.grey.shade300),
  //       ),
  //       child: TabBar(
  //         controller: _tabController,
  //         indicator: BoxDecoration(
  //           color: const Color(0xFFF80500),
  //           borderRadius: BorderRadius.circular(7),
  //         ),
  //         labelColor: Colors.white,
  //         unselectedLabelColor: Colors.black87,
  //         labelStyle: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 13,
  //         ),
  //         unselectedLabelStyle: const TextStyle(
  //           fontWeight: FontWeight.w500,
  //           fontSize: 13,
  //         ),
  //         dividerColor: Colors.transparent,
  //         tabs: const [
  //           Tab(text: "Men's Pg"),
  //           Tab(text: "Women's Pg"),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
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
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          splashBorderRadius: BorderRadius.circular(30),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: "Men's PG"),
            Tab(text: "Women's PG"),
          ],
        ),
      ),
    );
  }

  Widget _buildHostelList(List<Map<String, dynamic>> hostels) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: hostels.length,
      itemBuilder: (context, index) => _buildHostelCard(hostels[index]),
    );
  }

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
                const Text(
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
          GestureDetector(
            onTap: () => setState(() => _isAC = !_isAC),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isAC ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'AC',
                      style: TextStyle(
                        color: _isAC ? Colors.white : Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: !_isAC ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Non AC',
                      style: TextStyle(
                        color: !_isAC ? Colors.white : Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for "Hifi Hostel"',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildHostelCard(Map<String, dynamic> hostel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen()));
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
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
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
                                      color: Color(0xFFF80500),
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
                        _buildRatingBadge(hostel['rating']),
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
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/whatsapp.png',
                        width: 18,
                        height: 18,
                        errorBuilder: (context, error, stackTrace) =>
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
