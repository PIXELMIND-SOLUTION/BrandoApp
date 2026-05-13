// // import 'dart:async';
// // import 'package:brando_app/provider/auth/auth_provider.dart';
// // import 'package:brando_app/views/navbar/navbar_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:provider/provider.dart';

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen>
// //     with TickerProviderStateMixin {
// //   late AnimationController _mainController;
// //   late AnimationController _floatController;
// //   late AnimationController _pulseController;
// //   late Animation<double> _topImageScale;
// //   late Animation<double> _topImageOpacity;
// //   late Animation<double> _bottomLeftImageScale;
// //   late Animation<double> _bottomLeftImageOpacity;
// //   late Animation<double> _centerImageScale;
// //   late Animation<double> _centerImageOpacity;
// //   late Animation<Offset> _fabSlide;
// //   late Animation<double> _fabScale;
// //   late Animation<Offset> _textSlide;
// //   late Animation<double> _textOpacity;
// //   late Animation<Offset> _subtitleSlide;
// //   late Animation<double> _subtitleOpacity;
// //   late Animation<Offset> _buttonSlide;
// //   late Animation<double> _buttonOpacity;
// //   late Animation<double> _floatY;
// //   late Animation<double> _pulse;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _mainController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1800),
// //     );

// //     _floatController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 3000),
// //     )..repeat(reverse: true);

// //     _pulseController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1500),
// //     )..repeat(reverse: true);

// //     _topImageOpacity = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
// //       ),
// //     );
// //     _topImageScale = Tween<double>(begin: 0.5, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
// //       ),
// //     );

// //     _bottomLeftImageOpacity = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
// //       ),
// //     );
// //     _bottomLeftImageScale = Tween<double>(begin: 0.5, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
// //       ),
// //     );

// //     _centerImageOpacity = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
// //       ),
// //     );
// //     _centerImageScale = Tween<double>(begin: 0.7, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
// //       ),
// //     );

// //     _fabSlide = Tween<Offset>(begin: const Offset(0.5, 0.5), end: Offset.zero)
// //         .animate(
// //           CurvedAnimation(
// //             parent: _mainController,
// //             curve: const Interval(0.5, 0.75, curve: Curves.easeOutBack),
// //           ),
// //         );
// //     _fabScale = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.5, 0.75, curve: Curves.elasticOut),
// //       ),
// //     );

// //     _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
// //         .animate(
// //           CurvedAnimation(
// //             parent: _mainController,
// //             curve: const Interval(0.55, 0.8, curve: Curves.easeOut),
// //           ),
// //         );
// //     _textOpacity = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.55, 0.8, curve: Curves.easeOut),
// //       ),
// //     );

// //     _subtitleSlide =
// //         Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
// //           CurvedAnimation(
// //             parent: _mainController,
// //             curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
// //           ),
// //         );
// //     _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
// //       ),
// //     );

// //     _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
// //         .animate(
// //           CurvedAnimation(
// //             parent: _mainController,
// //             curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
// //           ),
// //         );
// //     _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _mainController,
// //         curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
// //       ),
// //     );

// //     _floatY = Tween<double>(begin: -8, end: 8).animate(
// //       CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
// //     );

// //     _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
// //       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
// //     );

// //     Future.delayed(const Duration(milliseconds: 200), () {
// //       if (mounted) _mainController.forward();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _mainController.dispose();
// //     _floatController.dispose();
// //     _pulseController.dispose();
// //     super.dispose();
// //   }

// //   void _goToLogin() {
// //     Navigator.of(context).push(
// //       PageRouteBuilder(
// //         pageBuilder: (context, animation, secondaryAnimation) =>
// //             const LoginScreen(),
// //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //           return SlideTransition(
// //             position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
// //                 .animate(
// //                   CurvedAnimation(
// //                     parent: animation,
// //                     curve: Curves.easeOutCubic,
// //                   ),
// //                 ),
// //             child: child,
// //           );
// //         },
// //         transitionDuration: const Duration(milliseconds: 500),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Stack(
// //           children: [
// //             // Top-right small oval image
// //             Positioned(
// //               top: -10,
// //               right: -20,
// //               child: AnimatedBuilder(
// //                 animation: Listenable.merge([_mainController, _floatController]),
// //                 builder: (context, child) {
// //                   return Transform.translate(
// //                     offset: Offset(0, _floatY.value * 0.6),
// //                     child: Opacity(
// //                       opacity: _topImageOpacity.value,
// //                       child: Transform.scale(
// //                         scale: _topImageScale.value,
// //                         child: child,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //                 child: const _OvalImage(
// //                   imagePath: 'assets/splashimage.png',
// //                   width: 120,
// //                   height: 155,
// //                   borderRadius: 65,
// //                   rotate: 0.15,
// //                 ),
// //               ),
// //             ),

// //             // Bottom-left small oval image
// //             Positioned(
// //               top: size.height * 0.28,
// //               left: -25,
// //               child: AnimatedBuilder(
// //                 animation: Listenable.merge([_mainController, _floatController]),
// //                 builder: (context, child) {
// //                   return Transform.translate(
// //                     offset: Offset(0, -_floatY.value * 0.8),
// //                     child: Opacity(
// //                       opacity: _bottomLeftImageOpacity.value,
// //                       child: Transform.scale(
// //                         scale: _bottomLeftImageScale.value,
// //                         child: child,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //                 child: const _OvalImage(
// //                   imagePath: 'assets/splashimage.png',
// //                   width: 110,
// //                   height: 140,
// //                   borderRadius: 60,
// //                   rotate: -0.1,
// //                 ),
// //               ),
// //             ),

// //             // Center large oval image
// //             Positioned(
// //               top: size.height * 0.04,
// //               left: size.width * 0.08,
// //               right: size.width * 0.08,
// //               child: AnimatedBuilder(
// //                 animation: Listenable.merge([_mainController, _floatController]),
// //                 builder: (context, child) {
// //                   return Transform.translate(
// //                     offset: Offset(0, _floatY.value * 0.4),
// //                     child: Opacity(
// //                       opacity: _centerImageOpacity.value,
// //                       child: Transform.scale(
// //                         scale: _centerImageScale.value,
// //                         child: child,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //                 child: _OvalImage(
// //                   imagePath: 'assets/splashimage.png',
// //                   width: double.infinity,
// //                   height: size.height * 0.38,
// //                   borderRadius: 999,
// //                   rotate: 0,
// //                 ),
// //               ),
// //             ),

// //             // Red FAB arrow
// //             Positioned(
// //               top: size.height * 0.33,
// //               right: size.width * 0.12,
// //               child: AnimatedBuilder(
// //                 animation: Listenable.merge([_mainController, _pulseController]),
// //                 builder: (context, child) {
// //                   return SlideTransition(
// //                     position: _fabSlide,
// //                     child: Transform.scale(
// //                       scale: _fabScale.value * _pulse.value,
// //                       child: child,
// //                     ),
// //                   );
// //                 },
// //                 child: Container(
// //                   width: 52,
// //                   height: 52,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFFE53935),
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: const Color(0xFFE53935).withOpacity(0.45),
// //                         blurRadius: 18,
// //                         spreadRadius: 2,
// //                         offset: const Offset(0, 6),
// //                       ),
// //                     ],
// //                   ),
// //                   child: const Icon(
// //                     Icons.arrow_outward_rounded,
// //                     color: Colors.white,
// //                     size: 26,
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             // Bottom content
// //             Positioned(
// //               bottom: 0,
// //               left: 0,
// //               right: 0,
// //               child: Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 28),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     SlideTransition(
// //                       position: _textSlide,
// //                       child: FadeTransition(
// //                         opacity: _textOpacity,
// //                         child: RichText(
// //                           textAlign: TextAlign.center,
// //                           text: const TextSpan(
// //                             style: TextStyle(
// //                               fontSize: 28,
// //                               fontWeight: FontWeight.w700,
// //                               color: Color(0xFF1A1A2E),
// //                               height: 1.25,
// //                               letterSpacing: -0.3,
// //                             ),
// //                             children: [
// //                               TextSpan(text: 'Redefining Your\n'),
// //                               TextSpan(
// //                                 text: 'Hostel Booking ',
// //                                 style: TextStyle(color: Color(0xFFF80500)),
// //                               ),
// //                               TextSpan(text: 'Experience'),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 14),
// //                     SlideTransition(
// //                       position: _subtitleSlide,
// //                       child: FadeTransition(
// //                         opacity: _subtitleOpacity,
// //                         child: const Text(
// //                           'A hostel booking app should feature quick user registration, searchable listings with filters',
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: Color(0xFF7A7A8C),
// //                             height: 1.6,
// //                             fontWeight: FontWeight.w400,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 32),
// //                     SlideTransition(
// //                       position: _buttonSlide,
// //                       child: FadeTransition(
// //                         opacity: _buttonOpacity,
// //                         child: _RedButton(
// //                           label: "Let's Get Started",
// //                           onTap: _goToLogin,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 36),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ═══════════════════════════════════════════════════════
// // // LOGIN SCREEN
// // // ═══════════════════════════════════════════════════════

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen>
// //     with TickerProviderStateMixin {
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _otpController = TextEditingController();
// //   final FocusNode _phoneFocus = FocusNode();
// //   final FocusNode _otpFocus = FocusNode();

// //   // OTP resend timer
// //   int _resendSeconds = 0;
// //   Timer? _resendTimer;

// //   // Animations
// //   late AnimationController _sheetController;
// //   late AnimationController _otpAnimController;
// //   late Animation<Offset> _sheetSlide;
// //   late Animation<double> _sheetOpacity;
// //   late Animation<double> _otpFieldAnim;
// //   late Animation<Offset> _otpSlide;

// //   // Float for background images
// //   late AnimationController _floatController;
// //   late Animation<double> _floatY;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _sheetController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 700),
// //     );
// //     _otpAnimController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 450),
// //     );
// //     _floatController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 3200),
// //     )..repeat(reverse: true);

// //     _sheetSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
// //         .animate(
// //           CurvedAnimation(parent: _sheetController, curve: Curves.easeOutCubic),
// //         );
// //     _sheetOpacity = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(parent: _sheetController, curve: Curves.easeOut),
// //     );

// //     _otpSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
// //         .animate(
// //           CurvedAnimation(parent: _otpAnimController, curve: Curves.easeOutBack),
// //         );
// //     _otpFieldAnim = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(parent: _otpAnimController, curve: Curves.easeOut),
// //     );

// //     _floatY = Tween<double>(begin: -10, end: 10).animate(
// //       CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
// //     );

// //     Future.delayed(const Duration(milliseconds: 100), () {
// //       if (mounted) _sheetController.forward();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _phoneController.dispose();
// //     _otpController.dispose();
// //     _phoneFocus.dispose();
// //     _otpFocus.dispose();
// //     _sheetController.dispose();
// //     _otpAnimController.dispose();
// //     _floatController.dispose();
// //     _resendTimer?.cancel();
// //     super.dispose();
// //   }

// //   void _startResendTimer() {
// //     _resendSeconds = 60;
// //     _resendTimer?.cancel();
// //     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (mounted) {
// //         setState(() {
// //           if (_resendSeconds > 0) {
// //             _resendSeconds--;
// //           } else {
// //             timer.cancel();
// //           }
// //         });
// //       }
// //     });
// //   }

// //   // ── Send OTP via AuthProvider ──────────────────────────────────────────────

// //   Future<void> _handleGetOtp() async {
// //     if (_phoneController.text.length < 10) return;
// //     _phoneFocus.unfocus();

// //     final auth = context.read<AuthProvider>();
// //     await auth.sendOtp(_phoneController.text.trim());

// //     if (!mounted) return;

// //     if (auth.status == AuthStatus.otpSent) {
// //       _otpAnimController.forward();
// //       _startResendTimer();
// //       Future.delayed(const Duration(milliseconds: 300), () {
// //         if (mounted) _otpFocus.requestFocus();
// //       });
// //     } else if (auth.status == AuthStatus.error) {
// //       _showErrorSnackbar(auth.errorMessage ?? 'Failed to send OTP');
// //       auth.clearError();
// //     }
// //   }

// //   // ── Verify OTP via AuthProvider ────────────────────────────────────────────

// //   Future<void> _handleLogin() async {
// //     if (_otpController.text.length < 4) return;
// //     _otpFocus.unfocus();

// //     final auth = context.read<AuthProvider>();
// //     await auth.verifyOtp(_otpController.text.trim());

// //     if (!mounted) return;

// //     if (auth.status == AuthStatus.verified) {
// //       _showStaySelectionModal();
// //     } else if (auth.status == AuthStatus.error) {
// //       _showErrorSnackbar(auth.errorMessage ?? 'OTP verification failed');
// //       auth.clearError();
// //     }
// //   }

// //   void _showStaySelectionModal() {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => const _StaySelectionModal(),
// //     );
// //   }

// //   Future<void> _resendOtp() async {
// //     if (_resendSeconds > 0) return;
// //     _otpController.clear();

// //     final auth = context.read<AuthProvider>();
// //     await auth.sendOtp(_phoneController.text.trim());

// //     if (!mounted) return;

// //     if (auth.status == AuthStatus.otpSent) {
// //       _startResendTimer();
// //     } else if (auth.status == AuthStatus.error) {
// //       _showErrorSnackbar(auth.errorMessage ?? 'Failed to resend OTP');
// //       auth.clearError();
// //     }
// //   }

// //   void _showErrorSnackbar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: const Color(0xFFE53935),
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       ),
// //     );
// //   }

// //   String get _timerText {
// //     final min = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
// //     final sec = (_resendSeconds % 60).toString().padLeft(2, '0');
// //     return '$min:$sec';
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;

// //     // Listen to AuthProvider for isLoading & otpSent state
// //     final auth = context.watch<AuthProvider>();
// //     final isLoading = auth.isLoading;
// //     final otpSent = auth.status == AuthStatus.otpSent ||
// //         auth.status == AuthStatus.verified ||
// //         auth.status == AuthStatus.error && _otpAnimController.value > 0;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       resizeToAvoidBottomInset: true,
// //       body: Stack(
// //         children: [
// //           // ── Background blurred images ──
// //           Positioned(
// //             top: -10,
// //             right: -20,
// //             child: AnimatedBuilder(
// //               animation: _floatController,
// //               builder: (context, child) => Transform.translate(
// //                 offset: Offset(0, _floatY.value * 0.5),
// //                 child: child,
// //               ),
// //               child: const _OvalImage(
// //                 imagePath: 'assets/splashimage.png',
// //                 width: 130,
// //                 height: 160,
// //                 borderRadius: 65,
// //                 rotate: 0.15,
// //                 blur: true,
// //               ),
// //             ),
// //           ),

// //           Positioned(
// //             top: size.height * 0.18,
// //             left: -30,
// //             child: AnimatedBuilder(
// //               animation: _floatController,
// //               builder: (context, child) => Transform.translate(
// //                 offset: Offset(0, -_floatY.value * 0.7),
// //                 child: child,
// //               ),
// //               child: const _OvalImage(
// //                 imagePath: 'assets/splashimage.png',
// //                 width: 120,
// //                 height: 150,
// //                 borderRadius: 60,
// //                 rotate: -0.1,
// //                 blur: true,
// //               ),
// //             ),
// //           ),

// //           Positioned(
// //             top: size.height * 0.02,
// //             left: size.width * 0.08,
// //             right: size.width * 0.08,
// //             child: AnimatedBuilder(
// //               animation: _floatController,
// //               builder: (context, child) => Transform.translate(
// //                 offset: Offset(0, _floatY.value * 0.35),
// //                 child: child,
// //               ),
// //               child: _OvalImage(
// //                 imagePath: 'assets/splashimage.png',
// //                 width: double.infinity,
// //                 height: size.height * 0.36,
// //                 borderRadius: 999,
// //                 rotate: 0,
// //                 blur: true,
// //               ),
// //             ),
// //           ),

// //           // Red FAB decoration
// //           Positioned(
// //             top: size.height * 0.28,
// //             right: size.width * 0.14,
// //             child: Container(
// //               width: 48,
// //               height: 48,
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFE53935),
// //                 shape: BoxShape.circle,
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: const Color(0xFFE53935).withOpacity(0.4),
// //                     blurRadius: 16,
// //                     offset: const Offset(0, 5),
// //                   ),
// //                 ],
// //               ),
// //               child: const Icon(
// //                 Icons.arrow_outward_rounded,
// //                 color: Colors.white,
// //                 size: 24,
// //               ),
// //             ),
// //           ),

// //           // ── Bottom Sheet Card ──
// //           Align(
// //             alignment: Alignment.bottomCenter,
// //             child: SlideTransition(
// //               position: _sheetSlide,
// //               child: FadeTransition(
// //                 opacity: _sheetOpacity,
// //                 child: Container(
// //                   width: double.infinity,
// //                   decoration: const BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.only(
// //                       topLeft: Radius.circular(28),
// //                       topRight: Radius.circular(28),
// //                     ),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black12,
// //                         blurRadius: 30,
// //                         offset: Offset(0, -8),
// //                       ),
// //                     ],
// //                   ),
// //                   child: SingleChildScrollView(
// //                     child: Padding(
// //                       padding: EdgeInsets.only(
// //                         left: 24,
// //                         right: 24,
// //                         top: 32,
// //                         bottom: MediaQuery.of(context).viewInsets.bottom + 36,
// //                       ),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           // Drag handle
// //                           Center(
// //                             child: Container(
// //                               width: 40,
// //                               height: 4,
// //                               margin: const EdgeInsets.only(bottom: 24),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.grey.shade300,
// //                                 borderRadius: BorderRadius.circular(2),
// //                               ),
// //                             ),
// //                           ),

// //                           // Title
// //                           RichText(
// //                             text: const TextSpan(
// //                               style: TextStyle(
// //                                 fontSize: 24,
// //                                 fontWeight: FontWeight.w700,
// //                                 color: Color(0xFF1A1A2E),
// //                               ),
// //                               children: [
// //                                 TextSpan(text: 'Find Your '),
// //                                 TextSpan(
// //                                   text: 'Perfect',
// //                                   style: TextStyle(color: Color(0xFFE53935)),
// //                                 ),
// //                                 TextSpan(text: ' Stay'),
// //                               ],
// //                             ),
// //                           ),

// //                           const SizedBox(height: 28),

// //                           // Phone field
// //                           _InputField(
// //                             controller: _phoneController,
// //                             focusNode: _phoneFocus,
// //                             hint: 'Mobile Number',
// //                             keyboardType: TextInputType.phone,
// //                             inputFormatters: [
// //                               FilteringTextInputFormatter.digitsOnly,
// //                               LengthLimitingTextInputFormatter(10),
// //                             ],
// //                             prefixIcon: const Icon(
// //                               Icons.phone_outlined,
// //                               color: Color(0xFF9E9E9E),
// //                               size: 20,
// //                             ),
// //                             onChanged: (_) => setState(() {}),
// //                           ),

// //                           // Animated OTP field
// //                           if (otpSent) ...[
// //                             const SizedBox(height: 14),
// //                             SlideTransition(
// //                               position: _otpSlide,
// //                               child: FadeTransition(
// //                                 opacity: _otpFieldAnim,
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.end,
// //                                   children: [
// //                                     _InputField(
// //                                       controller: _otpController,
// //                                       focusNode: _otpFocus,
// //                                       hint: 'Enter OTP',
// //                                       keyboardType: TextInputType.number,
// //                                       inputFormatters: [
// //                                         FilteringTextInputFormatter.digitsOnly,
// //                                         LengthLimitingTextInputFormatter(6),
// //                                       ],
// //                                       prefixIcon: const Icon(
// //                                         Icons.lock_outline,
// //                                         color: Color(0xFF9E9E9E),
// //                                         size: 20,
// //                                       ),
// //                                       onChanged: (_) => setState(() {}),
// //                                     ),
// //                                     const SizedBox(height: 8),
// //                                     GestureDetector(
// //                                       onTap: _resendOtp,
// //                                       child: Row(
// //                                         mainAxisSize: MainAxisSize.min,
// //                                         children: [
// //                                           Text(
// //                                             'Resend ',
// //                                             style: TextStyle(
// //                                               fontSize: 13,
// //                                               color: Colors.grey.shade600,
// //                                               fontWeight: FontWeight.w400,
// //                                             ),
// //                                           ),
// //                                           Text(
// //                                             _resendSeconds > 0
// //                                                 ? _timerText
// //                                                 : 'Now',
// //                                             style: TextStyle(
// //                                               fontSize: 13,
// //                                               color: _resendSeconds > 0
// //                                                   ? const Color(0xFFE53935)
// //                                                   : const Color(0xFF1565C0),
// //                                               fontWeight: FontWeight.w600,
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],

// //                           const SizedBox(height: 28),

// //                           // Button
// //                           _RedButton(
// //                             label: isLoading
// //                                 ? ''
// //                                 : (otpSent ? 'Login' : 'Get OTP'),
// //                             isLoading: isLoading,
// //                             onTap: otpSent ? _handleLogin : _handleGetOtp,
// //                             enabled: otpSent
// //                                 ? _otpController.text.length >= 4
// //                                 : _phoneController.text.length == 10,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ═══════════════════════════════════════════════════════
// // // STAY SELECTION MODAL
// // // ═══════════════════════════════════════════════════════

// // class _StaySelectionModal extends StatefulWidget {
// //   const _StaySelectionModal();

// //   @override
// //   State<_StaySelectionModal> createState() => _StaySelectionModalState();
// // }

// // class _StaySelectionModalState extends State<_StaySelectionModal>
// //     with SingleTickerProviderStateMixin {
// //   String? _selectedStay;
// //   bool _isLoading = false;

// //   late AnimationController _animController;
// //   late List<Animation<Offset>> _itemSlides;
// //   late List<Animation<double>> _itemOpacities;

// //   final List<Map<String, dynamic>> _stayOptions = [
// //     {'label': "Men's Pg", 'icon': Icons.male_rounded},
// //     {'label': "Women's Pg", 'icon': Icons.female_rounded},
// //     {'label': "Coliving Pg", 'icon': Icons.people_alt_rounded},
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 600),
// //     );

// //     _itemSlides = List.generate(
// //       _stayOptions.length,
// //       (i) =>
// //           Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
// //             CurvedAnimation(
// //               parent: _animController,
// //               curve: Interval(
// //                 0.1 + i * 0.15,
// //                 0.5 + i * 0.15,
// //                 curve: Curves.easeOutBack,
// //               ),
// //             ),
// //           ),
// //     );

// //     _itemOpacities = List.generate(
// //       _stayOptions.length,
// //       (i) => Tween<double>(begin: 0, end: 1).animate(
// //         CurvedAnimation(
// //           parent: _animController,
// //           curve: Interval(
// //             0.1 + i * 0.15,
// //             0.5 + i * 0.15,
// //             curve: Curves.easeOut,
// //           ),
// //         ),
// //       ),
// //     );

// //     Future.microtask(() => _animController.forward());
// //   }

// //   @override
// //   void dispose() {
// //     _animController.dispose();
// //     super.dispose();
// //   }

// //   void _handleConfirm() async {
// //     if (_selectedStay == null) return;
// //     setState(() => _isLoading = true);
// //     await Future.delayed(const Duration(milliseconds: 500));
// //     if (mounted) {
// //       setState(() => _isLoading = false);
// //       Navigator.pop(context);
// //       Navigator.pushAndRemoveUntil(
// //         context,
// //         MaterialPageRoute(builder: (_) => NavbarScreen()),
// //         (route) => false,
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: 30,
// //             offset: Offset(0, -8),
// //           ),
// //         ],
// //       ),
// //       padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           // Drag handle
// //           Container(
// //             width: 40,
// //             height: 4,
// //             margin: const EdgeInsets.only(bottom: 24),
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade300,
// //               borderRadius: BorderRadius.circular(2),
// //             ),
// //           ),

// //           // Title
// //           RichText(
// //             textAlign: TextAlign.center,
// //             text: const TextSpan(
// //               style: TextStyle(
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.w700,
// //                 color: Color(0xFF1A1A2E),
// //               ),
// //               children: [
// //                 TextSpan(text: 'Select Your '),
// //                 TextSpan(
// //                   text: 'Perfect',
// //                   style: TextStyle(color: Color(0xFFE53935)),
// //                 ),
// //                 TextSpan(text: ' Stay'),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 24),

// //           // Stay options
// //           ...List.generate(_stayOptions.length, (i) {
// //             final option = _stayOptions[i];
// //             final isSelected = _selectedStay == option['label'];
// //             return SlideTransition(
// //               position: _itemSlides[i],
// //               child: FadeTransition(
// //                 opacity: _itemOpacities[i],
// //                 child: GestureDetector(
// //                   onTap: () => setState(() => _selectedStay = option['label']),
// //                   child: AnimatedContainer(
// //                     duration: const Duration(milliseconds: 220),
// //                     curve: Curves.easeOut,
// //                     margin: const EdgeInsets.only(bottom: 12),
// //                     height: 54,
// //                     decoration: BoxDecoration(
// //                       color: isSelected
// //                           ? const Color(0xFFF80500)
// //                           : Colors.white,
// //                       borderRadius: BorderRadius.circular(13),
// //                       border: Border.all(
// //                         color: isSelected
// //                             ? const Color(0xFFF80500)
// //                             : const Color(0xFFE0E0E0),
// //                         width: isSelected ? 0 : 1.4,
// //                       ),
// //                       boxShadow: isSelected
// //                           ? [
// //                               BoxShadow(
// //                                 color: const Color(0xFFE53935).withOpacity(0.35),
// //                                 blurRadius: 14,
// //                                 offset: const Offset(0, 5),
// //                               ),
// //                             ]
// //                           : [],
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         AnimatedSwitcher(
// //                           duration: const Duration(milliseconds: 200),
// //                           child: Icon(
// //                             option['icon'] as IconData,
// //                             key: ValueKey(isSelected),
// //                             color: isSelected
// //                                 ? Colors.white
// //                                 : const Color(0xFF9E9E9E),
// //                             size: 20,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Text(
// //                           option['label'] as String,
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                             fontWeight: FontWeight.w600,
// //                             color: isSelected
// //                                 ? Colors.white
// //                                 : const Color(0xFF1A1A2E),
// //                             letterSpacing: 0.2,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           }),

// //           const SizedBox(height: 8),

// //           _RedButton(
// //             label: _isLoading ? '' : 'Login',
// //             isLoading: _isLoading,
// //             onTap: _handleConfirm,
// //             enabled: _selectedStay != null,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ═══════════════════════════════════════════════════════
// // // SHARED WIDGETS
// // // ═══════════════════════════════════════════════════════

// // class _OvalImage extends StatelessWidget {
// //   final String imagePath;
// //   final double width;
// //   final double height;
// //   final double borderRadius;
// //   final double rotate;
// //   final bool blur;

// //   const _OvalImage({
// //     required this.imagePath,
// //     required this.width,
// //     required this.height,
// //     required this.borderRadius,
// //     required this.rotate,
// //     this.blur = false,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Transform.rotate(
// //       angle: rotate,
// //       child: Container(
// //         width: width,
// //         height: height,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(borderRadius),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(blur ? 0.10 : 0.18),
// //               blurRadius: 24,
// //               offset: const Offset(0, 10),
// //             ),
// //           ],
// //         ),
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.circular(borderRadius),
// //           child: ColorFiltered(
// //             colorFilter: blur
// //                 ? ColorFilter.mode(
// //                     Colors.white.withOpacity(0.18),
// //                     BlendMode.lighten,
// //                   )
// //                 : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
// //             child: Image.asset(
// //               imagePath,
// //               width: width,
// //               height: height,
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _InputField extends StatelessWidget {
// //   final TextEditingController controller;
// //   final FocusNode focusNode;
// //   final String hint;
// //   final TextInputType keyboardType;
// //   final List<TextInputFormatter> inputFormatters;
// //   final Widget? prefixIcon;
// //   final ValueChanged<String>? onChanged;

// //   const _InputField({
// //     required this.controller,
// //     required this.focusNode,
// //     required this.hint,
// //     required this.keyboardType,
// //     required this.inputFormatters,
// //     this.prefixIcon,
// //     this.onChanged,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: focusNode,
// //       builder: (context, child) {
// //         final isFocused = focusNode.hasFocus;
// //         return AnimatedContainer(
// //           duration: const Duration(milliseconds: 200),
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(
// //               color: isFocused
// //                   ? const Color(0xFFE53935)
// //                   : const Color(0xFFE0E0E0),
// //               width: isFocused ? 1.8 : 1.2,
// //             ),
// //             color: Colors.white,
// //             boxShadow: isFocused
// //                 ? [
// //                     BoxShadow(
// //                       color: const Color(0xFFE53935).withOpacity(0.1),
// //                       blurRadius: 12,
// //                       offset: const Offset(0, 3),
// //                     ),
// //                   ]
// //                 : [],
// //           ),
// //           child: TextFormField(
// //             controller: controller,
// //             focusNode: focusNode,
// //             keyboardType: keyboardType,
// //             inputFormatters: inputFormatters,
// //             onChanged: onChanged,
// //             style: const TextStyle(
// //               fontSize: 15,
// //               color: Color(0xFF1A1A2E),
// //               fontWeight: FontWeight.w500,
// //             ),
// //             decoration: InputDecoration(
// //               hintText: hint,
// //               hintStyle: const TextStyle(
// //                 color: Color(0xFFBDBDBD),
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.w400,
// //               ),
// //               prefixIcon: prefixIcon,
// //               border: InputBorder.none,
// //               contentPadding: const EdgeInsets.symmetric(
// //                 horizontal: 16,
// //                 vertical: 16,
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // class _RedButton extends StatefulWidget {
// //   final String label;
// //   final VoidCallback onTap;
// //   final bool enabled;
// //   final bool isLoading;

// //   const _RedButton({
// //     required this.label,
// //     required this.onTap,
// //     this.enabled = true,
// //     this.isLoading = false,
// //   });

// //   @override
// //   State<_RedButton> createState() => _RedButtonState();
// // }

// // class _RedButtonState extends State<_RedButton>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _pressController;
// //   late Animation<double> _pressScale;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _pressController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 100),
// //     );
// //     _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
// //       CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _pressController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isActive = widget.enabled && !widget.isLoading;

// //     return GestureDetector(
// //       onTapDown: isActive ? (_) => _pressController.forward() : null,
// //       onTapUp: isActive
// //           ? (_) {
// //               _pressController.reverse();
// //               widget.onTap();
// //             }
// //           : null,
// //       onTapCancel: isActive ? () => _pressController.reverse() : null,
// //       child: AnimatedBuilder(
// //         animation: _pressController,
// //         builder: (context, child) =>
// //             Transform.scale(scale: _pressScale.value, child: child),
// //         child: AnimatedContainer(
// //           duration: const Duration(milliseconds: 250),
// //           width: double.infinity,
// //           height: 54,
// //           decoration: BoxDecoration(
// //             gradient: isActive
// //                 ? const LinearGradient(
// //                     colors: [Color(0xFFF80500), Color(0xFFF80500)],
// //                     begin: Alignment.centerLeft,
// //                     end: Alignment.centerRight,
// //                   )
// //                 : null,
// //             color: isActive ? null : const Color(0xFFBDBDBD),
// //             borderRadius: BorderRadius.circular(13),
// //             boxShadow: isActive
// //                 ? [
// //                     BoxShadow(
// //                       color: const Color(0xFFE53935).withOpacity(0.4),
// //                       blurRadius: 18,
// //                       offset: const Offset(0, 7),
// //                     ),
// //                   ]
// //                 : [],
// //           ),
// //           child: Center(
// //             child: widget.isLoading
// //                 ? const SizedBox(
// //                     width: 22,
// //                     height: 22,
// //                     child: CircularProgressIndicator(
// //                       color: Colors.white,
// //                       strokeWidth: 2.5,
// //                     ),
// //                   )
// //                 : Text(
// //                     widget.label,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w700,
// //                       letterSpacing: 0.3,
// //                     ),
// //                   ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:brando_app/helper/shared_preference.dart';
// import 'package:brando_app/provider/auth/auth_provider.dart';
// import 'package:brando_app/views/navbar/navbar_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _mainController;
//   late AnimationController _floatController;
//   late AnimationController _pulseController;
//   late Animation<double> _topImageScale;
//   late Animation<double> _topImageOpacity;
//   late Animation<double> _bottomLeftImageScale;
//   late Animation<double> _bottomLeftImageOpacity;
//   late Animation<double> _centerImageScale;
//   late Animation<double> _centerImageOpacity;
//   late Animation<Offset> _fabSlide;
//   late Animation<double> _fabScale;
//   late Animation<Offset> _textSlide;
//   late Animation<double> _textOpacity;
//   late Animation<Offset> _subtitleSlide;
//   late Animation<double> _subtitleOpacity;
//   late Animation<Offset> _buttonSlide;
//   late Animation<double> _buttonOpacity;
//   late Animation<double> _floatY;
//   late Animation<double> _pulse;

//   @override
//   void initState() {
//     super.initState();

//     _mainController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );

//     _floatController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     )..repeat(reverse: true);

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);

//     _topImageOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
//       ),
//     );
//     _topImageScale = Tween<double>(begin: 0.5, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
//       ),
//     );

//     _bottomLeftImageOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
//       ),
//     );
//     _bottomLeftImageScale = Tween<double>(begin: 0.5, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
//       ),
//     );

//     _centerImageOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
//       ),
//     );
//     _centerImageScale = Tween<double>(begin: 0.7, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
//       ),
//     );

//     _fabSlide = Tween<Offset>(begin: const Offset(0.5, 0.5), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _mainController,
//             curve: const Interval(0.5, 0.75, curve: Curves.easeOutBack),
//           ),
//         );
//     _fabScale = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.5, 0.75, curve: Curves.elasticOut),
//       ),
//     );

//     _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _mainController,
//             curve: const Interval(0.55, 0.8, curve: Curves.easeOut),
//           ),
//         );
//     _textOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.55, 0.8, curve: Curves.easeOut),
//       ),
//     );

//     _subtitleSlide =
//         Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _mainController,
//             curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
//           ),
//         );
//     _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
//       ),
//     );

//     _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _mainController,
//             curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
//           ),
//         );
//     _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     _floatY = Tween<double>(begin: -8, end: 8).animate(
//       CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
//     );

//     _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     // ── Auto-navigate if already logged in ──────────────────────────────────
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (!mounted) return;
//       _mainController.forward();

//       if (AppPreferences.isLoggedIn()) {
//         // Wait for splash animation to feel complete, then go to Navbar
//         Future.delayed(const Duration(milliseconds: 1400), () {
//           if (!mounted) return;
//           Navigator.of(context).pushAndRemoveUntil(
//             PageRouteBuilder(
//               pageBuilder: (context, animation, secondaryAnimation) =>
//                   NavbarScreen(),
//               transitionsBuilder:
//                   (context, animation, secondaryAnimation, child) {
//                 return FadeTransition(opacity: animation, child: child);
//               },
//               transitionDuration: const Duration(milliseconds: 500),
//             ),
//             (route) => false,
//           );
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     _floatController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   void _goToLogin() {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             const LoginScreen(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
//                 .animate(
//                   CurvedAnimation(
//                     parent: animation,
//                     curve: Curves.easeOutCubic,
//                   ),
//                 ),
//             child: child,
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 500),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Top-right small oval image
//             Positioned(
//               top: -10,
//               right: -20,
//               child: AnimatedBuilder(
//                 animation: Listenable.merge([_mainController, _floatController]),
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, _floatY.value * 0.6),
//                     child: Opacity(
//                       opacity: _topImageOpacity.value,
//                       child: Transform.scale(
//                         scale: _topImageScale.value,
//                         child: child,
//                       ),
//                     ),
//                   );
//                 },
//                 child: const _OvalImage(
//                   imagePath: 'assets/splashimage.png',
//                   width: 120,
//                   height: 155,
//                   borderRadius: 65,
//                   rotate: 0.15,
//                 ),
//               ),
//             ),

//             // Bottom-left small oval image
//             Positioned(
//               top: size.height * 0.28,
//               left: -25,
//               child: AnimatedBuilder(
//                 animation: Listenable.merge([_mainController, _floatController]),
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, -_floatY.value * 0.8),
//                     child: Opacity(
//                       opacity: _bottomLeftImageOpacity.value,
//                       child: Transform.scale(
//                         scale: _bottomLeftImageScale.value,
//                         child: child,
//                       ),
//                     ),
//                   );
//                 },
//                 child: const _OvalImage(
//                   imagePath: 'assets/splashimage.png',
//                   width: 110,
//                   height: 140,
//                   borderRadius: 60,
//                   rotate: -0.1,
//                 ),
//               ),
//             ),

//             // Center large oval image
//             Positioned(
//               top: size.height * 0.04,
//               left: size.width * 0.08,
//               right: size.width * 0.08,
//               child: AnimatedBuilder(
//                 animation: Listenable.merge([_mainController, _floatController]),
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, _floatY.value * 0.4),
//                     child: Opacity(
//                       opacity: _centerImageOpacity.value,
//                       child: Transform.scale(
//                         scale: _centerImageScale.value,
//                         child: child,
//                       ),
//                     ),
//                   );
//                 },
//                 child: _OvalImage(
//                   imagePath: 'assets/splashimage.png',
//                   width: double.infinity,
//                   height: size.height * 0.38,
//                   borderRadius: 999,
//                   rotate: 0,
//                 ),
//               ),
//             ),

//             // Red FAB arrow
//             Positioned(
//               top: size.height * 0.33,
//               right: size.width * 0.12,
//               child: AnimatedBuilder(
//                 animation: Listenable.merge([_mainController, _pulseController]),
//                 builder: (context, child) {
//                   return SlideTransition(
//                     position: _fabSlide,
//                     child: Transform.scale(
//                       scale: _fabScale.value * _pulse.value,
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 52,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE53935),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFE53935).withOpacity(0.45),
//                         blurRadius: 18,
//                         spreadRadius: 2,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.arrow_outward_rounded,
//                     color: Colors.white,
//                     size: 26,
//                   ),
//                 ),
//               ),
//             ),

//             // Bottom content — hidden when already logged in
//             if (!AppPreferences.isLoggedIn())
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SlideTransition(
//                         position: _textSlide,
//                         child: FadeTransition(
//                           opacity: _textOpacity,
//                           child: RichText(
//                             textAlign: TextAlign.center,
//                             text: const TextSpan(
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF1A1A2E),
//                                 height: 1.25,
//                                 letterSpacing: -0.3,
//                               ),
//                               children: [
//                                 TextSpan(text: 'Redefining Your\n'),
//                                 TextSpan(
//                                   text: 'Hostel Booking ',
//                                   style: TextStyle(color: Color(0xFFF80500)),
//                                 ),
//                                 TextSpan(text: 'Experience'),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 14),
//                       SlideTransition(
//                         position: _subtitleSlide,
//                         child: FadeTransition(
//                           opacity: _subtitleOpacity,
//                           child: const Text(
//                             'A hostel booking app should feature quick user registration, searchable listings with filters',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF7A7A8C),
//                               height: 1.6,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       SlideTransition(
//                         position: _buttonSlide,
//                         child: FadeTransition(
//                           opacity: _buttonOpacity,
//                           child: _RedButton(
//                             label: "Let's Get Started",
//                             onTap: _goToLogin,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 36),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════
// // LOGIN SCREEN
// // ═══════════════════════════════════════════════════════

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   final FocusNode _phoneFocus = FocusNode();
//   final FocusNode _otpFocus = FocusNode();

//   // OTP resend timer
//   int _resendSeconds = 0;
//   Timer? _resendTimer;

//   // Animations
//   late AnimationController _sheetController;
//   late AnimationController _otpAnimController;
//   late Animation<double> _otpFieldAnim;
//   late Animation<Offset> _otpSlide;

//   // Float for background images
//   late AnimationController _floatController;
//   late Animation<double> _floatY;

//   late Animation<Offset> _sheetSlide;
//   late Animation<double> _sheetOpacity;

//   @override
//   void initState() {
//     super.initState();

//     _sheetController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//     _otpAnimController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 450),
//     );
//     _floatController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3200),
//     )..repeat(reverse: true);

//     _sheetSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(parent: _sheetController, curve: Curves.easeOutCubic),
//         );
//     _sheetOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _sheetController, curve: Curves.easeOut),
//     );

//     _otpSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//               parent: _otpAnimController, curve: Curves.easeOutBack),
//         );
//     _otpFieldAnim = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _otpAnimController, curve: Curves.easeOut),
//     );

//     _floatY = Tween<double>(begin: -10, end: 10).animate(
//       CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
//     );

//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (mounted) _sheetController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _otpController.dispose();
//     _phoneFocus.dispose();
//     _otpFocus.dispose();
//     _sheetController.dispose();
//     _otpAnimController.dispose();
//     _floatController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }

//   void _startResendTimer() {
//     _resendSeconds = 60;
//     _resendTimer?.cancel();
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           if (_resendSeconds > 0) {
//             _resendSeconds--;
//           } else {
//             timer.cancel();
//           }
//         });
//       }
//     });
//   }

//   Future<void> _handleGetOtp() async {
//     if (_phoneController.text.length < 10) return;
//     _phoneFocus.unfocus();

//     final auth = context.read<AuthProvider>();
//     await auth.sendOtp(_phoneController.text.trim());

//     if (!mounted) return;

//     if (auth.status == AuthStatus.otpSent) {
//       _otpAnimController.forward();
//       _startResendTimer();
//       Future.delayed(const Duration(milliseconds: 300), () {
//         if (mounted) _otpFocus.requestFocus();
//       });
//     } else if (auth.status == AuthStatus.error) {
//       _showErrorSnackbar(auth.errorMessage ?? 'Failed to send OTP');
//       auth.clearError();
//     }
//   }

//   Future<void> _handleLogin() async {
//     if (_otpController.text.length < 4) return;
//     _otpFocus.unfocus();

//     final auth = context.read<AuthProvider>();
//     await auth.verifyOtp(_otpController.text.trim());

//     if (!mounted) return;

//     if (auth.status == AuthStatus.verified) {
//       _showStaySelectionModal();
//     } else if (auth.status == AuthStatus.error) {
//       _showErrorSnackbar(auth.errorMessage ?? 'OTP verification failed');
//       auth.clearError();
//     }
//   }

//   void _showStaySelectionModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => const _StaySelectionModal(),
//     );
//   }

//   Future<void> _resendOtp() async {
//     if (_resendSeconds > 0) return;
//     _otpController.clear();

//     final auth = context.read<AuthProvider>();
//     await auth.sendOtp(_phoneController.text.trim());

//     if (!mounted) return;

//     if (auth.status == AuthStatus.otpSent) {
//       _startResendTimer();
//     } else if (auth.status == AuthStatus.error) {
//       _showErrorSnackbar(auth.errorMessage ?? 'Failed to resend OTP');
//       auth.clearError();
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: const Color(0xFFE53935),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }

//   String get _timerText {
//     final min = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
//     final sec = (_resendSeconds % 60).toString().padLeft(2, '0');
//     return '$min:$sec';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     final auth = context.watch<AuthProvider>();
//     final isLoading = auth.isLoading;
//     final otpSent = auth.status == AuthStatus.otpSent ||
//         auth.status == AuthStatus.verified ||
//         auth.status == AuthStatus.error && _otpAnimController.value > 0;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           Positioned(
//             top: -10,
//             right: -20,
//             child: AnimatedBuilder(
//               animation: _floatController,
//               builder: (context, child) => Transform.translate(
//                 offset: Offset(0, _floatY.value * 0.5),
//                 child: child,
//               ),
//               child: const _OvalImage(
//                 imagePath: 'assets/splashimage.png',
//                 width: 130,
//                 height: 160,
//                 borderRadius: 65,
//                 rotate: 0.15,
//                 blur: true,
//               ),
//             ),
//           ),

//           Positioned(
//             top: size.height * 0.18,
//             left: -30,
//             child: AnimatedBuilder(
//               animation: _floatController,
//               builder: (context, child) => Transform.translate(
//                 offset: Offset(0, -_floatY.value * 0.7),
//                 child: child,
//               ),
//               child: const _OvalImage(
//                 imagePath: 'assets/splashimage.png',
//                 width: 120,
//                 height: 150,
//                 borderRadius: 60,
//                 rotate: -0.1,
//                 blur: true,
//               ),
//             ),
//           ),

//           Positioned(
//             top: size.height * 0.02,
//             left: size.width * 0.08,
//             right: size.width * 0.08,
//             child: AnimatedBuilder(
//               animation: _floatController,
//               builder: (context, child) => Transform.translate(
//                 offset: Offset(0, _floatY.value * 0.35),
//                 child: child,
//               ),
//               child: _OvalImage(
//                 imagePath: 'assets/splashimage.png',
//                 width: double.infinity,
//                 height: size.height * 0.36,
//                 borderRadius: 999,
//                 rotate: 0,
//                 blur: true,
//               ),
//             ),
//           ),

//           Positioned(
//             top: size.height * 0.28,
//             right: size.width * 0.14,
//             child: Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE53935),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFE53935).withOpacity(0.4),
//                     blurRadius: 16,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.arrow_outward_rounded,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//           ),

//           Align(
//             alignment: Alignment.bottomCenter,
//             child: SlideTransition(
//               position: _sheetSlide,
//               child: FadeTransition(
//                 opacity: _sheetOpacity,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(28),
//                       topRight: Radius.circular(28),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 30,
//                         offset: Offset(0, -8),
//                       ),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         left: 24,
//                         right: 24,
//                         top: 32,
//                         bottom: MediaQuery.of(context).viewInsets.bottom + 36,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Center(
//                             child: Container(
//                               width: 40,
//                               height: 4,
//                               margin: const EdgeInsets.only(bottom: 24),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade300,
//                                 borderRadius: BorderRadius.circular(2),
//                               ),
//                             ),
//                           ),

//                           RichText(
//                             text: const TextSpan(
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF1A1A2E),
//                               ),
//                               children: [
//                                 TextSpan(text: 'Find Your '),
//                                 TextSpan(
//                                   text: 'Perfect',
//                                   style: TextStyle(color: Color(0xFFE53935)),
//                                 ),
//                                 TextSpan(text: ' Stay'),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 28),

//                           _InputField(
//                             controller: _phoneController,
//                             focusNode: _phoneFocus,
//                             hint: 'Mobile Number',
//                             keyboardType: TextInputType.phone,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(10),
//                             ],
//                             prefixIcon: const Icon(
//                               Icons.phone_outlined,
//                               color: Color(0xFF9E9E9E),
//                               size: 20,
//                             ),
//                             onChanged: (_) => setState(() {}),
//                           ),

//                           if (otpSent) ...[
//                             const SizedBox(height: 14),
//                             SlideTransition(
//                               position: _otpSlide,
//                               child: FadeTransition(
//                                 opacity: _otpFieldAnim,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     _InputField(
//                                       controller: _otpController,
//                                       focusNode: _otpFocus,
//                                       hint: 'Enter OTP',
//                                       keyboardType: TextInputType.number,
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.digitsOnly,
//                                         LengthLimitingTextInputFormatter(6),
//                                       ],
//                                       prefixIcon: const Icon(
//                                         Icons.lock_outline,
//                                         color: Color(0xFF9E9E9E),
//                                         size: 20,
//                                       ),
//                                       onChanged: (_) => setState(() {}),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     GestureDetector(
//                                       onTap: _resendOtp,
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             'Resend ',
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.grey.shade600,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                           Text(
//                                             _resendSeconds > 0
//                                                 ? _timerText
//                                                 : 'Now',
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               color: _resendSeconds > 0
//                                                   ? const Color(0xFFE53935)
//                                                   : const Color(0xFF1565C0),
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],

//                           const SizedBox(height: 28),

//                           _RedButton(
//                             label: isLoading
//                                 ? ''
//                                 : (otpSent ? 'Login' : 'Get OTP'),
//                             isLoading: isLoading,
//                             onTap: otpSent ? _handleLogin : _handleGetOtp,
//                             enabled: otpSent
//                                 ? _otpController.text.length >= 4
//                                 : _phoneController.text.length == 10,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════
// // STAY SELECTION MODAL
// // ═══════════════════════════════════════════════════════

// class _StaySelectionModal extends StatefulWidget {
//   const _StaySelectionModal();

//   @override
//   State<_StaySelectionModal> createState() => _StaySelectionModalState();
// }

// class _StaySelectionModalState extends State<_StaySelectionModal>
//     with SingleTickerProviderStateMixin {
//   String? _selectedStay;
//   bool _isLoading = false;

//   late AnimationController _animController;
//   late List<Animation<Offset>> _itemSlides;
//   late List<Animation<double>> _itemOpacities;

//   final List<Map<String, dynamic>> _stayOptions = [
//     {'label': "Men's Pg", 'icon': Icons.male_rounded},
//     {'label': "Women's Pg", 'icon': Icons.female_rounded},
//     {'label': "Coliving Pg", 'icon': Icons.people_alt_rounded},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _itemSlides = List.generate(
//       _stayOptions.length,
//       (i) =>
//           Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
//             CurvedAnimation(
//               parent: _animController,
//               curve: Interval(
//                 0.1 + i * 0.15,
//                 0.5 + i * 0.15,
//                 curve: Curves.easeOutBack,
//               ),
//             ),
//           ),
//     );

//     _itemOpacities = List.generate(
//       _stayOptions.length,
//       (i) => Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(
//           parent: _animController,
//           curve: Interval(
//             0.1 + i * 0.15,
//             0.5 + i * 0.15,
//             curve: Curves.easeOut,
//           ),
//         ),
//       ),
//     );

//     Future.microtask(() => _animController.forward());
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }

//   void _handleConfirm() async {
//     if (_selectedStay == null) return;
//     setState(() => _isLoading = true);
//     await Future.delayed(const Duration(milliseconds: 500));
//     if (mounted) {
//       setState(() => _isLoading = false);
//       Navigator.pop(context);
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => NavbarScreen()),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 30,
//             offset: Offset(0, -8),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.only(bottom: 24),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),

//           RichText(
//             textAlign: TextAlign.center,
//             text: const TextSpan(
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1A1A2E),
//               ),
//               children: [
//                 TextSpan(text: 'Select Your '),
//                 TextSpan(
//                   text: 'Perfect',
//                   style: TextStyle(color: Color(0xFFE53935)),
//                 ),
//                 TextSpan(text: ' Stay'),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           ...List.generate(_stayOptions.length, (i) {
//             final option = _stayOptions[i];
//             final isSelected = _selectedStay == option['label'];
//             return SlideTransition(
//               position: _itemSlides[i],
//               child: FadeTransition(
//                 opacity: _itemOpacities[i],
//                 child: GestureDetector(
//                   onTap: () => setState(() => _selectedStay = option['label']),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 220),
//                     curve: Curves.easeOut,
//                     margin: const EdgeInsets.only(bottom: 12),
//                     height: 54,
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? const Color(0xFFF80500)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(13),
//                       border: Border.all(
//                         color: isSelected
//                             ? const Color(0xFFF80500)
//                             : const Color(0xFFE0E0E0),
//                         width: isSelected ? 0 : 1.4,
//                       ),
//                       boxShadow: isSelected
//                           ? [
//                               BoxShadow(
//                                 color: const Color(0xFFE53935).withOpacity(0.35),
//                                 blurRadius: 14,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ]
//                           : [],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 200),
//                           child: Icon(
//                             option['icon'] as IconData,
//                             key: ValueKey(isSelected),
//                             color: isSelected
//                                 ? Colors.white
//                                 : const Color(0xFF9E9E9E),
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           option['label'] as String,
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             color: isSelected
//                                 ? Colors.white
//                                 : const Color(0xFF1A1A2E),
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),

//           const SizedBox(height: 8),

//           _RedButton(
//             label: _isLoading ? '' : 'Login',
//             isLoading: _isLoading,
//             onTap: _handleConfirm,
//             enabled: _selectedStay != null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════
// // SHARED WIDGETS
// // ═══════════════════════════════════════════════════════

// class _OvalImage extends StatelessWidget {
//   final String imagePath;
//   final double width;
//   final double height;
//   final double borderRadius;
//   final double rotate;
//   final bool blur;

//   const _OvalImage({
//     required this.imagePath,
//     required this.width,
//     required this.height,
//     required this.borderRadius,
//     required this.rotate,
//     this.blur = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Transform.rotate(
//       angle: rotate,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(borderRadius),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(blur ? 0.10 : 0.18),
//               blurRadius: 24,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(borderRadius),
//           child: ColorFiltered(
//             colorFilter: blur
//                 ? ColorFilter.mode(
//                     Colors.white.withOpacity(0.18),
//                     BlendMode.lighten,
//                   )
//                 : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
//             child: Image.asset(
//               imagePath,
//               width: width,
//               height: height,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _InputField extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final TextInputType keyboardType;
//   final List<TextInputFormatter> inputFormatters;
//   final Widget? prefixIcon;
//   final ValueChanged<String>? onChanged;

//   const _InputField({
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     required this.keyboardType,
//     required this.inputFormatters,
//     this.prefixIcon,
//     this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: focusNode,
//       builder: (context, child) {
//         final isFocused = focusNode.hasFocus;
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isFocused
//                   ? const Color(0xFFE53935)
//                   : const Color(0xFFE0E0E0),
//               width: isFocused ? 1.8 : 1.2,
//             ),
//             color: Colors.white,
//             boxShadow: isFocused
//                 ? [
//                     BoxShadow(
//                       color: const Color(0xFFE53935).withOpacity(0.1),
//                       blurRadius: 12,
//                       offset: const Offset(0, 3),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: TextFormField(
//             controller: controller,
//             focusNode: focusNode,
//             keyboardType: keyboardType,
//             inputFormatters: inputFormatters,
//             onChanged: onChanged,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Color(0xFF1A1A2E),
//               fontWeight: FontWeight.w500,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: const TextStyle(
//                 color: Color(0xFFBDBDBD),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               prefixIcon: prefixIcon,
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _RedButton extends StatefulWidget {
//   final String label;
//   final VoidCallback onTap;
//   final bool enabled;
//   final bool isLoading;

//   const _RedButton({
//     required this.label,
//     required this.onTap,
//     this.enabled = true,
//     this.isLoading = false,
//   });

//   @override
//   State<_RedButton> createState() => _RedButtonState();
// }

// class _RedButtonState extends State<_RedButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _pressController;
//   late Animation<double> _pressScale;

//   @override
//   void initState() {
//     super.initState();
//     _pressController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 100),
//     );
//     _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
//       CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _pressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isActive = widget.enabled && !widget.isLoading;

//     return GestureDetector(
//       onTapDown: isActive ? (_) => _pressController.forward() : null,
//       onTapUp: isActive
//           ? (_) {
//               _pressController.reverse();
//               widget.onTap();
//             }
//           : null,
//       onTapCancel: isActive ? () => _pressController.reverse() : null,
//       child: AnimatedBuilder(
//         animation: _pressController,
//         builder: (context, child) =>
//             Transform.scale(scale: _pressScale.value, child: child),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           width: double.infinity,
//           height: 54,
//           decoration: BoxDecoration(
//             gradient: isActive
//                 ? const LinearGradient(
//                     colors: [Color(0xFFF80500), Color(0xFFF80500)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   )
//                 : null,
//             color: isActive ? null : const Color(0xFFBDBDBD),
//             borderRadius: BorderRadius.circular(13),
//             boxShadow: isActive
//                 ? [
//                     BoxShadow(
//                       color: const Color(0xFFE53935).withOpacity(0.4),
//                       blurRadius: 18,
//                       offset: const Offset(0, 7),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: Center(
//             child: widget.isLoading
//                 ? const SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2.5,
//                     ),
//                   )
//                 : Text(
//                     widget.label,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/auth/auth_provider.dart';
import 'package:brando_app/views/navbar/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ═══════════════════════════════════════════════════════
// CATEGORY MODEL
// ═══════════════════════════════════════════════════════

class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }

  IconData get icon {
    switch (name.toLowerCase()) {
      case 'menpg':
      case 'menspg':
        return Icons.male_rounded;
      case 'womenpg':
      case 'womenspg':
        return Icons.female_rounded;
      case 'colivingpg':
        return Icons.people_alt_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String get displayName {
    switch (name.toLowerCase()) {
      case 'menpg':
      case 'menspg':
        return "Men's Pg";
      case 'womenpg':
      case 'womenspg':
        return "Women's Pg";
      case 'colivingpg':
        return "Coliving Pg";
      default:
        return name;
    }
  }
}

// ═══════════════════════════════════════════════════════
// CATEGORIES API SERVICE
// ═══════════════════════════════════════════════════════

class CategoriesService {
  static const String _baseUrl = 'http://187.127.146.52:2003/api';

  static Future<List<CategoryModel>> getAllCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/Admin/getallCategories'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status code for get all categories ${response.statusCode}');
    print(
      'Response bodyyyyyyyyyyyyyyy for get all categories ${response.body}',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        final categories = (data['categories'] as List)
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return categories;
      }
      throw Exception('API returned success: false');
    }
    throw Exception('Failed to load categories: ${response.statusCode}');
  }
}

// ═══════════════════════════════════════════════════════
// SPLASH SCREEN
// ═══════════════════════════════════════════════════════

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _topImageScale;
  late Animation<double> _topImageOpacity;
  late Animation<double> _bottomLeftImageScale;
  late Animation<double> _bottomLeftImageOpacity;
  late Animation<double> _centerImageScale;
  late Animation<double> _centerImageOpacity;
  late Animation<Offset> _fabSlide;
  late Animation<double> _fabScale;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _buttonOpacity;
  late Animation<double> _floatY;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _topImageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _topImageScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _bottomLeftImageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    _bottomLeftImageScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
      ),
    );

    _centerImageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _centerImageScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _fabSlide = Tween<Offset>(begin: const Offset(0.5, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.5, 0.75, curve: Curves.easeOutBack),
          ),
        );
    _fabScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.75, curve: Curves.elasticOut),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.55, 0.8, curve: Curves.easeOut),
          ),
        );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.8, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
          ),
        );
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
          ),
        );
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    _floatY = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _mainController.forward();

      if (AppPreferences.isLoggedIn()) {
        Future.delayed(const Duration(milliseconds: 1400), () {
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  NavbarScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 500),
            ),
            (route) => false,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -20,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _mainController,
                  _floatController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatY.value * 0.6),
                    child: Opacity(
                      opacity: _topImageOpacity.value,
                      child: Transform.scale(
                        scale: _topImageScale.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: const _OvalImage(
                  imagePath: 'assets/splashimage.png',
                  width: 120,
                  height: 155,
                  borderRadius: 65,
                  rotate: 0.15,
                ),
              ),
            ),

            Positioned(
              top: size.height * 0.28,
              left: -25,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _mainController,
                  _floatController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_floatY.value * 0.8),
                    child: Opacity(
                      opacity: _bottomLeftImageOpacity.value,
                      child: Transform.scale(
                        scale: _bottomLeftImageScale.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: const _OvalImage(
                  imagePath: 'assets/splashimage.png',
                  width: 110,
                  height: 140,
                  borderRadius: 60,
                  rotate: -0.1,
                ),
              ),
            ),

            Positioned(
              top: size.height * 0.04,
              left: size.width * 0.08,
              right: size.width * 0.08,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _mainController,
                  _floatController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatY.value * 0.4),
                    child: Opacity(
                      opacity: _centerImageOpacity.value,
                      child: Transform.scale(
                        scale: _centerImageScale.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: _OvalImage(
                  imagePath: 'assets/splashimage.png',
                  width: double.infinity,
                  height: size.height * 0.38,
                  borderRadius: 999,
                  rotate: 0,
                ),
              ),
            ),

            Positioned(
              top: size.height * 0.33,
              right: size.width * 0.12,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _mainController,
                  _pulseController,
                ]),
                builder: (context, child) {
                  return SlideTransition(
                    position: _fabSlide,
                    child: Transform.scale(
                      scale: _fabScale.value * _pulse.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE53935).withOpacity(0.45),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),

            if (!AppPreferences.isLoggedIn())
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                                height: 1.25,
                                letterSpacing: -0.3,
                              ),
                              children: [
                                TextSpan(text: 'Redefining Your\n'),
                                TextSpan(
                                  text: 'Hostel Booking ',
                                  style: TextStyle(color: Color(0xFFF80500)),
                                ),
                                TextSpan(text: 'Experience'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SlideTransition(
                        position: _subtitleSlide,
                        child: FadeTransition(
                          opacity: _subtitleOpacity,
                          child: const Text(
                            'A hostel booking app should feature quick user registration, searchable listings with filters',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A7A8C),
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SlideTransition(
                        position: _buttonSlide,
                        child: FadeTransition(
                          opacity: _buttonOpacity,
                          child: _RedButton(
                            label: "Let's Get Started",
                            onTap: _goToLogin,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// LOGIN SCREEN
// ═══════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _otpFocus = FocusNode();

  int _resendSeconds = 0;
  Timer? _resendTimer;

  late AnimationController _sheetController;
  late AnimationController _otpAnimController;
  late Animation<double> _otpFieldAnim;
  late Animation<Offset> _otpSlide;

  late AnimationController _floatController;
  late Animation<double> _floatY;

  late Animation<Offset> _sheetSlide;
  late Animation<double> _sheetOpacity;

  @override
  void initState() {
    super.initState();

    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _otpAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _sheetSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _sheetController, curve: Curves.easeOutCubic),
        );
    _sheetOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _sheetController, curve: Curves.easeOut));

    _otpSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _otpAnimController,
            curve: Curves.easeOutBack,
          ),
        );
    _otpFieldAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _otpAnimController, curve: Curves.easeOut),
    );

    _floatY = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _sheetController.forward();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _phoneFocus.dispose();
    _otpFocus.dispose();
    _sheetController.dispose();
    _otpAnimController.dispose();
    _floatController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendSeconds > 0) {
            _resendSeconds--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  Future<void> _handleGetOtp() async {
    if (_phoneController.text.length < 10) return;
    _phoneFocus.unfocus();

    final auth = context.read<AuthProvider>();
    await auth.sendOtp(_phoneController.text.trim());

    if (!mounted) return;

    if (auth.status == AuthStatus.otpSent) {
      _otpAnimController.forward();
      _startResendTimer();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _otpFocus.requestFocus();
      });
    } else if (auth.status == AuthStatus.error) {
      _showErrorSnackbar(auth.errorMessage ?? 'Failed to send OTP');
      auth.clearError();
    }
  }

  Future<void> _handleLogin() async {
    if (_otpController.text.length < 4) return;
    _otpFocus.unfocus();

    final auth = context.read<AuthProvider>();
    await auth.verifyOtp(_otpController.text.trim());

    if (!mounted) return;

    if (auth.status == AuthStatus.verified) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => NavbarScreen()),
        (route) => false,
      );
    } else if (auth.status == AuthStatus.error) {
      _showErrorSnackbar(auth.errorMessage ?? 'OTP verification failed');
      auth.clearError();
    }
  }

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0) return;
    _otpController.clear();

    final auth = context.read<AuthProvider>();
    await auth.sendOtp(_phoneController.text.trim());

    if (!mounted) return;

    if (auth.status == AuthStatus.otpSent) {
      _startResendTimer();
    } else if (auth.status == AuthStatus.error) {
      _showErrorSnackbar(auth.errorMessage ?? 'Failed to resend OTP');
      auth.clearError();
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String get _timerText {
    final min = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final auth = context.watch<AuthProvider>();
    final isLoading = auth.isLoading;
    final otpSent =
        auth.status == AuthStatus.otpSent ||
        auth.status == AuthStatus.verified ||
        auth.status == AuthStatus.error && _otpAnimController.value > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: -10,
            right: -20,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _floatY.value * 0.5),
                child: child,
              ),
              child: const _OvalImage(
                imagePath: 'assets/splashimage.png',
                width: 130,
                height: 160,
                borderRadius: 65,
                rotate: 0.15,
                blur: true,
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.18,
            left: -30,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, -_floatY.value * 0.7),
                child: child,
              ),
              child: const _OvalImage(
                imagePath: 'assets/splashimage.png',
                width: 120,
                height: 150,
                borderRadius: 60,
                rotate: -0.1,
                blur: true,
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.02,
            left: size.width * 0.08,
            right: size.width * 0.08,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _floatY.value * 0.35),
                child: child,
              ),
              child: _OvalImage(
                imagePath: 'assets/splashimage.png',
                width: double.infinity,
                height: size.height * 0.36,
                borderRadius: 999,
                rotate: 0,
                blur: true,
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.28,
            right: size.width * 0.14,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE53935).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _sheetSlide,
              child: FadeTransition(
                opacity: _sheetOpacity,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 30,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 32,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 36,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                              children: [
                                TextSpan(text: 'Find Your '),
                                TextSpan(
                                  text: 'Perfect',
                                  style: TextStyle(color: Color(0xFFE53935)),
                                ),
                                TextSpan(text: ' Stay'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          _InputField(
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            hint: 'Mobile Number',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: Color(0xFF9E9E9E),
                              size: 20,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),

                          if (otpSent) ...[
                            const SizedBox(height: 14),
                            SlideTransition(
                              position: _otpSlide,
                              child: FadeTransition(
                                opacity: _otpFieldAnim,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _InputField(
                                      controller: _otpController,
                                      focusNode: _otpFocus,
                                      hint: 'Enter OTP',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: Color(0xFF9E9E9E),
                                        size: 20,
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: _resendOtp,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Resend ',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            _resendSeconds > 0
                                                ? _timerText
                                                : 'Now',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: _resendSeconds > 0
                                                  ? const Color(0xFFE53935)
                                                  : const Color(0xFF1565C0),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 28),

                          _RedButton(
                            label: isLoading
                                ? ''
                                : (otpSent ? 'Login' : 'Get OTP'),
                            isLoading: isLoading,
                            onTap: otpSent ? _handleLogin : _handleGetOtp,
                            enabled: otpSent
                                ? _otpController.text.length >= 4
                                : _phoneController.text.length == 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// STAY SELECTION MODAL  (API-powered)
// ═══════════════════════════════════════════════════════

// class _StaySelectionModal extends StatefulWidget {
//   const _StaySelectionModal();

//   @override
//   State<_StaySelectionModal> createState() => _StaySelectionModalState();
// }

// class _StaySelectionModalState extends State<_StaySelectionModal>
//     with SingleTickerProviderStateMixin {
//   CategoryModel? _selectedCategory;
//   bool _isConfirming = false;

//   // API state
//   List<CategoryModel> _categories = [];
//   bool _isFetchingCategories = true;
//   String? _fetchError;

//   late AnimationController _animController;
//   late List<Animation<Offset>> _itemSlides;
//   late List<Animation<double>> _itemOpacities;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     // Initialize with empty lists; rebuilt after fetch
//     _itemSlides = [];
//     _itemOpacities = [];

//     _fetchCategories();
//   }

//   Future<void> _fetchCategories() async {
//     setState(() {
//       _isFetchingCategories = true;
//       _fetchError = null;
//     });

//     try {
//       final categories = await CategoriesService.getAllCategories();
//       if (!mounted) return;
//       setState(() {
//         _categories = categories;
//         _isFetchingCategories = false;
//       });
//       _buildItemAnimations();
//       _animController.forward(from: 0);
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _fetchError = 'Failed to load categories. Tap to retry.';
//         _isFetchingCategories = false;
//       });
//     }
//   }

//   void _buildItemAnimations() {
//     _itemSlides = List.generate(
//       _categories.length,
//       (i) =>
//           Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
//             CurvedAnimation(
//               parent: _animController,
//               curve: Interval(
//                 0.1 + i * 0.15,
//                 0.5 + i * 0.15,
//                 curve: Curves.easeOutBack,
//               ),
//             ),
//           ),
//     );

//     _itemOpacities = List.generate(
//       _categories.length,
//       (i) => Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(
//           parent: _animController,
//           curve: Interval(
//             0.1 + i * 0.15,
//             0.5 + i * 0.15,
//             curve: Curves.easeOut,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleConfirm() async {
//     if (_selectedCategory == null) return;
//     setState(() => _isConfirming = true);
//     await Future.delayed(const Duration(milliseconds: 500));
//     if (mounted) {
//       setState(() => _isConfirming = false);
//       Navigator.pop(context);
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => NavbarScreen()),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 30,
//             offset: Offset(0, -8),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Drag handle
//           Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.only(bottom: 24),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),

//           RichText(
//             textAlign: TextAlign.center,
//             text: const TextSpan(
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1A1A2E),
//               ),
//               children: [
//                 TextSpan(text: 'Select Your '),
//                 TextSpan(
//                   text: 'Perfect',
//                   style: TextStyle(color: Color(0xFFE53935)),
//                 ),
//                 TextSpan(text: ' Stay'),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           // ── Body: loading / error / list ──────────────────────────────
//           if (_isFetchingCategories)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 32),
//               child: CircularProgressIndicator(
//                 color: Color(0xFFE53935),
//                 strokeWidth: 2.5,
//               ),
//             )
//           else if (_fetchError != null)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 24),
//               child: GestureDetector(
//                 onTap: _fetchCategories,
//                 child: Column(
//                   children: [
//                     const Icon(
//                       Icons.wifi_off_rounded,
//                       color: Color(0xFFBDBDBD),
//                       size: 40,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       _fetchError!,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF7A7A8C),
//                         height: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Tap to retry',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Color(0xFFE53935),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           else
//             ...List.generate(_categories.length, (i) {
//               final category = _categories[i];
//               final isSelected = _selectedCategory?.id == category.id;

//               // Guard: animations may not be ready yet
//               if (i >= _itemSlides.length) return const SizedBox.shrink();

//               return SlideTransition(
//                 position: _itemSlides[i],
//                 child: FadeTransition(
//                   opacity: _itemOpacities[i],
//                   child: GestureDetector(
//                     onTap: () => setState(() => _selectedCategory = category),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 220),
//                       curve: Curves.easeOut,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       height: 54,
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? const Color(0xFFF80500)
//                             : Colors.white,
//                         borderRadius: BorderRadius.circular(13),
//                         border: Border.all(
//                           color: isSelected
//                               ? const Color(0xFFF80500)
//                               : const Color(0xFFE0E0E0),
//                           width: isSelected ? 0 : 1.4,
//                         ),
//                         boxShadow: isSelected
//                             ? [
//                                 BoxShadow(
//                                   color: const Color(
//                                     0xFFE53935,
//                                   ).withOpacity(0.35),
//                                   blurRadius: 14,
//                                   offset: const Offset(0, 5),
//                                 ),
//                               ]
//                             : [],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 200),
//                             child: Icon(
//                               category.icon,
//                               key: ValueKey(isSelected),
//                               color: isSelected
//                                   ? Colors.white
//                                   : const Color(0xFF9E9E9E),
//                               size: 20,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             category.displayName,
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: isSelected
//                                   ? Colors.white
//                                   : const Color(0xFF1A1A2E),
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),

//           const SizedBox(height: 8),

//           _RedButton(
//             label: _isConfirming ? '' : 'Login',
//             isLoading: _isConfirming,
//             onTap: _handleConfirm,
//             enabled: _selectedCategory != null && !_isFetchingCategories,
//           ),
//         ],
//       ),
//     );
//   }
// }

// ═══════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════

class _OvalImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double borderRadius;
  final double rotate;
  final bool blur;

  const _OvalImage({
    required this.imagePath,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.rotate,
    this.blur = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotate,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(blur ? 0.10 : 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: ColorFiltered(
            colorFilter: blur
                ? ColorFilter.mode(
                    Colors.white.withOpacity(0.18),
                    BlendMode.lighten,
                  )
                : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
            child: Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.keyboardType,
    required this.inputFormatters,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        final isFocused = focusNode.hasFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFocused
                  ? const Color(0xFFE53935)
                  : const Color(0xFFE0E0E0),
              width: isFocused ? 1.8 : 1.2,
            ),
            color: Colors.white,
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: const Color(0xFFE53935).withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: prefixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RedButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool isLoading;

  const _RedButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  State<_RedButton> createState() => _RedButtonState();
}

class _RedButtonState extends State<_RedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.enabled && !widget.isLoading;

    return GestureDetector(
      onTapDown: isActive ? (_) => _pressController.forward() : null,
      onTapUp: isActive
          ? (_) {
              _pressController.reverse();
              widget.onTap();
            }
          : null,
      onTapCancel: isActive ? () => _pressController.reverse() : null,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) =>
            Transform.scale(scale: _pressScale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFFF80500), Color(0xFFF80500)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isActive ? null : const Color(0xFFBDBDBD),
            borderRadius: BorderRadius.circular(13),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFE53935).withOpacity(0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
