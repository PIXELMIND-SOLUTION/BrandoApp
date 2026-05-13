// import 'package:brando_app/provider/navbar/navbar_provider.dart';
// import 'package:brando_app/views/history/booking_history.dart';
// // import 'package:brando_app/views/home/booking_screen.dart';
// import 'package:brando_app/views/home/home_screen.dart';
// import 'package:brando_app/views/home/menu_screen.dart';
// import 'package:brando_app/views/home/wishlist_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class _NavItem {
//   final IconData icon;
//   final IconData activeIcon;
//   final String label;

//   const _NavItem({
//     required this.icon,
//     required this.activeIcon,
//     required this.label,
//   });
// }

// // ─────────────────────────────────────────────────────────────
// // Bottom Navbar
// // ─────────────────────────────────────────────────────────────

// class CustomBottomNavbar extends StatelessWidget {
//   const CustomBottomNavbar({super.key});

//   // Only 4 items - Home, Wishlist, Bookings, Discover
//   // Scanner will be handled by FAB
//   static const _items = [
//     _NavItem(
//       icon: Icons.home_outlined,
//       activeIcon: Icons.home_rounded,
//       label: 'Home',
//     ),
//     _NavItem(
//       icon: Icons.favorite_border_rounded,
//       activeIcon: Icons.favorite_rounded,
//       label: 'Wishlist',
//     ),
//     _NavItem(
//       icon: Icons.king_bed_outlined,
//       activeIcon: Icons.king_bed_rounded,
//       label: 'Bookings',
//     ),
//     _NavItem(
//       icon: Icons.menu_rounded,
//       activeIcon: Icons.menu_rounded,
//       label: 'Discover',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BottomNavbarProvider>();
//     final currentIndex = provider.currentIndex;

//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.bottomCenter,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 20,
//                 offset: const Offset(0, -4),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             top: false,
//             child: SizedBox(
//               height: 70,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: List.generate(_items.length, (index) {
//                   final item = _items[index];
//                   final isActive = index == currentIndex;

//                   return Expanded(
//                     child: _NavBarItem(
//                       item: item,
//                       isActive: isActive,
//                       onTap: () => provider.setIndex(index),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ),
//         // Floating Action Button in Center
//         Positioned(
//           top: -30,
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const QRScannerScreen(),
//                 ),
//               );
//             },
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFFEF5350),
//                     Color(0xFFC62828),
//                     Color(0xFFB71C1C),
//                   ],
//                 ),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.red.withOpacity(0.4),
//                     blurRadius: 15,
//                     spreadRadius: 3,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.qr_code_scanner,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────
// // Individual Nav Item
// // ─────────────────────────────────────────────────────────────

// class _NavBarItem extends StatefulWidget {
//   final _NavItem item;
//   final bool isActive;
//   final VoidCallback onTap;

//   const _NavBarItem({
//     required this.item,
//     required this.isActive,
//     required this.onTap,
//   });

//   @override
//   State<_NavBarItem> createState() => _NavBarItemState();
// }

// class _NavBarItemState extends State<_NavBarItem>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _scaleAnim;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 150),
//     );
//     _scaleAnim = Tween<double>(
//       begin: 1.0,
//       end: 0.92,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleTap() {
//     _controller.forward().then((_) => _controller.reverse());
//     widget.onTap();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const activeColor = Color(0xFFE84A4A);
//     const inactiveColor = Color(0xFFB0B0B0);

//     return GestureDetector(
//       onTap: _handleTap,
//       behavior: HitTestBehavior.opaque,
//       child: ScaleTransition(
//         scale: _scaleAnim,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               widget.isActive ? widget.item.activeIcon : widget.item.icon,
//               color: widget.isActive ? activeColor : inactiveColor,
//               size: 24,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               widget.item.label,
//               style: TextStyle(
//                 color: widget.isActive ? activeColor : inactiveColor,
//                 fontSize: 11,
//                 fontWeight: widget.isActive
//                     ? FontWeight.w600
//                     : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────
// // QR Scanner Screen (Professional)
// // ─────────────────────────────────────────────────────────────

// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});

//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen>
//     with SingleTickerProviderStateMixin {
//   final MobileScannerController _controller = MobileScannerController();
//   bool _isScanning = true;
//   late AnimationController _animationController;
//   late Animation<double> _scanAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.linear),
//     );
//     _animationController.repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.close, color: Colors.white, size: 28),
//         ),
//         title: const Text(
//           'Scan QR Code',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           // Full-screen scanner
//           MobileScanner(
//             controller: _controller,
//             fit: BoxFit.cover,
//             onDetect: (capture) {
//               if (!_isScanning) return;

//               final List<Barcode> barcodes = capture.barcodes;
//               for (final barcode in barcodes) {
//                 if (barcode.rawValue != null) {
//                   _isScanning = false;
//                   _controller.stop();
//                   _handleQRCode(barcode.rawValue!);
//                   break;
//                 }
//               }
//             },
//           ),
//           // Scanner overlay with larger scan area
//           _buildScannerOverlay(),
//           // Scan line animation
//           _buildScanLine(),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         color: Colors.black.withOpacity(0.9),
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildControlButton(
//               icon: Icons.flashlight_on,
//               label: 'Flash',
//               onPressed: () => _controller.toggleTorch(),
//             ),
//             _buildControlButton(
//               icon: Icons.cameraswitch,
//               label: 'Switch',
//               onPressed: () => _controller.switchCamera(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             onPressed: onPressed,
//             icon: Icon(icon, color: Colors.white, size: 28),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildScannerOverlay() {
//     return Container(
//       color: Colors.black.withOpacity(0.6),
//       child: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.8,
//           height: MediaQuery.of(context).size.width * 0.8,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
//           child: Stack(
//             children: [
//               // Transparent center
//               ClipPath(
//                 clipper: _ScannerClipper(
//                   rectSize: MediaQuery.of(context).size.width * 0.8,
//                 ),
//                 child: Container(color: Colors.transparent),
//               ),
//               // Corner borders
//               _buildCornerBorder(Alignment.topLeft, -1, -1, Alignment.topLeft),
//               _buildCornerBorder(Alignment.topRight, 1, -1, Alignment.topRight),
//               _buildCornerBorder(
//                 Alignment.bottomLeft,
//                 -1,
//                 1,
//                 Alignment.bottomLeft,
//               ),
//               _buildCornerBorder(
//                 Alignment.bottomRight,
//                 1,
//                 1,
//                 Alignment.bottomRight,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCornerBorder(
//     Alignment alignment,
//     double xSign,
//     double ySign,
//     Alignment gradientAlignment,
//   ) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: gradientAlignment,
//             end: Alignment.center,
//             colors: const [Color(0xFFEF5350), Colors.transparent],
//           ),
//         ),
//         child: CustomPaint(painter: _CornerPainter(xSign, ySign)),
//       ),
//     );
//   }

//   Widget _buildScanLine() {
//     return AnimatedBuilder(
//       animation: _scanAnimation,
//       builder: (context, child) {
//         final position =
//             MediaQuery.of(context).size.width * 0.1 +
//             (_scanAnimation.value * MediaQuery.of(context).size.width * 0.7);
//         return Positioned(
//           top: position,
//           left: MediaQuery.of(context).size.width * 0.1,
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             height: 2,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   Color(0xFFEF5350),
//                   Colors.transparent,
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFFEF5350).withOpacity(0.5),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _handleQRCode(String code) async {
//     final isUrl = _isValidUrl(code);

//     showModalBottomSheet(
//       context: context,
//       isDismissible: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: false,
//       builder: (context) => _QRResultModal(
//         qrCode: code,
//         isUrl: isUrl,
//         onClose: () {
//           Navigator.pop(context); // Close modal
//           Navigator.pop(context); // Close scanner
//         },
//         onScanAgain: () {
//           Navigator.pop(context); // Close modal
//           setState(() {
//             _isScanning = true;
//             _controller.start();
//           });
//         },
//         onOpenUrl: isUrl
//             ? () async {
//                 await _launchUrl(code);
//                 Navigator.pop(context); // Close modal
//                 Navigator.pop(context); // Close scanner
//               }
//             : null,
//       ),
//     );
//   }

//   bool _isValidUrl(String url) {
//     // Check if it's a valid URL with http/https scheme
//     try {
//       final uri = Uri.parse(url);
//       return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> _launchUrl(String url) async {
//     Uri uri = Uri.parse(url);

//     // Ensure URL has scheme
//     if (!uri.hasScheme) {
//       uri = Uri.parse('https://$url');
//     }

//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(
//           uri,
//           mode: LaunchMode.externalApplication,
//           webViewConfiguration: const WebViewConfiguration(
//             enableJavaScript: true,
//             enableDomStorage: true,
//           ),
//         );
//       } else {
//         // Show error if can't launch
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Could not open URL'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error launching URL: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error opening URL: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────
// // Professional QR Result Modal (Compact Version)
// // ─────────────────────────────────────────────────────────────

// class _QRResultModal extends StatelessWidget {
//   final String qrCode;
//   final bool isUrl;
//   final VoidCallback onClose;
//   final VoidCallback onScanAgain;
//   final VoidCallback? onOpenUrl;

//   const _QRResultModal({
//     required this.qrCode,
//     required this.isUrl,
//     required this.onClose,
//     required this.onScanAgain,
//     this.onOpenUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 20,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Success Icon (Smaller)
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFEF5350), Color(0xFFC62828)],
//                 ),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFEF5350).withOpacity(0.3),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.check_rounded,
//                 color: Colors.white,
//                 size: 32,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Title (Smaller)
//             const Text(
//               'QR Code Scanned!',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF1A1A1A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),

//             // Subtitle (Smaller)
//             Text(
//               isUrl ? 'Link detected' : 'Data detected',
//               style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),

//             // QR Content Container (Compact)
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         isUrl ? Icons.link_rounded : Icons.qr_code,
//                         size: 14,
//                         color: Colors.grey[600],
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         isUrl ? 'Scanned Link:' : 'Scanned Content:',
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[600],
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   SelectableText(
//                     qrCode,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: isUrl ? const Color(0xFFEF5350) : Colors.black87,
//                       fontWeight: isUrl ? FontWeight.w600 : FontWeight.normal,
//                     ),
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Action Buttons (Compact)
//             if (isUrl)
//               Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: onOpenUrl,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFEF5350),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         'Open Link',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextButton(
//                           onPressed: onScanAgain,
//                           style: TextButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                           ),
//                           child: const Text(
//                             'Scan Again',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Color(0xFFEF5350),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: TextButton(
//                           onPressed: onClose,
//                           style: TextButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                           ),
//                           child: const Text(
//                             'Close',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             else
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: onScanAgain,
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: const Color(0xFFEF5350),
//                         side: const BorderSide(color: Color(0xFFEF5350)),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: const Text(
//                         'Scan Again',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: onClose,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFEF5350),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: const Text(
//                         'Close',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────
// // Custom Painters for Scanner Overlay
// // ─────────────────────────────────────────────────────────────

// class _ScannerClipper extends CustomClipper<Path> {
//   final double rectSize;

//   _ScannerClipper({required this.rectSize});

//   @override
//   Path getClip(Size size) {
//     final path = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..addRect(
//         Rect.fromLTWH(
//           (size.width - rectSize) / 2,
//           (size.height - rectSize) / 2,
//           rectSize,
//           rectSize,
//         ),
//       )
//       ..fillType = PathFillType.evenOdd;
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

// class _CornerPainter extends CustomPainter {
//   final double xSign;
//   final double ySign;

//   _CornerPainter(this.xSign, this.ySign);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFEF5350)
//       ..strokeWidth = 4
//       ..style = PaintingStyle.stroke;

//     final path = Path();

//     if (xSign == -1 && ySign == -1) {
//       // Top-left
//       path.moveTo(0, size.height);
//       path.lineTo(0, size.height * 0.3);
//       path.lineTo(size.width * 0.3, 0);
//       path.lineTo(size.width, 0);
//     } else if (xSign == 1 && ySign == -1) {
//       // Top-right
//       path.moveTo(0, 0);
//       path.lineTo(size.width * 0.7, 0);
//       path.lineTo(size.width, size.height * 0.3);
//       path.lineTo(size.width, size.height);
//     } else if (xSign == -1 && ySign == 1) {
//       // Bottom-left
//       path.moveTo(0, 0);
//       path.lineTo(0, size.height * 0.7);
//       path.lineTo(size.width * 0.3, size.height);
//       path.lineTo(size.width, size.height);
//     } else {
//       // Bottom-right
//       path.moveTo(size.width, 0);
//       path.lineTo(size.width, size.height * 0.7);
//       path.lineTo(size.width * 0.7, size.height);
//       path.lineTo(0, size.height);
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ─────────────────────────────────────────────────────────────
// // Navbar Screen
// // ─────────────────────────────────────────────────────────────

// class NavbarScreen extends StatefulWidget {
//   final int initialIndex;

//   const NavbarScreen({super.key, this.initialIndex = 0});

//   static const _pages = [
//     HomeScreen(),
//     WishlistScreen(),

//     // BookingScreen(),
//     BookingHistory(),
//     MenuScreen(),
//   ];

//   @override
//   State<NavbarScreen> createState() => _NavbarScreenState();
// }

// class _NavbarScreenState extends State<NavbarScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BottomNavbarProvider>().setIndex(widget.initialIndex);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BottomNavbarProvider>(
//       builder: (context, provider, _) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF8F8F8),
//           body: IndexedStack(
//             index: provider.currentIndex,
//             children: NavbarScreen._pages,
//           ),
//           bottomNavigationBar: const CustomBottomNavbar(),
//         );
//       },
//     );
//   }
// }

import 'package:brando_app/config/theme_config.dart';
import 'package:brando_app/provider/navbar/navbar_provider.dart';
import 'package:brando_app/provider/theme_provider.dart';
import 'package:brando_app/views/history/booking_history.dart';
import 'package:brando_app/views/home/home_screen.dart';
import 'package:brando_app/views/home/menu_screen.dart';
import 'package:brando_app/views/home/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ─────────────────────────────────────────────────────────────
// Bottom Navbar
// ─────────────────────────────────────────────────────────────

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Wishlist',
    ),
    _NavItem(
      icon: Icons.king_bed_outlined,
      activeIcon: Icons.king_bed_rounded,
      label: 'Bookings',
    ),
    _NavItem(
      icon: Icons.menu_rounded,
      activeIcon: Icons.menu_rounded,
      label: 'Discover',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BottomNavbarProvider>();
    final currentIndex = provider.currentIndex;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.lightBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final isActive = index == currentIndex;

                  return Expanded(
                    child: _NavBarItem(
                      item: item,
                      isActive: isActive,
                      onTap: () => provider.setIndex(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        Positioned(
          top: -30,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerScreen(),
                ),
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Individual Nav Item
// ─────────────────────────────────────────────────────────────

class _NavBarItem extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    const activeColor = AppColors.primary;
    final inactiveColor = isDarkMode
        ? AppColors.darkTextSecondary
        : const Color(0xFFB0B0B0);

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.isActive ? widget.item.activeIcon : widget.item.icon,
              color: widget.isActive ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              widget.item.label,
              style: TextStyle(
                color: widget.isActive ? activeColor : inactiveColor,
                fontSize: 11,
                fontWeight: widget.isActive
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// QR Scanner Screen (Professional)
// ─────────────────────────────────────────────────────────────

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanning = true;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              if (!_isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _isScanning = false;
                  _controller.stop();
                  _handleQRCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          _buildScannerOverlay(),
          _buildScanLine(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(0.9),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: Icons.flashlight_on,
              label: 'Flash',
              onPressed: () => _controller.toggleTorch(),
            ),
            _buildControlButton(
              icon: Icons.cameraswitch,
              label: 'Switch',
              onPressed: () => _controller.switchCamera(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Stack(
            children: [
              ClipPath(
                clipper: _ScannerClipper(
                  rectSize: MediaQuery.of(context).size.width * 0.8,
                ),
                child: Container(color: Colors.transparent),
              ),
              _buildCornerBorder(Alignment.topLeft, -1, -1, Alignment.topLeft),
              _buildCornerBorder(Alignment.topRight, 1, -1, Alignment.topRight),
              _buildCornerBorder(
                Alignment.bottomLeft,
                -1,
                1,
                Alignment.bottomLeft,
              ),
              _buildCornerBorder(
                Alignment.bottomRight,
                1,
                1,
                Alignment.bottomRight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerBorder(
    Alignment alignment,
    double xSign,
    double ySign,
    Alignment gradientAlignment,
  ) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: gradientAlignment,
            end: Alignment.center,
            colors: [AppColors.primary, Colors.transparent],
          ),
        ),
        child: CustomPaint(painter: _CornerPainter(xSign, ySign)),
      ),
    );
  }

  Widget _buildScanLine() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        final position =
            MediaQuery.of(context).size.width * 0.1 +
            (_scanAnimation.value * MediaQuery.of(context).size.width * 0.7);
        return Positioned(
          top: position,
          left: MediaQuery.of(context).size.width * 0.1,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primary,
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleQRCode(String code) async {
    final isUrl = _isValidUrl(code);

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (context) => _QRResultModal(
        qrCode: code,
        isUrl: isUrl,
        onClose: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onScanAgain: () {
          Navigator.pop(context);
          setState(() {
            _isScanning = true;
            _controller.start();
          });
        },
        onOpenUrl: isUrl
            ? () async {
                await _launchUrl(code);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!uri.hasScheme) {
      uri = Uri.parse('https://$url');
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open URL'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening URL: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Professional QR Result Modal (Compact Version)
// ─────────────────────────────────────────────────────────────

class _QRResultModal extends StatelessWidget {
  final String qrCode;
  final bool isUrl;
  final VoidCallback onClose;
  final VoidCallback onScanAgain;
  final VoidCallback? onOpenUrl;

  const _QRResultModal({
    required this.qrCode,
    required this.isUrl,
    required this.onClose,
    required this.onScanAgain,
    this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'QR Code Scanned!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.darkText
                    : const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isUrl ? 'Link detected' : 'Data detected',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDarkMode ? AppColors.darkBorder : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isUrl ? Icons.link_rounded : Icons.qr_code,
                        size: 14,
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isUrl ? 'Scanned Link:' : 'Scanned Content:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : Colors.grey[600],
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    qrCode,
                    style: TextStyle(
                      fontSize: 12,
                      color: isUrl
                          ? AppColors.primary
                          : (isDarkMode ? AppColors.darkText : Colors.black87),
                      fontWeight: isUrl ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (isUrl)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onOpenUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Open Link',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: onScanAgain,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text(
                            'Scan Again',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: onClose,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onScanAgain,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Scan Again',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 14),
                      ),
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

// ─────────────────────────────────────────────────────────────
// Custom Painters for Scanner Overlay
// ─────────────────────────────────────────────────────────────

class _ScannerClipper extends CustomClipper<Path> {
  final double rectSize;

  _ScannerClipper({required this.rectSize});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(
        Rect.fromLTWH(
          (size.width - rectSize) / 2,
          (size.height - rectSize) / 2,
          rectSize,
          rectSize,
        ),
      )
      ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _CornerPainter extends CustomPainter {
  final double xSign;
  final double ySign;

  _CornerPainter(this.xSign, this.ySign);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (xSign == -1 && ySign == -1) {
      path.moveTo(0, size.height);
      path.lineTo(0, size.height * 0.3);
      path.lineTo(size.width * 0.3, 0);
      path.lineTo(size.width, 0);
    } else if (xSign == 1 && ySign == -1) {
      path.moveTo(0, 0);
      path.lineTo(size.width * 0.7, 0);
      path.lineTo(size.width, size.height * 0.3);
      path.lineTo(size.width, size.height);
    } else if (xSign == -1 && ySign == 1) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height * 0.7);
      path.lineTo(size.width * 0.3, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height * 0.7);
      path.lineTo(size.width * 0.7, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
// Navbar Screen
// ─────────────────────────────────────────────────────────────

class NavbarScreen extends StatefulWidget {
  final int initialIndex;

  const NavbarScreen({super.key, this.initialIndex = 0});

  static const _pages = [
    HomeScreen(),
    WishlistScreen(),
    BookingHistory(),
    MenuScreen(),
  ];

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BottomNavbarProvider>().setIndex(widget.initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Consumer<BottomNavbarProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: isDarkMode
              ? AppColors.darkBackground
              : const Color(0xFFF8F8F8),
          body: IndexedStack(
            index: provider.currentIndex,
            children: NavbarScreen._pages,
          ),
          bottomNavigationBar: const CustomBottomNavbar(),
        );
      },
    );
  }
}
