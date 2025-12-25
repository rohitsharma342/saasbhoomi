import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/notification_item.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'founder_profile_screen.dart';
import 'startup_detail_screen.dart';

enum NotificationType {
  connectionRequest,
  connectionAccepted,
  startupUpdate,
  message,
  general,
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppConstants.surfaceColor,
        elevation: 1,
        actions: [
          Consumer<DataService>(
            builder: (context, dataService, child) {
              if (dataService.unreadNotificationCount > 0) {
                return TextButton(
                  onPressed: () {
                    dataService.markAllNotificationsAsRead();
                  },
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final notifications = dataService.notifications;

          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: AppConstants.textSecondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We\'ll notify you when something interesting happens',
                    style: TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationItem(
                notification: notification,
                onTap: () {
                  // Mark notification as read
                  dataService.markNotificationAsRead(notification.id);
                  
                  // Navigate to relevant screen based on notification type
                  _handleNotificationTap(context, notification, dataService);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    notification,
    DataService dataService,
  ) {
    switch (notification.type) {
      case NotificationType.connectionRequest:
        if (notification.relatedId != null) {
          final founder = dataService.getFounderById(notification.relatedId!);
          if (founder != null) {
            _showConnectionRequestDialog(context, founder, dataService);
          }
        }
        break;
      case NotificationType.connectionAccepted:
        if (notification.relatedId != null) {
          final founder = dataService.getFounderById(notification.relatedId!);
          if (founder != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FounderProfileScreen(founder: founder),
              ),
            );
          }
        }
        break;
      case NotificationType.startupUpdate:
        if (notification.relatedId != null) {
          final startup = dataService.getStartupById(notification.relatedId!);
          if (startup != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartupDetailScreen(startup: startup),
              ),
            );
          }
        }
        break;
      default:
        // For general notifications or message notifications,
        // show a simple acknowledgment
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notification.message),
          ),
        );
    }
  }

  void _showConnectionRequestDialog(
    BuildContext context,
    founder,
    DataService dataService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: const Text(
          'Connection Request',
          style: TextStyle(color: AppConstants.textPrimaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppConstants.surfaceColor,
              backgroundImage: founder.profileImage != null
                  ? NetworkImage(founder.profileImage!)
                  : null,
              child: founder.profileImage == null
                  ? const Icon(
                      Icons.person,
                      color: AppConstants.textSecondaryColor,
                      size: 30,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              '${founder.name} wants to connect with you',
              style: const TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Decline',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          ),
          CustomButton(
            text: 'Accept',
            onPressed: () {
              dataService.acceptConnectionRequest(founder.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connection accepted!'),
                ),
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ),
    );
  }
}