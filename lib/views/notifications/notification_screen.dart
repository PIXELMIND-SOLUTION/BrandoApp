import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotificationScreen(),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Your Hostel booking is confirmed',
      subtitle: 'Lorem Ipsum Delopl Wmd',
      time: '1 day ago',
    ),
    NotificationItem(
      id: '2',
      title: 'Your Hostel booking is confirmed',
      subtitle: 'Lorem Ipsum Delopl Wmd',
      time: '2 days ago',
    ),
    NotificationItem(
      id: '3',
      title: 'Your Hostel booking is confirmed',
      subtitle: 'Lorem Ipsum Delopl Wmd',
      time: '3 days ago',
    ),
  ];

  bool _showSwipeHint = true;

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
      _showSwipeHint = false;
    });
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
      _showSwipeHint = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              child: const Text(
                'Clear all ✕',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_showSwipeHint)
                  Padding(
                    padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
                    child: Text(
                      'Left Swipe to delete  ‹‹',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _SwipeableNotificationTile(
                        key: ValueKey(notification.id),
                        notification: notification,
                        onDelete: () => _deleteNotification(notification.id),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _SwipeableNotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onDelete;

  const _SwipeableNotificationTile({
    super.key,
    required this.notification,
    required this.onDelete,
  });

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
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE)),
          ),
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
              child: Icon(Icons.home_outlined, color: Colors.grey.shade600),
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
                    notification.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}