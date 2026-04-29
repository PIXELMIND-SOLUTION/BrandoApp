import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedTopic = 'General Inquiry';
  bool _isSending = false;
  bool _sent = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  final List<String> _topics = [
    'General Inquiry',
    'Order Support',
    'Returns & Refunds',
    'Product Feedback',
    'Partnership',
  ];

  static const _bg = Color(0xFF0D0D0D);
  static const _surface = Color(0xFF1A1A1A);
  static const _accent = Color(0xFFE8C47A);
  static const _accentDim = Color(0x33E8C47A);
  static const _textPrimary = Color(0xFFF5F0E8);
  static const _textMuted = Color(0xFF8A8070);
  static const _border = Color(0xFF2A2A2A);

  static const String _baseUrl = 'http://187.127.146.52:2003';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = AppPreferences.getUserId();
    if (userId == null || userId.isEmpty) {
      setState(() {
        _errorMessage = 'User session not found. Please log in again.';
      });
      return;
    }

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final uri = Uri.parse('$_baseUrl/api/auth/createticket');

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              if (AppPreferences.getAuthToken() != null)
                'Authorization': 'Bearer ${AppPreferences.getAuthToken()}',
            },
            body: jsonEncode({
              'userId': userId,
              'title': _selectedTopic,
              'message': _messageController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;



      print('Response status code for send contact us ${response.statusCode}');
            print('Response bodddddddddddddddyyyyyyyyyyyyyyy for send contact us ${response.body}');


      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          setState(() {
            _isSending = false;
            _sent = true;
          });
        } else {
          setState(() {
            _isSending = false;
            _errorMessage =
                data['message'] as String? ?? 'Something went wrong.';
          });
        }
      } else {
        setState(() {
          _isSending = false;
          _errorMessage =
              data['message'] as String? ?? 'Server error. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isSending = false;
        _errorMessage = 'Network error. Please check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: _sent ? _buildSuccessState() : _buildFormState(),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _accentDim,
                shape: BoxShape.circle,
                border: Border.all(color: _accent, width: 1.5),
              ),
              child: const Icon(Icons.check_rounded, color: _accent, size: 36),
            ),
            const SizedBox(height: 28),
            const Text(
              'Message Sent',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "We've received your message and will\nget back to you within 24 hours.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _textMuted,
                height: 1.7,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: _accent.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: _accent,
                    fontSize: 13,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildContactCards(),
              _buildForm(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _border),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: _textPrimary, size: 16),
                ),
              ),
              const Spacer(),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'BR',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        letterSpacing: 3,
                      ),
                    ),
                    TextSpan(
                      text: 'ANDO',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: _accent,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GET IN',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        height: 1,
                        letterSpacing: 1,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 1.5,
                          color: _accent,
                          margin: const EdgeInsets.only(right: 10, bottom: 4),
                        ),
                        Text(
                          'TOUCH',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 38,
                            fontWeight: FontWeight.w300,
                            color: _accent,
                            height: 1,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildContactCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Row(
        children: [
          _contactTile(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: 'hello@brando.co',
            onTap: () => _launchUrl('mailto:hello@brando.co'),
          ),
          const SizedBox(width: 12),
          _contactTile(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: '+1 800 BRANDO',
            onTap: () => _launchUrl('tel:+18002726360'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the app'),
            backgroundColor: Color(0xFF2A2A2A),
          ),
        );
      }
    }
  }

  Widget _contactTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: _accent, size: 20),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: _textMuted,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: _textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('YOUR DETAILS'),
            const SizedBox(height: 14),
            _buildInput(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _buildInput(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 28),
            _sectionLabel('TOPIC'),
            const SizedBox(height: 14),
            _buildTopicSelector(),
            const SizedBox(height: 28),
            _sectionLabel('MESSAGE'),
            const SizedBox(height: 14),
            _buildTextArea(),
            const SizedBox(height: 16),

            // ── Error Banner ──────────────────────────────────────────────
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade900.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade800, width: 0.8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: Colors.red.shade400, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: _textMuted,
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 14,
        letterSpacing: 0.2,
      ),
      cursorColor: _accent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _textMuted, fontSize: 13),
        floatingLabelStyle: const TextStyle(color: _accent, fontSize: 11),
        prefixIcon: Icon(icon, color: _textMuted, size: 18),
        filled: true,
        fillColor: _surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _accent, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red.shade400, fontSize: 11),
      ),
    );
  }

  Widget _buildTopicSelector() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTopic,
          isExpanded: true,
          dropdownColor: const Color(0xFF222222),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: _textMuted, size: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
          onChanged: (val) {
            if (val != null) setState(() => _selectedTopic = val);
          },
          items: _topics
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return TextFormField(
      controller: _messageController,
      maxLines: 5,
      validator: (v) =>
          v == null || v.trim().isEmpty ? 'Please write your message' : null,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 14,
        height: 1.6,
        letterSpacing: 0.2,
      ),
      cursorColor: _accent,
      decoration: InputDecoration(
        hintText: 'How can we help you today?',
        hintStyle: const TextStyle(color: _textMuted, fontSize: 13),
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _accent, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red.shade400, fontSize: 11),
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isSending ? _accentDim : _accent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: _isSending ? null : _handleSend,
            splashColor: Colors.black12,
            child: Center(
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _accent,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SEND MESSAGE',
                          style: TextStyle(
                            color: _bg,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, color: _bg, size: 16),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}