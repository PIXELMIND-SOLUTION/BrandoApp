
import 'dart:async';

import 'package:brando_app/views/navbar/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));
    _topImageScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.0, 0.4, curve: Curves.elasticOut)));

    _bottomLeftImageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.1, 0.5, curve: Curves.easeOut)));
    _bottomLeftImageScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.1, 0.5, curve: Curves.elasticOut)));

    _centerImageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOut)));
    _centerImageScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack)));

    _fabSlide =
        Tween<Offset>(begin: const Offset(0.5, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _mainController,
              curve: const Interval(0.5, 0.75, curve: Curves.easeOutBack)));
    _fabScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.5, 0.75, curve: Curves.elasticOut)));

    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _mainController,
              curve: const Interval(0.55, 0.8, curve: Curves.easeOut)));
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.55, 0.8, curve: Curves.easeOut)));

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _mainController,
              curve: const Interval(0.65, 0.85, curve: Curves.easeOut)));
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.65, 0.85, curve: Curves.easeOut)));

    _buttonSlide =
        Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
          CurvedAnimation(parent: _mainController,
              curve: const Interval(0.75, 1.0, curve: Curves.easeOut)));
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.75, 1.0, curve: Curves.easeOut)));

    _floatY = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _mainController.forward();
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
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation,
                curve: Curves.easeOutCubic)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Top-right small oval image
            Positioned(
              top: -10,
              right: -20,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    [_mainController, _floatController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatY.value * 0.6),
                    child: Opacity(
                      opacity: _topImageOpacity.value,
                      child: Transform.scale(
                          scale: _topImageScale.value, child: child),
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

            // Bottom-left small oval image
            Positioned(
              top: size.height * 0.28,
              left: -25,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    [_mainController, _floatController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_floatY.value * 0.8),
                    child: Opacity(
                      opacity: _bottomLeftImageOpacity.value,
                      child: Transform.scale(
                          scale: _bottomLeftImageScale.value, child: child),
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

            // Center large oval image
            Positioned(
              top: size.height * 0.04,
              left: size.width * 0.08,
              right: size.width * 0.08,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    [_mainController, _floatController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatY.value * 0.4),
                    child: Opacity(
                      opacity: _centerImageOpacity.value,
                      child: Transform.scale(
                          scale: _centerImageScale.value, child: child),
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

            // Red FAB arrow
            Positioned(
              top: size.height * 0.33,
              right: size.width * 0.12,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    [_mainController, _pulseController]),
                builder: (context, child) {
                  return SlideTransition(
                    position: _fabSlide,
                    child: Transform.scale(
                        scale: _fabScale.value * _pulse.value, child: child),
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
                      Icons.arrow_outward_rounded, color: Colors.white,
                      size: 26),
                ),
              ),
            ),

            // Bottom content
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
                            style: TextStyle(fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                                height: 1.25,
                                letterSpacing: -0.3),
                            children: [
                              TextSpan(text: 'Redefining Your\n'),
                              TextSpan(text: 'Hostel Booking ',
                                  style: TextStyle(
                                      color: Color(0xFFF80500))),
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
                          style: TextStyle(fontSize: 14,
                              color: Color(0xFF7A7A8C),
                              height: 1.6,
                              fontWeight: FontWeight.w400),
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

  bool _otpSent = false;
  bool _isLoading = false;

  // OTP resend timer
  int _resendSeconds = 0;
  Timer? _resendTimer;

  // Animations
  late AnimationController _sheetController;
  late AnimationController _otpController2;
  late Animation<Offset> _sheetSlide;
  late Animation<double> _sheetOpacity;
  late Animation<double> _otpFieldAnim;
  late Animation<Offset> _otpSlide;

  // Float for background images
  late AnimationController _floatController;
  late Animation<double> _floatY;

  @override
  void initState() {
    super.initState();

    _sheetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _otpController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _floatController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);

    _sheetSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _sheetController,
              curve: Curves.easeOutCubic));
    _sheetOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _sheetController, curve: Curves.easeOut));

    _otpSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _otpController2, curve: Curves.easeOutBack));
    _otpFieldAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _otpController2, curve: Curves.easeOut));

    _floatY = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

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
    _otpController2.dispose();
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

  void _handleGetOtp() async {
    if (_phoneController.text.length < 10) return;
    _phoneFocus.unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _otpSent = true;
      });
      _otpController2.forward();
      _startResendTimer();
      Future.delayed(const Duration(milliseconds: 300), () {
        _otpFocus.requestFocus();
      });
    }
  }

  void _handleLogin() async {
    if (_otpController.text.length < 4) return;
    _otpFocus.unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to home or show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login Successful! 🎉'),
          backgroundColor: const Color.fromARGB(255, 107, 241, 97),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.push(context, MaterialPageRoute(builder: (context)=>NavbarScreen()));
    }
  }

  void _resendOtp() {
    if (_resendSeconds > 0) return;
    _otpController.clear();
    _startResendTimer();
  }

  String get _timerText {
    final min = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Background blurred images (same as splash) ──
          Positioned(
            top: -10,
            right: -20,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) =>
                  Transform.translate(
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
              builder: (context, child) =>
                  Transform.translate(
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
              builder: (context, child) =>
                  Transform.translate(
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

          // Red FAB decoration
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
                  Icons.arrow_outward_rounded, color: Colors.white, size: 24),
            ),
          ),

          // ── Bottom Sheet Card ──
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
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom + 36,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
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

                          // Title
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

                          // Phone field
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
                                Icons.phone_outlined, color: Color(0xFF9E9E9E),
                                size: 20),
                            onChanged: (_) => setState(() {}),
                          ),

                          // Animated OTP field
                          if (_otpSent) ...[
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
                                          color: Color(0xFF9E9E9E), size: 20),
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

                          // Button
                          _RedButton(
                            label: _isLoading
                                ? ''
                                : (_otpSent ? 'Login' : 'Get OTP'),
                            isLoading: _isLoading,
                            onTap: _otpSent ? _handleLogin : _handleGetOtp,
                            enabled: _otpSent
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
                Colors.white.withOpacity(0.18), BlendMode.lighten)
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
              )
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
                  horizontal: 16, vertical: 16),
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
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut));
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
              )
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