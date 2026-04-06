import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _expandedIndex;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _faqSectionKey = GlobalKey();

  static const String _supportEmail = 'support@yourhostelapp.com';
  static const String _supportPhone = '+911234567890'; 

  final List<Map<String, dynamic>> _faqItems = [
    {
      'icon': Icons.search_rounded,
      'question': 'How do I search for hostels?',
      'answer':
          'Use the search bar on the home screen to enter your destination. Filter results by date, price range, dorm type, and amenities. Tap any listing to view photos, reviews, and availability.',
      'category': 'Booking',
    },
    {
      'icon': Icons.payment_rounded,
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept all major credit/debit cards (Visa, Mastercard, Amex), UPI, net banking, PayPal, and select digital wallets. All payments are secured with 256-bit SSL encryption.',
      'category': 'Payment',
    },
    {
      'icon': Icons.cancel_outlined,
      'question': 'What is the cancellation policy?',
      'answer':
          'Cancellation policies vary by hostel. Most offer free cancellation up to 48 hours before check-in. Look for the "Free Cancellation" badge when browsing. Full details are shown on each listing page.',
      'category': 'Booking',
    },
    {
      'icon': Icons.confirmation_number_outlined,
      'question': 'Where can I find my booking confirmation?',
      'answer':
          'Your confirmation is emailed instantly after booking. You can also access all bookings under Profile → My Bookings. Tap any booking to view your e-ticket and QR code for check-in.',
      'category': 'Bookings',
    },
    {
      'icon': Icons.star_outline_rounded,
      'question': 'How do I leave a review?',
      'answer':
          'After your stay, you\'ll receive a notification to rate your experience. Go to Profile → Past Bookings, select the stay, and tap "Write a Review." Reviews help fellow travelers make better decisions!',
      'category': 'Reviews',
    },
    {
      'icon': Icons.lock_outline_rounded,
      'question': 'Is my personal data safe?',
      'answer':
          'Absolutely. We follow GDPR guidelines and never sell your data to third parties. You can download or delete your data anytime from Profile → Privacy Settings.',
      'category': 'Privacy',
    },
    {
      'icon': Icons.group_outlined,
      'question': 'Can I book for a group?',
      'answer':
          'Yes! On the search screen, adjust the "Guests" count. For groups of 8+, use our Group Booking feature or contact support for special rates and arrangements.',
      'category': 'Booking',
    },
    {
      'icon': Icons.wifi_outlined,
      'question': 'Do hostels include Wi-Fi?',
      'answer':
          'Most listed hostels offer free Wi-Fi. Look for the Wi-Fi icon in the amenities section of each listing. Connection speed ratings are provided where available.',
      'category': 'Amenities',
    },
  ];

  List<Map<String, dynamic>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqItems;
    return _faqItems.where((item) {
      return item['question']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['answer'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['category'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // ── Action handlers ───────────────────────────────────────────────────────

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': 'Support Request – Hostel App',
        'body': 'Hi Support Team,\n\nI need help with...',
      },
    );
    if (!await launchUrl(emailUri)) {
      _showErrorSnackbar('Could not open email client.');
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: _supportPhone);
    if (!await launchUrl(phoneUri)) {
      _showErrorSnackbar('Could not open dialer.');
    }
  }

  void _scrollToFaq() {
    final context = _faqSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE94560),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(),
                _buildQuickActions(),
                _buildFaqSection(),
                _buildContactSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A2E),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE94560).withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              const Positioned(
                left: 24,
                bottom: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Help Center',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'We\'re here to help you travel better',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            hintText: 'Search for help topics...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon:
                Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 22),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: Colors.grey.shade400, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.email_outlined,
        'label': 'Email Us',
        'color': const Color(0xFFE94560),
        'onTap': _launchEmail,         
      },
      {
        'icon': Icons.phone_outlined,
        'label': 'Call Us',
        'color': const Color(0xFF2ECC71),
        'onTap': _launchPhone,      
      },
      {
        'icon': Icons.article_outlined,
        'label': 'Guides',
        'color': const Color(0xFFF39C12),
        'onTap': _scrollToFaq,          
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Support',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: actions.map((action) {
              final isLast = action == actions.last;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 10),
                  child: GestureDetector(
                    onTap: action['onTap'] as VoidCallback,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  (action['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              action['icon'] as IconData,
                              color: action['color'] as Color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            action['label'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection() {
    final faqs = _filteredFaqs;

    return Padding(
      // Attach the GlobalKey here so we can scroll to this section
      key: _faqSectionKey,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Frequently Asked',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                '${faqs.length} topics',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (faqs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'No results for "$_searchQuery"',
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
          else
            ...faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isExpanded = _expandedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isExpanded
                            ? const Color(0xFF0F3460).withOpacity(0.3)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(isExpanded ? 0.08 : 0.04),
                          blurRadius: isExpanded ? 16 : 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isExpanded
                                      ? const Color(0xFF0F3460).withOpacity(0.1)
                                      : const Color(0xFFF7F4EF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 18,
                                  color: isExpanded
                                      ? const Color(0xFF0F3460)
                                      : Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['question'] as String,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: isExpanded
                                            ? const Color(0xFF0F3460)
                                            : const Color(0xFF1A1A2E),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['category'] as String,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: isExpanded
                                      ? const Color(0xFF0F3460)
                                      : Colors.grey.shade400,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isExpanded)
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                    color: Colors.grey.shade100, height: 1),
                                const SizedBox(height: 14),
                                Text(
                                  item['answer'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    height: 1.6,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    const Text(
                                      'Was this helpful?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1A1A2E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    _helpfulButton(
                                        Icons.thumb_up_outlined, 'Yes'),
                                    const SizedBox(width: 8),
                                    _helpfulButton(
                                        Icons.thumb_down_outlined, 'No'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _helpfulButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F4EF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Still need help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our support team replies\nwithin 30 minutes.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: _launchEmail, // ← reuses the same email launcher
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94560),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}