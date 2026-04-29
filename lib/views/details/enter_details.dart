
import 'dart:io';
import 'package:brando_app/models/submit_hostel_model.dart';
import 'package:brando_app/provider/booking/submit_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EnterDetails extends StatefulWidget {
  final String bookingId; // ✅ changed from hostelId to bookingId

  const EnterDetails({super.key, required this.bookingId});

  @override
  State<EnterDetails> createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _roomNoController = TextEditingController();

  String? _selectedRoomType;
  String? _selectedShareType;

  static const _roomTypes = ['AC', 'Non-AC'];
  static const _shareTypes = [
    '1-sharing',
    '2-sharing',
    '3-sharing',
    '4-sharing',
    '5-sharing',
  ];

  String? _aadharImagePath;
  String? _panImagePath;
  String? _profileImagePath;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _roomNoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      switch (type) {
        case 'aadhar':
          _aadharImagePath = picked.path;
          break;
        case 'pan':
          _panImagePath = picked.path;
          break;
        case 'profile':
          _profileImagePath = picked.path;
          break;
      }
    });
  }

  Future<void> _onProceed() async {
    if (!_formKey.currentState!.validate()) return;

    if (_aadharImagePath == null) {
      _showSnack('Please upload your Aadhar Card image.');
      return;
    }
    if (_panImagePath == null) {
      _showSnack('Please upload your PAN Card image.');
      return;
    }
    if (_profileImagePath == null) {
      _showSnack('Please upload your Profile Photo.');
      return;
    }

    final request = HostelBookingRequestModel(
      name: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      roomNo: _roomNoController.text.trim(),
      roomType: _selectedRoomType!,
      shareType: _selectedShareType!,
      aadharCardImagePath: _aadharImagePath!,
      panCardImagePath: _panImagePath!,
      profileImagePath: _profileImagePath!,
    );

    final provider = context.read<HostelBookingProvider>();
    final success = await provider.submitBooking(
      bookingId: widget.bookingId, // ✅ pass bookingId
      request: request,
    );

    if (!mounted) return;

    if (success) {
      _showSuccessDialog();
    } else {
      _showSnack(provider.errorMessage ?? 'Booking failed. Please try again.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.red, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Submitted!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your booking request has been submitted successfully. You will be notified once confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HostelBookingProvider(),
      child: Builder(builder: (ctx) => _buildScaffold(ctx)),
    );
  }

  Widget _buildScaffold(BuildContext ctx) {
    print('Booking ID: ${widget.bookingId}'); // ✅ debug log
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Enter ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _buildSectionLabel('Profile Photo'),
            const SizedBox(height: 10),
            _buildProfilePicker(),
            const SizedBox(height: 24),
            _buildSectionLabel('Personal Information'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _mobileController,
              label: 'Mobile Number',
              hint: '10-digit mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Mobile is required';
                if (v.trim().length != 10)
                  return 'Enter a valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'example@mail.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Room Details'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _roomNoController,
              label: 'Room Number',
              hint: 'e.g. 101',
              icon: Icons.door_back_door_outlined,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Room number is required'
                  : null,
            ),
            const SizedBox(height: 14),
            _buildDropdown(
              label: 'Room Type',
              hint: 'Select room type',
              icon: Icons.ac_unit_outlined,
              value: _selectedRoomType,
              items: _roomTypes,
              onChanged: (val) => setState(() => _selectedRoomType = val),
              validator: (v) => v == null ? 'Please select a room type' : null,
            ),
            const SizedBox(height: 14),
            _buildDropdown(
              label: 'Share Type',
              hint: 'Select sharing type',
              icon: Icons.people_outline,
              value: _selectedShareType,
              items: _shareTypes,
              onChanged: (val) => setState(() => _selectedShareType = val),
              validator: (v) =>
                  v == null ? 'Please select a share type' : null,
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Upload Documents'),
            const SizedBox(height: 12),
            _buildImageUploadTile(
              label: 'Aadhar Card',
              subtitle: 'Front side of your Aadhar card',
              icon: Icons.badge_outlined,
              imagePath: _aadharImagePath,
              onTap: () => _pickImage('aadhar'),
            ),
            const SizedBox(height: 12),
            _buildImageUploadTile(
              label: 'PAN Card',
              subtitle: 'Front side of your PAN card',
              icon: Icons.credit_card_outlined,
              imagePath: _panImagePath,
              onTap: () => _pickImage('pan'),
            ),
            const SizedBox(height: 32),
            Consumer<HostelBookingProvider>(
              builder: (_, provider, __) => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _onProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.red.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildProfilePicker() {
    return Center(
      child: GestureDetector(
        onTap: () => _pickImage('profile'),
        child: Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF5F5F5),
                border:
                    Border.all(color: Colors.red.withOpacity(0.4), width: 2),
              ),
              child: _profileImagePath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_profileImagePath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person, size: 44, color: Colors.grey),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.camera_alt, size: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.red, size: 20),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.red, size: 20),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
  }

  Widget _buildImageUploadTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required String? imagePath,
    required VoidCallback onTap,
  }) {
    final hasImage = imagePath != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: hasImage ? const Color(0xFFFFF3F3) : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasImage
                ? Colors.red.withOpacity(0.5)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: hasImage ? null : const Color(0xFFFFEBEE),
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(imagePath), fit: BoxFit.cover),
                    )
                  : Icon(icon, color: Colors.red, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasImage ? 'Tap to change' : subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: hasImage ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              hasImage ? Icons.check_circle : Icons.upload_file,
              color: hasImage ? Colors.red : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}