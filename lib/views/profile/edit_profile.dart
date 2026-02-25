import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Personal ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              TextSpan(
                text: 'Information',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.png'),
                backgroundColor: Colors.grey[300],
              ),
            ),

            const SizedBox(height: 12),

            // Name
            const Text(
              'Narasimha varma',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 4),

            // Phone number under name
            const Text(
              '9897989798',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 32),

            // Full Name Field
            _buildInputField(
              label: 'Full Name',
              value: 'Tommy',
              showEditIcon: true,
            ),

            const SizedBox(height: 16),

            // Phone Number Field
            _buildInputField(
              label: 'Phone Number',
              value: '1234567890',
              showEditIcon: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required bool showEditIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              if (showEditIcon)
                const Icon(Icons.edit, size: 18, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }
}
