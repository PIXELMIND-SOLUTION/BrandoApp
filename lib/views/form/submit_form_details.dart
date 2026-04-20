import 'package:brando_app/models/submit_hostel_model.dart';
import 'package:brando_app/provider/booking/submit_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SubmitFormDetails extends StatefulWidget {
  final String hostelId;

  const SubmitFormDetails({super.key, required this.hostelId});

  @override
  State<SubmitFormDetails> createState() => _SubmitFormDetailsState();
}

class _SubmitFormDetailsState extends State<SubmitFormDetails> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _roomNoController = TextEditingController();

  String _selectedRoomType = 'AC';
  String _selectedShareType = '2-sharing';

  File? _aadharFile;
  File? _panFile;
  File? _profileFile;

  final ImagePicker _picker = ImagePicker();

  final List<String> _roomTypes = ['AC', 'Non-AC'];
  final List<String> _shareTypes = ['1-sharing', '2-sharing', '3-sharing', '4-sharing'];

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _roomNoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;
    setState(() {
      switch (type) {
        case 'aadhar':
          _aadharFile = File(picked.path);
          break;
        case 'pan':
          _panFile = File(picked.path);
          break;
        case 'profile':
          _profileFile = File(picked.path);
          break;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_aadharFile == null || _panFile == null || _profileFile == null) {
      _showSnack('Please upload all required documents', isError: true);
      return;
    }

    final provider = context.read<HostelBookingProvider>();

    final success = await provider.submitBooking(
      hostelId: '69ba8f43b2268dc36d53851a',
      request: HostelBookingRequestModel(
        name: _nameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        roomNo: _roomNoController.text.trim(),
        roomType: _selectedRoomType,
        shareType: _selectedShareType,
        email: _emailController.text.trim(),
        aadharCardImagePath: _aadharFile!.path,
        panCardImagePath: _panFile!.path,
        profileImagePath: _profileFile!.path,
      ),
    );

    if (!mounted) return;

    if (success) {
      _showSuccessDialog(provider.bookingDetails);
    } else {
      _showSnack(provider.errorMessage ?? 'Booking failed', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog(BookingDetails? details) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Booking Submitted!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your booking request has been submitted successfully.'),
            if (details != null) ...[
              const SizedBox(height: 12),
              _infoRow('Status', details.status),
              _infoRow('Payment', details.paymentStatus),
              _infoRow('Room No', details.roomNo),
              _infoRow('Room Type', details.roomType),
              _infoRow('Share Type', details.shareType),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HostelBookingProvider>().reset();
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(value, style: const TextStyle(fontSize: 13)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    print('hhhhhhhhhhhoooooooooooooosteeeeeeeeeeeeeelddd ${widget.hostelId}');
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<HostelBookingProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  children: [
                    // ── Profile Photo ──────────────────────────────
                    _buildProfilePicker(),
                    const SizedBox(height: 24),

                    // ── Personal Info ──────────────────────────────
                    _sectionLabel('Personal Information'),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _mobileController,
                      label: 'Mobile Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Mobile is required';
                        if (v.trim().length != 10) return 'Enter a valid 10-digit number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── Room Details ───────────────────────────────
                    _sectionLabel('Room Details'),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _roomNoController,
                      label: 'Room Number',
                      icon: Icons.door_front_door_outlined,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Room number is required' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildDropdown(
                      label: 'Room Type',
                      icon: Icons.ac_unit_outlined,
                      value: _selectedRoomType,
                      items: _roomTypes,
                      onChanged: (v) => setState(() => _selectedRoomType = v!),
                    ),
                    const SizedBox(height: 14),
                    _buildDropdown(
                      label: 'Share Type',
                      icon: Icons.people_outline,
                      value: _selectedShareType,
                      items: _shareTypes,
                      onChanged: (v) => setState(() => _selectedShareType = v!),
                    ),

                    const SizedBox(height: 24),

                    // ── Documents ──────────────────────────────────
                    _sectionLabel('Documents'),
                    const SizedBox(height: 12),
                    _buildDocumentPicker(
                      label: 'Aadhar Card',
                      icon: Icons.credit_card_outlined,
                      file: _aadharFile,
                      onTap: () => _pickImage('aadhar'),
                    ),
                    const SizedBox(height: 12),
                    _buildDocumentPicker(
                      label: 'PAN Card',
                      icon: Icons.badge_outlined,
                      file: _panFile,
                      onTap: () => _pickImage('pan'),
                    ),

                    const SizedBox(height: 32),

                    // ── Submit Button ──────────────────────────────
                    _buildSubmitButton(provider),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // ── Full-screen loading overlay ────────────────────
              if (provider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.35),
                  child: const Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Submitting booking...',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF5B6BF8),
          letterSpacing: 0.4,
        ),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5B6BF8), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5B6BF8), width: 1.5),
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
  }

  Widget _buildProfilePicker() {
    return Center(
      child: GestureDetector(
        onTap: () => _pickImage('profile'),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: const Color(0xFFE8EAFF),
              backgroundImage:
                  _profileFile != null ? FileImage(_profileFile!) : null,
              child: _profileFile == null
                  ? const Icon(Icons.person, size: 48, color: Color(0xFF5B6BF8))
                  : null,
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF5B6BF8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentPicker({
    required String label,
    required IconData icon,
    required File? file,
    required VoidCallback onTap,
  }) {
    final bool picked = file != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: picked ? const Color(0xFFEEF0FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: picked ? const Color(0xFF5B6BF8) : Colors.grey.shade200,
            width: picked ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: picked ? const Color(0xFF5B6BF8) : Colors.grey.shade500),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                picked ? file!.path.split('/').last : 'Upload $label',
                style: TextStyle(
                  fontSize: 14,
                  color: picked ? const Color(0xFF5B6BF8) : Colors.grey.shade500,
                  fontWeight: picked ? FontWeight.w500 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              picked ? Icons.check_circle : Icons.upload_file_outlined,
              size: 20,
              color: picked ? Colors.green : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(HostelBookingProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B6BF8),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: provider.isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Submit Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}