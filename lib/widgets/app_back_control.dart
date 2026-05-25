import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that controls back button behavior with customizable confirmation dialog
class AppBackControl extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackPressed;
  final bool preventBack;
  final bool showConfirmationDialog;
  final String? dialogTitle;
  final String? dialogMessage;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final Future<bool> Function()? onWillPop;

  const AppBackControl({
    super.key,
    required this.child,
    this.onBackPressed,
    this.preventBack = false,
    this.showConfirmationDialog = false,
    this.dialogTitle,
    this.dialogMessage,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default pop behavior
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        
        // If custom onWillPop is provided, use it
        if (onWillPop != null) {
          final shouldPop = await onWillPop!();
          if (shouldPop) {
            if (context.mounted) {
              _exitApp();
            }
          }
          return;
        }

        // If back is prevented
        if (preventBack) {
          return;
        }

        // If confirmation dialog is enabled
        if (showConfirmationDialog) {
          final shouldPop = await _showConfirmationDialog(context);
          if (shouldPop) {
            onBackPressed?.call();
            onConfirm?.call();
            _exitApp();
          }
          return;
        }

        // Default behavior
        onBackPressed?.call();
        _exitApp();
      },
      child: child,
    );
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          dialogTitle ?? 'Exit?',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          dialogMessage ?? 'Are you sure you want to go back?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              cancelText ?? 'Cancel',
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText ?? 'Exit'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}