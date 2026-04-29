// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/provider/auth/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // Fetch profile on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile().then((_) {
        final name = context.read<ProfileProvider>().profile?.name ?? '';
        _nameController.text = name;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ─── Pick Image from Gallery ─────────────────────────────────────────────

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  // ─── Show Edit Name Dialog ────────────────────────────────────────────────

  void _showEditNameDialog() {
    final tempController = TextEditingController(text: _nameController.text);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Edit Name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: tempController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              _nameController.text = tempController.text.trim();
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Submit Update ────────────────────────────────────────────────────────

  // Future<void> _submitUpdate() async {
  //   final provider = context.read<ProfileProvider>();
  //   final currentName = provider.profile?.name ?? '';
  //   final newName = _nameController.text.trim();

  //   // Check if anything changed
  //   final nameChanged = newName.isNotEmpty && newName != currentName;
  //   final imageChanged = _pickedImage != null;

  //   if (!nameChanged && !imageChanged) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No changes to save.')),
  //     );
  //     return;
  //   }

  //   final success = await provider.updateProfile(
  //     name: nameChanged ? newName : null,
  //     profileImage: imageChanged ? _pickedImage : null,
      
  //   );

  //   if (!mounted) return;

  //   if (success) {
  //     setState(() => _pickedImage = null); // clear local pick after upload
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Profile updated successfully!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(provider.errorMessage ?? 'Update failed.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }




  Future<void> _submitUpdate() async {
  final provider = context.read<ProfileProvider>();
  final currentName = provider.profile?.name ?? '';
  final newName = _nameController.text.trim();

  final nameChanged = newName.isNotEmpty && newName != currentName;
  final imageChanged = _pickedImage != null;

  if (!nameChanged && !imageChanged) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No changes to save.')),
    );
    return;
  }

  final success = await provider.updateProfile(
    name: nameChanged ? newName : null,
    profileImage: imageChanged ? _pickedImage : null,
  );

  if (!mounted) return;

  if (success) {
    _pickedImage = null;

    // ✅ REFRESH PROFILE FROM API
    await provider.fetchProfile();

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Update failed.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final profile = provider.profile;
        final phoneNumber =
            AppPreferences.getMobileNumber() ?? profile?.phoneNumber ?? '';
        final displayName = profile?.name ?? '---';

        // Sync name controller when profile loads (only if user hasn't typed)
        if (profile != null &&
            _nameController.text.isEmpty &&
            (profile.name?.isNotEmpty ?? false)) {
          _nameController.text = profile.name!;
        }

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
          body: provider.status == ProfileStatus.loading && profile == null
              ? const Center(child: CircularProgressIndicator(color: Colors.red))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),

                      // ── Profile Avatar with camera icon ──────────────────
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              // backgroundImage: _pickedImage != null
                              //     ? FileImage(_pickedImage!)
                              //     : (profile?.profileImage != null
                              //         ? NetworkImage(profile!.profileImage!)
                              //             as ImageProvider
                              //         : const AssetImage(
                              //             'assets/profile.png')),


                              backgroundImage: _pickedImage != null
    ? FileImage(_pickedImage!)
    : (profile?.profileImage != null
        ? NetworkImage(
            "${profile!.profileImage!}?v=${DateTime.now().millisecondsSinceEpoch}",
          )
        : const AssetImage('assets/profile.png')) as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Display Name ─────────────────────────────────────
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // ── Phone number ─────────────────────────────────────
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),

                      const SizedBox(height: 32),

                      // ── Full Name Field (editable) ────────────────────────
                      _buildInputField(
                        label: 'Full Name',
                        value: _nameController.text.isNotEmpty
                            ? _nameController.text
                            : displayName,
                        showEditIcon: true,
                        onTap: _showEditNameDialog,
                      ),

                      const SizedBox(height: 16),

                      // ── Phone Number Field (read-only) ───────────────────
                      _buildInputField(
                        label: 'Phone Number',
                        value: phoneNumber,
                        showEditIcon: false,
                      ),

                      const SizedBox(height: 32),

                      // ── Save Button ──────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: provider.isLoading ? null : _submitUpdate,
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
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Error message ────────────────────────────────────
                      if (provider.status == ProfileStatus.error &&
                          provider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required bool showEditIcon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: showEditIcon ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style:
                        const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
                if (showEditIcon)
                  const Icon(Icons.edit, size: 18, color: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    );
  }
}