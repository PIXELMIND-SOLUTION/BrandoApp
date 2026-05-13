import 'package:brando_app/config/theme_config.dart';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/auth/auth_provider.dart';
import 'package:brando_app/provider/auth/profile_provider.dart';
import 'package:brando_app/provider/booking/booking_provider.dart';
import 'package:brando_app/provider/booking/submit_form_provider.dart';
import 'package:brando_app/provider/category/category_provider.dart';
import 'package:brando_app/provider/location/location_provider.dart';
import 'package:brando_app/provider/navbar/navbar_provider.dart';
import 'package:brando_app/provider/theme_provider.dart';
import 'package:brando_app/provider/upgrade/upgrade_provider.dart';
import 'package:brando_app/provider/wishlist/wishlist_provider.dart';
import 'package:brando_app/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavbarProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HostelProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => HostelBookingProvider()),
        ChangeNotifierProvider(create: (_) => UpgradeBookingProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Brando App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
