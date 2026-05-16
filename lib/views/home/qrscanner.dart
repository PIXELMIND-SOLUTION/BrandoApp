// qr_scanner.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:brando_app/config/theme_config.dart';
import 'package:brando_app/provider/theme_provider.dart';

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

// QR Result Modal
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

// Scanner Overlay Clipper
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

// Corner Painter
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
