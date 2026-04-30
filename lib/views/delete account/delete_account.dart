import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool _isDeleting = false;

  Future<void> _deleteAccount() async {
    final userId = AppPreferences.getUserId();

    if (userId == null || userId.isEmpty) {
      _showSnackBar("User ID not found. Please login again.", isError: true);
      return;
    }

    setState(() => _isDeleting = true);

    try {
      final response = await http.delete(
        Uri.parse('http://187.127.146.52:2003/api/auth/deleteuser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppPreferences.getAuthToken() ?? ''}',
        },
      );

      final responseData = json.decode(response.body);

      print('Response status code for delete account: ${response.statusCode}');
      print(
        'Response bodyyyyyyyyyyyyyyyyyyy for delete account: ${response.body}',
      );
      print('Userrrrrrrrrrrrr idddddddddddddddddddd for delete account: $userId');

      if (response.statusCode == 200) {
        await AppPreferences.clearAll();

        if (!mounted) return;

        _showSnackBar("Account deleted successfully.");

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
        );
      } else {
        final message = responseData['message'] ?? 'Failed to delete account.';
        _showSnackBar(message, isError: true);
      }
    } catch (e) {
      _showSnackBar("Network error. Please try again.", isError: true);
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: !_isDeleting,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Confirm Delete"),
        content: const Text(
          "Are you sure you want to permanently delete your account?",
        ),
        actions: [
          TextButton(
            onPressed: _isDeleting ? null : () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _isDeleting
                ? null
                : () async {
                    Navigator.pop(context);
                    await _deleteAccount();
                  },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Delete Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                size: 55,
                color: Colors.red.shade700,
              ),
            ),

            const SizedBox(height: 25),

            /// Title
            const Text(
              "We're Sorry to See You Go",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              "Deleting your account is permanent.\nAll your data, bookings, and saved details will be removed forever.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "This action cannot be undone.",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.folder_delete_outlined, color: Colors.red),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "All uploaded files & profile details will be erased.",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isDeleting
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isDeleting ? null : _showConfirmDialog,
                    child: _isDeleting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Delete",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
