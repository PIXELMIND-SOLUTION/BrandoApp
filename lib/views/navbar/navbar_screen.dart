import 'package:brando_app/provider/navbar/navbar_provider.dart';
import 'package:brando_app/views/home/booking_screen.dart';
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

// ─── Bottom Navbar Widget ────────────────────────────────────────────────────

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
      label: 'Menu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BottomNavbarProvider>();
    final currentIndex = provider.currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;

              // ✅ FIX: Give active item more flex space so it doesn't overflow
              return Expanded(
                flex: isActive ? 2 : 1,
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
    );
  }
}

// ─── Individual Nav Item ─────────────────────────────────────────────────────

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
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
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
    const activeBg = Color(0xFFFFF0F0);

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        // ✅ FIX: Center the pill within the expanded slot
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            // ✅ FIX: Reduced margin & padding to prevent overflow
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isActive ? activeBg : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            // ✅ FIX: Constrain width so it never exceeds available space
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isActive
                        ? widget.item.activeIcon
                        : widget.item.icon,
                    key: ValueKey(widget.isActive),
                    color: widget.isActive ? activeColor : inactiveColor,
                    size: 22,
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: widget.isActive
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            widget.item.label,
                            style: const TextStyle(
                              color: activeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                             softWrap: false,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── NavbarScreen ─────────────────────────────────────────────────────────────

class NavbarScreen extends StatelessWidget {
  const NavbarScreen({super.key});

static const _pages = [
  HomeScreen(),
  WishlistScreen(),
  BookingScreen(),
  MenuScreen(),
];


  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<BottomNavbarProvider>().currentIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: const CustomBottomNavbar(),
    );
  }
}

// ─── Placeholder Pages ────────────────────────────────────────────────────────

class _PlaceholderPage extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PlaceholderPage({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: const Color(0xFFE84A4A)),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}