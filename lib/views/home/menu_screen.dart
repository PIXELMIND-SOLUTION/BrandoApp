import 'package:brando_app/provider/auth/auth_provider.dart';
import 'package:brando_app/views/history/booking_history.dart';
import 'package:brando_app/views/profile/edit_profile.dart';
import 'package:brando_app/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});


  Future<void> _handleLogout(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    await context.read<AuthProvider>().logout();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Logged out successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
        (route) => false,
      );
    }
  }
}

  // Future<void> _handleLogout(BuildContext context) async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: const Text(
  //         'Logout',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       content: const Text('Are you sure you want to logout?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx, false),
  //           child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx, true),
  //           child: const Text(
  //             'Logout',
  //             style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmed == true && context.mounted) {
  //     await context.read<AuthProvider>().logout();
  //     if (context.mounted) {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (_) => const SplashScreen()),
  //         (route) => false,
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8, top: 4),
            child: Text(
              'Account',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingHistory()),
              );
            },
            child: _buildMenuItem(
              icon: Icons.history,
              title: 'Booking History',
            ),
          ),
          _buildMenuItem(icon: Icons.help_outline, title: 'Need Help?'),
          _buildMenuItem(icon: Icons.phone_outlined, title: 'Contact Us'),
          _buildMenuItem(icon: Icons.help_outline, title: 'Terms & Conditions'),
          _buildMenuItem(icon: Icons.phone_outlined, title: 'Privacy Policy'),
          GestureDetector(
            onTap: () => _handleLogout(context),
            child: _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isLogout = false,
  }) {
    final color = isLogout ? const Color(0xFFE53935) : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isLogout ? const Color(0xFFE53935) : Colors.black54,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}