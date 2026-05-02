import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class ToastHelper {
  static OverlayEntry? _currentToast;

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
    IconData? customIcon,
  }) {
    _currentToast?.remove();
    _currentToast = null;

    final overlay = Overlay.of(context);

    final config = _getConfig(type);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: customIcon ?? config.icon,
        backgroundColor: config.backgroundColor,
        iconColor: config.iconColor,
        textColor: config.textColor,
        duration: duration,
        onDismiss: () {
          entry.remove();
          if (_currentToast == entry) _currentToast = null;
        },
      ),
    );

    _currentToast = entry;
    overlay.insert(entry);
  }

  static _ToastConfig _getConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastConfig(
          icon: Icons.check_circle_rounded,
          backgroundColor: const Color(0xFF1E1E2E),
          iconColor: const Color(0xFF4ADE80),
          textColor: Colors.white,
        );
      case ToastType.error:
        return _ToastConfig(
          icon: Icons.cancel_rounded,
          backgroundColor: const Color(0xFF1E1E2E),
          iconColor: const Color(0xFFFF6B6B),
          textColor: Colors.white,
        );
      case ToastType.warning:
        return _ToastConfig(
          icon: Icons.warning_rounded,
          backgroundColor: const Color(0xFF1E1E2E),
          iconColor: const Color(0xFFFBBF24),
          textColor: Colors.white,
        );
      case ToastType.info:
        return _ToastConfig(
          icon: Icons.info_rounded,
          backgroundColor: const Color(0xFF1E1E2E),
          iconColor: const Color(0xFF60A5FA),
          textColor: Colors.white,
        );
    }
  }
}

class _ToastConfig {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const _ToastConfig({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(widget.duration - const Duration(milliseconds: 400), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon with glow circle
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: widget.iconColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon, color: widget.iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),

                  // Message
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Dismiss button
                  GestureDetector(
                    onTap: () {
                      _controller.reverse().then((_) {
                        if (mounted) widget.onDismiss();
                      });
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.4),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}