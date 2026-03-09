// import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   final List<Map<String, dynamic>> _recentSearches = [
//     {
//       'name': 'HIFI HOSTELS',
//       'rating': '3.5',
//       'address': 'Kutbi Hyderabad road Kukatpally Hyderabad, 500072... 1914 Away',
//       'sharing': [
//         {'label': '1 SHAR', 'price': '6,000/-'},
//         {'label': '2 SHAR', 'price': '4,500/-'},
//         {'label': '3 SHAR', 'price': '3,800/-'},
//         {'label': '4 SHAR', 'price': '3,400/-'},
//         {'label': '6 SHAR', 'price': '4,000/-'},
//       ],
//     },
//     {
//       'name': 'HIFI HOSTELS',
//       'rating': '3.5',
//       'address': 'Kutbi Hyderabad road Kukatpally Hyderabad, 500072... 1914 Away',
//       'sharing': [
//         {'label': '1 SHAR', 'price': '6,000/-'},
//         {'label': '2 SHAR', 'price': '4,500/-'},
//         {'label': '3 SHAR', 'price': '3,800/-'},
//         {'label': '4 SHAR', 'price': '3,400/-'},
//         {'label': '6 SHAR', 'price': '4,000/-'},
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
//         leading: const BackButton(color: Colors.black),
//         centerTitle: true,
//         title: const Text(
//           'Search',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 8),
//             // Search Bar
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search for "Hifi Hostel"',
//                   hintStyle: TextStyle(color: Colors.red.shade400, fontSize: 14),
//                   prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Resent Searches',
//               style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: _recentSearches.length,
//                 separatorBuilder: (_, __) => const Divider(height: 24),
//                 itemBuilder: (context, index) {
//                   final hostel = _recentSearches[index];
//                   return _HostelCard(hostel: hostel);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HostelCard extends StatelessWidget {
//   final Map<String, dynamic> hostel;

//   const _HostelCard({required this.hostel});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.asset(
//                 'assets/hotelimage.png',
//                 width: 90,
//                 height: 90,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   width: 90,
//                   height: 90,
//                   color: Colors.grey.shade200,
//                   child: const Icon(Icons.hotel, color: Colors.grey),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Name + Rating
//                   Row(
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'HIFI ',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 16,
//                                 color: Colors.red.shade700,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                             const TextSpan(
//                               text: 'HOSTELS',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 16,
//                                 color: Colors.black,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade700,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               hostel['rating'],
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(width: 2),
//                             const Icon(Icons.star, color: Colors.white, size: 11),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   // Address
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.location_on, size: 12, color: Colors.red.shade700),
//                       const SizedBox(width: 2),
//                       Expanded(
//                         child: Text(
//                           hostel['address'],
//                           style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // Sharing prices
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(
//                         (hostel['sharing'] as List).length,
//                         (i) {
//                           final share = hostel['sharing'][i];
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   share['label'],
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                                 Text(
//                                   share['price'],
//                                   style: const TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         // Action Buttons
//         Row(
//           children: [
//             _ActionButton(
//               icon: Icons.phone,
//               label: 'Call',
//               color: Colors.red.shade700,
//               isFilled: true,
//               onTap: () {},
//             ),
//             const SizedBox(width: 8),
//             _ActionButton(
//               icon: Icons.chat,
//               label: 'Whatsapp',
//               color: Colors.black,
//               isFilled: false,
//               onTap: () {},
//             ),
//             const SizedBox(width: 8),
//             _ActionButton(
//               icon: Icons.location_on,
//               label: 'Location',
//               color: Colors.red.shade700,
//               isFilled: false,
//               onTap: () {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final bool isFilled;
//   final VoidCallback onTap;

//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.isFilled,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//         decoration: BoxDecoration(
//           color: isFilled ? color : Colors.white,
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: color),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 14, color: isFilled ? Colors.white : color),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: isFilled ? Colors.white : color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:brando_app/views/details/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasSearched = false;

  static const String _baseUrl =
      'http://31.97.206.144:2003/api/auth/search-filter-hostels';

  Future<void> _searchHostels(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasSearched = true;
    });

    try {
      final uri = Uri.parse(
        '$_baseUrl?search=${Uri.encodeComponent(query.trim())}',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _searchResults = List<Map<String, dynamic>>.from(
              data['hostels'] ?? [],
            );
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No results found.';
            _searchResults = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _searchResults = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to connect. Please check your internet connection.';
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => _searchHostels(value),
                decoration: InputDecoration(
                  hintText: 'Search for hostels...',
                  hintStyle: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey.shade400,
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResults = [];
                              _hasSearched = false;
                              _errorMessage = null;
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {}); // Rebuild to show/hide clear button
                },
              ),
            ),
            const SizedBox(height: 20),
            // Results header
            if (_hasSearched)
              Text(
                _isLoading
                    ? 'Searching...'
                    : _errorMessage != null
                    ? 'Results'
                    : 'Found ${_searchResults.length} Hostel${_searchResults.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black,
                ),
              )
            else
              const Text(
                '',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            const SizedBox(height: 12),
            // Body
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
                    )
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty && _hasSearched
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.hotel,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No hostels found.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Search for hostels near you',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        return _HostelCard(hostel: _searchResults[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HostelCard extends StatelessWidget {
  final Map<String, dynamic> hostel;

  const _HostelCard({required this.hostel});

  String get _name => hostel['name'] ?? 'Unknown';
  String get _id => hostel['_id'] ?? 'Unknown';

  double get _rating => (hostel['rating'] ?? 0).toDouble();
  String get _address => hostel['address'] ?? '';
  String get _type => hostel['type'] ?? '';
  List<dynamic> get _sharings => hostel['sharings'] ?? [];
  List<dynamic> get _images => hostel['images'] ?? [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(hostelId: _id),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _images.isNotEmpty
                    ? Image.network(
                        _images[0],
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _placeholderImage(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.redAccent,
                              ),
                            ),
                          );
                        },
                      )
                    : _placeholderImage(),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Rating
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.black,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 11,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_type.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          _type,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          _address,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Sharing prices
                  if (_sharings.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _sharings.map((share) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  share['shareType'] ?? '',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  '₹${share['monthlyPrice'] ?? 0}/-',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
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
          ],
        ),
        const SizedBox(height: 12),
        // Action Buttons
        Row(
          children: [
            _ActionButton(
              icon: Icons.phone,
              label: 'Call',
              color: Colors.red.shade700,
              isFilled: true,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.chat,
              label: 'Whatsapp',
              color: Colors.black,
              isFilled: false,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.location_on,
              label: 'Location',
              color: Colors.red.shade700,
              isFilled: false,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.hotel, color: Colors.grey),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isFilled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isFilled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isFilled ? color : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isFilled ? Colors.white : color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isFilled ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
