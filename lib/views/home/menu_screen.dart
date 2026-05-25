// import 'package:brando_app/provider/auth/auth_provider.dart';
// import 'package:brando_app/provider/navbar/navbar_provider.dart';
// import 'package:brando_app/views/contact/contact_us.dart';
// import 'package:brando_app/views/delete%20account/delete_account.dart';
// import 'package:brando_app/views/help/help_screen.dart';
// import 'package:brando_app/views/history/booking_history.dart';
// import 'package:brando_app/views/profile/edit_profile.dart';
// import 'package:brando_app/views/splash/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MenuScreen extends StatelessWidget {
//   const MenuScreen({super.key});

//   Future<void> _handleLogout(BuildContext context) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Logout',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.black54),
//             ),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text(
//               'Logout',
//               style: TextStyle(
//                 color: Color(0xFFE53935),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true && context.mounted) {
//        context.read<BottomNavbarProvider>().setIndex(0);
//       await context.read<AuthProvider>().logout();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text('Logged out successfully'),
//             duration: Duration(seconds: 2),
//           ),
//         );

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const SplashScreen()),
//           (route) => false,
//         );
//       }
//     }
//   }

//   // Future<void> _handleLogout(BuildContext context) async {
//   //   final confirmed = await showDialog<bool>(
//   //     context: context,
//   //     builder: (ctx) => AlertDialog(
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//   //       title: const Text(
//   //         'Logout',
//   //         style: TextStyle(fontWeight: FontWeight.bold),
//   //       ),
//   //       content: const Text('Are you sure you want to logout?'),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(ctx, false),
//   //           child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
//   //         ),
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(ctx, true),
//   //           child: const Text(
//   //             'Logout',
//   //             style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );

//   //   if (confirmed == true && context.mounted) {
//   //     await context.read<AuthProvider>().logout();
//   //     if (context.mounted) {
//   //       Navigator.pushAndRemoveUntil(
//   //         context,
//   //         MaterialPageRoute(builder: (_) => const SplashScreen()),
//   //         (route) => false,
//   //       );
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//           onWillPop: () async {
//       final shouldExit = await showDialog<bool>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Exit'),
//           content: const Text('Are you sure you want to exit?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text('Yes'),
//             ),
//           ],
//         ),
//       );
//       return shouldExit ?? false;
//     },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: const Text(
//             'Discover',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Colors.black,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(left: 4, bottom: 8, top: 4),
//               child: Text(
//                 'Account',
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProfileScreen()),
//                 );
//               },
//               child: _buildMenuItem(
//                 icon: Icons.person_outline,
//                 title: 'Personal Information',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookingHistory()),
//                 );
//               },
//               child: _buildMenuItem(
//                 icon: Icons.history,
//                 title: 'Booking History',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HelpScreen()),
//                 );
//               },
//               child: _buildMenuItem(
//                 icon: Icons.help_outline,
//                 title: 'Need Help?',
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ContactUs()),
//                 );
//               },
//               child: _buildMenuItem(
//                 icon: Icons.phone_outlined,
//                 title: 'Contact Us',
//               ),
//             ),

//              GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DeleteAccount()),
//                 );
//               },
//               child: _buildMenuItem(
//                 icon: Icons.delete,
//                 title: 'Delete Account',
//               ),
//             ),

//             // GestureDetector(
//             //   onTap: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => MybookingScreen()),
//             //     );
//             //   },
//             //   child: _buildMenuItem(icon: Icons.book_online, title: 'Mybookings'),
//             // ),
//             _buildMenuItem(icon: Icons.help_outline, title: 'Terms & Conditions'),
//             _buildMenuItem(icon: Icons.phone_outlined, title: 'Privacy Policy'),
//             GestureDetector(
//               onTap: () => _handleLogout(context),
//               child: _buildMenuItem(
//                 icon: Icons.logout,
//                 title: 'Logout',
//                 isLogout: true,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     bool isLogout = false,
//   }) {
//     final color = isLogout ? const Color(0xFFE53935) : Colors.black87;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: color, size: 22),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: color,
//             fontSize: 15,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         trailing: Icon(
//           Icons.chevron_right,
//           color: isLogout ? const Color(0xFFE53935) : Colors.black54,
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//       ),
//     );
//   }
// }

import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/auth/auth_provider.dart';
import 'package:brando_app/provider/navbar/navbar_provider.dart';
import 'package:brando_app/views/Ecommerce/all_hostel_screen.dart';
import 'package:brando_app/views/contact/contact_us.dart';
import 'package:brando_app/views/delete%20account/delete_account.dart';
import 'package:brando_app/views/history/booking_history.dart';
import 'package:brando_app/views/navbar/navbar_screen.dart';
import 'package:brando_app/views/profile/edit_profile.dart';
import 'package:brando_app/views/splash/splash_screen.dart';
import 'package:brando_app/widgets/app_back_control.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the link. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logout icon
              Image.asset(
                'assets/logout_2.png', // replace with your 3D icon asset
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 24),

              // Message
              const Text(
                'Are you sure you want to\nlogout of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // "Naah, Just Kidding" button (gradient filled)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE53935), Color(0xFFFF8A80)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Naah, Just Kidding',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // "Yes, Log me out!" button (outlined)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFE53935),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Yes, Log me out!',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      // 1. Clear all SharedPreferences
      await AppPreferences.clearAll();

      // 2. Reset bottom nav to index 0
      context.read<BottomNavbarProvider>().setIndex(0);

      // 3. Clear / reset all provider data
      await context.read<AuthProvider>().logout();

      // Add any other providers that need resetting, e.g.:
      // context.read<CartProvider>().clear();
      // context.read<UserProvider>().clear();

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

  @override
  Widget build(BuildContext context) {
    return AppBackControl(
        showConfirmationDialog: true,
      dialogTitle: 'Exit App?',
      dialogMessage: 'Are you sure you want to exit the app?',
      confirmText: 'Exit',
      cancelText: 'Stay',
      onBackPressed: () {
        print('User exiting app');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Menu',
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
                  MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
                );
              },
              child: _buildMenuItem(icon: Icons.history, title: 'My Orders'),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => NavbarScreen(initialIndex: 2),
            //       ),
            //     );
            //   },
            //   child: _buildMenuItem(
            //     icon: Icons.history,
            //     title: 'Booking History',
            //   ),
            // ),
            GestureDetector(
              onTap: () => _launchURL(
                context,
                'https://brando-user-policy.onrender.com/contact',
              ),
              child: _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Need Help?',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUs()),
                );
              },
              child: _buildMenuItem(
                icon: Icons.phone_outlined,
                title: 'Contact Us',
              ),
            ),
  
            GestureDetector(
              onTap: () => _launchURL(
                context,
                'https://brando-user-policy.onrender.com/terms-and-conditions',
              ),
              child: _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Terms & Conditions',
              ),
            ),
            GestureDetector(
              onTap: () => _launchURL(
                context,
                'https://brando-user-policy.onrender.com/privacy-and-policy',
              ),
              child: _buildMenuItem(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
              ),
            ),
                      GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteAccount()),
                );
              },
              child: _buildMenuItem(
                icon: Icons.delete,
                title: 'Delete Account',
                                isLogout: true,

              ),
            ),
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
