import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/auth/auth_provider.dart';
import 'package:brando_app/provider/auth/profile_provider.dart';
import 'package:brando_app/provider/booking/booking_provider.dart';
import 'package:brando_app/provider/booking/submit_form_provider.dart';
import 'package:brando_app/provider/location/location_provider.dart';
import 'package:brando_app/provider/navbar/navbar_provider.dart';
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
        ChangeNotifierProvider(create: (_) => BottomNavbarProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HostelProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => HostelBookingProvider()),
        ChangeNotifierProvider(create: (_) => UpgradeBookingProvider()),
      ],
      child: MaterialApp(
        title: 'BRANDO APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
