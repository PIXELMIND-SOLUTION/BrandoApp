
// import 'package:brando_app/config/theme_config.dart';
// import 'package:brando_app/provider/navbar/navbar_provider.dart';
// import 'package:brando_app/provider/theme_provider.dart';
// import 'package:brando_app/views/Ecommerce/ecomerce.dart';
// import 'package:brando_app/views/history/booking_history.dart';
// import 'package:brando_app/views/home/home_screen.dart';
// import 'package:brando_app/views/home/menu_screen.dart';
// import 'package:brando_app/views/home/wishlist_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

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
//   final VoidCallback onCenterTap;

//   const CustomBottomNavbar({super.key, required this.onCenterTap});

//   static const _items = [
//     _NavItem(
//       icon: Icons.home_outlined,
//       activeIcon: Icons.home_rounded,
//       label: 'Home',
//     ),
//     _NavItem(
//       icon: Icons.favorite_border_rounded,
//       activeIcon: Icons.favorite_rounded,
//       label: 'Offers',
//     ),
//     _NavItem(
//       icon: Icons.king_bed_outlined,
//       activeIcon: Icons.king_bed_rounded,
//       label: 'Booked',
//     ),
//     _NavItem(
//       icon: Icons.menu_rounded,
//       activeIcon: Icons.menu_rounded,
//       label: 'Menu',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = context.watch<BottomNavbarProvider>().currentIndex;
//     final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

//     return Container(
//       decoration: BoxDecoration(
//         color: isDarkMode ? AppColors.darkCard : AppColors.lightBackground,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 24,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: SizedBox(
//           height: 64,
//           child: Stack(
//             clipBehavior: Clip.none, // allows child to overflow above the bar
//             children: [
//               // ── Nav items row (full width, leaves gap in center)
//               Row(
//                 children: [
//                   // Left two items
//                   Expanded(
//                     child: Row(
//                       children: List.generate(2, (index) {
//                         final item = _items[index];
//                         final isActive = index == currentIndex;
//                         return Expanded(
//                           child: _NavBarItem(
//                             item: item,
//                             isActive: isActive,
//                             onTap: () => context
//                                 .read<BottomNavbarProvider>()
//                                 .setIndex(index),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),

//                   // Empty space where center button sits
//                   const SizedBox(width: 72),

//                   // Right two items
//                   Expanded(
//                     child: Row(
//                       children: List.generate(2, (index) {
//                         final actualIndex = index + 2;
//                         final item = _items[actualIndex];
//                         final isActive = actualIndex == currentIndex;
//                         return Expanded(
//                           child: _NavBarItem(
//                             item: item,
//                             isActive: isActive,
//                             onTap: () => context
//                                 .read<BottomNavbarProvider>()
//                                 .setIndex(actualIndex),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),

//               // ── Center button — pops above the bar
//               Positioned(
//                 top: -26, // raise above the navbar top edge
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: GestureDetector(
//                     onTap: onCenterTap,
//                     behavior: HitTestBehavior.opaque,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // circular image with white ring + shadow
//                         Container(
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                           ),
//                           padding: const EdgeInsets.all(3),
//                           child: ClipOval(
//                             child: Image.asset(
//                               'assets/home.png', // Replace with your logo asset path
//                               width: 72,
//                               height: 72,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           'Shop Now',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: isDarkMode
//                                 ? AppColors.primary
//                                 : AppColors.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
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
//       duration: const Duration(milliseconds: 180),
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
//     final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
//     const activeColor = AppColors.primary;
//     final inactiveColor = isDarkMode
//         ? AppColors.darkTextSecondary
//         : const Color(0xFFB0B0B0);

//     return GestureDetector(
//       onTap: _handleTap,
//       behavior: HitTestBehavior.opaque,
//       child: ScaleTransition(
//         scale: _scaleAnim,
//         child: Center(
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 250),
//             curve: Curves.easeInOut,
//             margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             decoration: BoxDecoration(
//               color: widget.isActive
//                   ? activeColor.withOpacity(0.1)
//                   : Colors.transparent,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   widget.isActive ? widget.item.activeIcon : widget.item.icon,
//                   color: widget.isActive ? activeColor : inactiveColor,
//                   size: 20,
//                 ),
//                 if (widget.isActive)
//                   Padding(
//                     padding: const EdgeInsets.only(left: 4),
//                     child: Text(
//                       widget.item.label,
//                       maxLines: 1,
//                       overflow: TextOverflow.visible,
//                       style: const TextStyle(
//                         color: activeColor,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────
// // Navbar Screen
// // ─────────────────────────────────────────────────────────────

// class NavbarScreen extends StatefulWidget {
//   final int initialIndex;

//   const NavbarScreen({super.key, this.initialIndex = 0});

//   static const _pages = [
//     HomeScreen(),
//     AdminOffersScreen(),
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

//   void _onCenterTap() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => GroceryScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
//     final currentIndex = context.watch<BottomNavbarProvider>().currentIndex;

//     return Scaffold(
//       backgroundColor: isDarkMode
//           ? AppColors.darkBackground
//           : const Color(0xFFF8F8F8),
//       body: IndexedStack(index: currentIndex, children: NavbarScreen._pages),
//       bottomNavigationBar: CustomBottomNavbar(onCenterTap: _onCenterTap),
//     );
//   }
// }

















import 'package:brando_app/provider/navbar/navbar_provider.dart';
import 'package:brando_app/views/Ecommerce/ecomerce.dart';
import 'package:brando_app/views/history/booking_history.dart';
import 'package:brando_app/views/home/home_screen.dart';
import 'package:brando_app/views/home/menu_screen.dart';
import 'package:brando_app/views/home/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class CustomBottomNavbar extends StatelessWidget {
  final VoidCallback onCenterTap;

  const CustomBottomNavbar({super.key, required this.onCenterTap});

  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.format_list_bulleted,
      activeIcon: Icons.format_list_bulleted,
      label: 'Offer',
    ),
    _NavItem(
      icon: Icons.king_bed_outlined,
      activeIcon: Icons.analytics,
      label: 'Bookings',
    ),
    _NavItem(
      icon: Icons.menu_rounded,
      activeIcon: Icons.menu_rounded,
      label: 'Menu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<BottomNavbarProvider>().currentIndex;

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Curved notch background ──────────────
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 72),
                painter: _NotchBarPainter(),
              ),

              // ── Nav items row ─────────────────────────
              Row(
                children: [
                  // Left two items
                  Expanded(
                    child: Row(
                      children: List.generate(2, (index) {
                        final item = _items[index];
                        final isActive = index == currentIndex;
                        return Expanded(
                          child: _NavBarItem(
                            item: item,
                            isActive: isActive,
                            onTap: () => context
                                .read<BottomNavbarProvider>()
                                .setIndex(index),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Empty space where center button sits
                  const SizedBox(width: 92),

                  // Right two items
                  Expanded(
                    child: Row(
                      children: List.generate(2, (index) {
                        final actualIndex = index + 2;
                        final item = _items[actualIndex];
                        final isActive = actualIndex == currentIndex;
                        return Expanded(
                          child: _NavBarItem(
                            item: item,
                            isActive: isActive,
                            onTap: () => context
                                .read<BottomNavbarProvider>()
                                .setIndex(actualIndex),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),

              // ── Center image button — pops above the bar ──
              Positioned(
                top: -26,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onCenterTap,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/home copy.png',
                              width: 92,
                              height: 92,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NOTCH PAINTER — draws the curved dip
// around the center asset image
// ─────────────────────────────────────────────
class _NotchBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(_buildPath(size), shadowPaint);

    // White fill
    final fillPaint = Paint()
      ..color = const Color(0xFFF1FFF1)
      ..style = PaintingStyle.fill;
    canvas.drawPath(_buildPath(size), fillPaint);
  }

  Path _buildPath(Size size) {
    final double cx = size.width / 2;

    // Adjust these to match your image size (92x92 asset)
    const double notchHalfWidth = 50.0; // half of the notch opening
    const double notchDepth = 26.0; // how deep the curve dips
    const double curveSpread = 24.0; // smoothness of the transition

    return Path()
      ..moveTo(0, 0)
      ..lineTo(cx - notchHalfWidth - curveSpread, 0)
      // Left curve going DOWN into notch
      ..cubicTo(
        cx - notchHalfWidth - curveSpread / 2,
        0,
        cx - notchHalfWidth,
        notchDepth,
        cx,
        notchDepth,
      )
      // Right curve going UP out of notch
      ..cubicTo(
        cx + notchHalfWidth,
        notchDepth,
        cx + notchHalfWidth + curveSpread / 2,
        0,
        cx + notchHalfWidth + curveSpread,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// NAV BAR ITEM  — unchanged from your original
// ─────────────────────────────────────────────
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
      duration: const Duration(milliseconds: 180),
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
    const activeColor = Color(0xFFE84A4A);
    const inactiveColor = Color(0xFFB0B0B0);

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NAVBAR SCREEN — unchanged from your original
// ─────────────────────────────────────────────
class NavbarScreen extends StatefulWidget {
  final int initialIndex;

  const NavbarScreen({super.key, this.initialIndex = 0});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BottomNavbarProvider>().setIndex(widget.initialIndex);
      }
    });
  }

  void _onCenterTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroceryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<BottomNavbarProvider>().currentIndex;

    final pages = [
    HomeScreen(),
    AdminOffersScreen(),
    BookingHistory(),
    MenuScreen(),
      
    ];

    

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: CustomBottomNavbar(onCenterTap: _onCenterTap),
    );
  }
}
