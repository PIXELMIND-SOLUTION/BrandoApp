import 'dart:convert';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Returns a human-readable relative time string.
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    }
    final d = diff.inDays;
    return '$d ${d == 1 ? 'day' : 'days'} ago';
  }
}

// ── API Service ───────────────────────────────────────────────────────────────

class NotificationService {
  static const String _baseUrl = 'http://31.97.206.144:2003';

  static Future<List<NotificationItem>> fetchNotifications(
    String userId,
  ) async {
    final uri = Uri.parse('$_baseUrl/api/auth/usernotifications/$userId');

    final response = await http.get(uri);

    print('Response status code for get notification ${response.statusCode}');
    print('Response boddddddddddyyyyy get notification ${response.body}');
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final list = body['notifications'] as List<dynamic>;
      return list
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load notifications (${response.statusCode})');
    }
  }

  static Future<void> deleteNotification(
    String userId,
    String notificationId,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/api/auth/deletenotifications/$userId/$notificationId',
    );
    final response = await http.delete(uri);



  print('Response status for delete notification ${response.statusCode}');
    print('Response boooooooooddddddddddyyyyyyyyyyyy for delete notification ${response.body}');


    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete notification (${response.statusCode})');
    }
  }

  static Future<void> deleteAllNotifications(
    String userId,
    List<NotificationItem> notifications,
  ) async {
    await Future.wait(
      notifications.map((n) => deleteNotification(userId, n.id)).toList(),
    );
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _showSwipeHint = true;

  String get _userId => AppPreferences.getUserId() ?? '';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // ── Data fetching ──────────────────────────────────────────────────────────

  Future<void> _loadNotifications() async {
    if (_userId.isEmpty) {
      setState(() {
        _errorMessage = 'User not logged in.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await NotificationService.fetchNotifications(_userId);
      if (mounted) {
        setState(() {
          _notifications = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load notifications. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _deleteNotification(NotificationItem item) async {
    // Optimistic removal
    setState(() {
      _notifications.removeWhere((n) => n.id == item.id);
      _showSwipeHint = false;
    });

    try {
      await NotificationService.deleteNotification(_userId, item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Notification deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      // Rollback on failure
      if (mounted) {
        setState(() => _notifications.insert(0, item));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to delete notification. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _clearAll() async {
    if (_notifications.isEmpty) return;

    final backup = List<NotificationItem>.from(_notifications);

    // Optimistic clear
    setState(() {
      _notifications.clear();
      _showSwipeHint = false;
    });

    try {
      await NotificationService.deleteAllNotifications(_userId, backup);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('All notifications deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      // Rollback on failure
      if (mounted) {
        setState(() => _notifications = backup);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to clear notifications. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isLoading && _notifications.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              child: const Text(
                'Clear all ✕',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_showSwipeHint)
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
            child: Text(
              'Left Swipe to delete  ‹‹',
              style: TextStyle(color: Colors.red.shade400, fontSize: 12),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadNotifications,
            color: Colors.black,
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _SwipeableNotificationTile(
                  key: ValueKey(notification.id),
                  notification: notification,
                  onDelete: () => _deleteNotification(notification),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class _SwipeableNotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onDelete;

  const _SwipeableNotificationTile({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  /// Pick an icon based on the notification title.
  IconData _iconFor(String title) {
    final t = title.toLowerCase();
    if (t.contains('wishlist')) return Icons.favorite_border;
    if (t.contains('booking')) return Icons.home_outlined;
    if (t.contains('payment')) return Icons.payment_outlined;
    return Icons.notifications_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20),
        child: const Text(
          'Delete',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconFor(notification.title),
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              notification.timeAgo,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
