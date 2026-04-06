// import 'dart:convert';
// import 'package:brando_app/views/Map/map_screen.dart';
// import 'package:brando_app/views/details/detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   List<Map<String, dynamic>> _searchResults = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//   bool _hasSearched = false;

//   static const String _baseUrl =
//       'http://31.97.206.144:2003/api/auth/search-filter-hostels';

//   Future<void> _searchHostels(String query) async {
//     if (query.trim().isEmpty) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _hasSearched = true;
//     });

//     try {
//       final uri = Uri.parse(
//         '$_baseUrl?search=${Uri.encodeComponent(query.trim())}',
//       );
//       final response = await http.get(uri).timeout(const Duration(seconds: 15));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           setState(() {
//             _searchResults = List<Map<String, dynamic>>.from(
//               data['hostels'] ?? [],
//             );
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _errorMessage = 'No results found.';
//             _searchResults = [];
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'Server error: ${response.statusCode}';
//           _searchResults = [];
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage =
//             'Failed to connect. Please check your internet connection.';
//         _searchResults = [];
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

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
//                 textInputAction: TextInputAction.search,
//                 onSubmitted: (value) => _searchHostels(value),
//                 decoration: InputDecoration(
//                   hintText: 'Search for hostels...',
//                   hintStyle: TextStyle(
//                     color: Colors.red.shade400,
//                     fontSize: 14,
//                   ),
//                   prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
//                   suffixIcon: _searchController.text.isNotEmpty
//                       ? IconButton(
//                           icon: Icon(
//                             Icons.clear,
//                             color: Colors.grey.shade400,
//                             size: 18,
//                           ),
//                           onPressed: () {
//                             _searchController.clear();
//                             setState(() {
//                               _searchResults = [];
//                               _hasSearched = false;
//                               _errorMessage = null;
//                             });
//                           },
//                         )
//                       : null,
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 onChanged: (value) {
//                   setState(() {}); // Rebuild to show/hide clear button
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Results header
//             if (_hasSearched)
//               Text(
//                 _isLoading
//                     ? 'Searching...'
//                     : _errorMessage != null
//                     ? 'Results'
//                     : 'Found ${_searchResults.length} Hostel${_searchResults.length != 1 ? 's' : ''}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                   color: Colors.black,
//                 ),
//               )
//             else
//               const Text(
//                 '',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                   color: Colors.black,
//                 ),
//               ),
//             const SizedBox(height: 12),
//             // Body
//             Expanded(
//               child: _isLoading
//                   ? const Center(
//                       child: CircularProgressIndicator(color: Colors.redAccent),
//                     )
//                   : _errorMessage != null
//                   ? Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.search_off,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             _errorMessage!,
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontSize: 14,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     )
//                   : _searchResults.isEmpty && _hasSearched
//                   ? Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.hotel,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'No hostels found.',
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : _searchResults.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.search,
//                             size: 48,
//                             color: Colors.grey.shade300,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'Search for hostels near you',
//                             style: TextStyle(
//                               color: Colors.grey.shade500,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.separated(
//                       itemCount: _searchResults.length,
//                       separatorBuilder: (_, __) => const Divider(height: 24),
//                       itemBuilder: (context, index) {
//                         return _HostelCard(hostel: _searchResults[index]);
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HostelCard extends StatelessWidget {
//   Map<String, dynamic>? get _location => hostel['location'];

//   double? get _latitude {
//     if (_location == null) return null;
//     final coords = _location!['coordinates'];
//     if (coords == null || coords.length < 2) return null;
//     return (coords[1] as num).toDouble();
//   }

//   double? get _longitude {
//     if (_location == null) return null;
//     final coords = _location!['coordinates'];
//     if (coords == null || coords.length < 2) return null;
//     return (coords[0] as num).toDouble();
//   }

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

//   final Map<String, dynamic> hostel;

//   const _HostelCard({required this.hostel});

//   String get _name => hostel['name'] ?? 'Unknown';
//   String get _id => hostel['_id'] ?? 'Unknown';

//   double get _rating => (hostel['rating'] ?? 0).toDouble();
//   String get _address => hostel['address'] ?? '';
//   String get _type => hostel['type'] ?? '';
//   List<dynamic> get _sharings => hostel['sharings'] ?? [];
//   List<dynamic> get _images => hostel['images'] ?? [];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailScreen(hostelId: _id),
//                   ),
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: _images.isNotEmpty
//                     ? Image.network(
//                         _images[0],
//                         width: 90,
//                         height: 90,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) =>
//                             _placeholderImage(),
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Container(
//                             width: 90,
//                             height: 90,
//                             color: Colors.grey.shade100,
//                             child: const Center(
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.redAccent,
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : _placeholderImage(),
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
//                       Flexible(
//                         child: Text(
//                           _name,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w900,
//                             fontSize: 15,
//                             color: Colors.black,
//                             letterSpacing: 0.5,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 6,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade700,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               _rating.toStringAsFixed(1),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(width: 2),
//                             const Icon(
//                               Icons.star,
//                               color: Colors.white,
//                               size: 11,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (_type.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 6,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(4),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Text(
//                           _type,
//                           style: TextStyle(
//                             fontSize: 9,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 4),
//                   // Address
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 12,
//                         color: Colors.red.shade700,
//                       ),
//                       const SizedBox(width: 2),
//                       Expanded(
//                         child: Text(
//                           _address,
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.grey.shade600,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // Sharing prices
//                   if (_sharings.isNotEmpty)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: _sharings.map((share) {
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   share['shareType'] ?? '',
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                                 Text(
//                                   '₹${share['monthlyPrice'] ?? 0}/-',
//                                   style: const TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
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
//               onTap: () {
//                 _makePhoneCall('9961593179');
//               },
//             ),
//             const SizedBox(width: 8),
//             _ActionButton(
//               icon: Icons.chat,
//               label: 'Whatsapp',
//               color: Colors.black,
//               isFilled: false,
//               onTap: () {
//                 _openWhatsApp('9961593179');
//               },
//             ),
//             const SizedBox(width: 8),
//             _ActionButton(
//               icon: Icons.location_on,
//               label: 'Location',
//               color: Colors.red.shade700,
//               isFilled: false,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MapScreen(
//                       hostelName: _name,
//                       hostelAddress: _address,
//                       hostelLatitude: _latitude,
//                       hostelLongitude: _longitude,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _placeholderImage() {
//     return Container(
//       width: 90,
//       height: 90,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(Icons.hotel, color: Colors.grey),
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























import 'dart:async';
import 'dart:convert';
import 'package:brando_app/views/Map/map_screen.dart';
import 'package:brando_app/views/details/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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

  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  static const String _baseUrl =
      'http://31.97.206.144:2003/api/auth/search-filter-hostels';

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    if (value.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _errorMessage = null;
        _isLoading = false;
      });
      return;
    }

    _debounceTimer = Timer(_debounceDuration, () {
      _searchHostels(value);
    });
  }

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
    _debounceTimer?.cancel();
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
                            _debounceTimer?.cancel();
                            setState(() {
                              _searchResults = [];
                              _hasSearched = false;
                              _errorMessage = null;
                              _isLoading = false;
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {});
                  _onSearchChanged(value);
                },
              ),
            ),
            const SizedBox(height: 20),
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
              ),
            const SizedBox(height: 12),
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
                  : !_hasSearched
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
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

  Map<String, dynamic>? get _location => hostel['location'];

  double? get _latitude {
    if (_location == null) return null;
    final coords = _location!['coordinates'];
    if (coords == null || coords.length < 2) return null;
    return (coords[1] as num).toDouble();
  }

  double? get _longitude {
    if (_location == null) return null;
    final coords = _location!['coordinates'];
    if (coords == null || coords.length < 2) return null;
    return (coords[0] as num).toDouble();
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
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
        Row(
          children: [
            _ActionButton(
              icon: Icons.phone,
              label: 'Call',
              color: Colors.red.shade700,
              isFilled: true,
              onTap: () => _makePhoneCall('9961593179'),
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.chat,
              label: 'Whatsapp',
              color: Colors.black,
              isFilled: false,
              onTap: () => _openWhatsApp('9961593179'),
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.location_on,
              label: 'Location',
              color: Colors.red.shade700,
              isFilled: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      hostelName: _name,
                      hostelAddress: _address,
                      hostelLatitude: _latitude,
                      hostelLongitude: _longitude,
                    ),
                  ),
                );
              },
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
