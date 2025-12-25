import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/notification.dart';
import '../utils/constants.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationItem({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.connectionRequest:
        return Icons.person_add;
      case NotificationType.connectionAccepted:
        return Icons.check_circle;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.startupUpdate:
        return Icons.business;
      case NotificationType.general:
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.connectionRequest:
      case NotificationType.connectionAccepted:
        return AppConstants.primaryColor;
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.startupUpdate:
        return Colors.green;
      case NotificationType.general:
      default:
        return AppConstants.textSecondaryColor;
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(notification.timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: notification.isRead ? null : AppConstants.surfaceColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (notification.senderImage != null)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppConstants.surfaceColor,
                  backgroundImage: CachedNetworkImageProvider(
                    notification.senderImage!,
                  ),
                )
              else
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _getNotificationColor().withOpacity(0.2),
                  child: Icon(
                    _getNotificationIcon(),
                    color: _getNotificationColor(),
                    size: 20,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: AppConstants.textPrimaryColor,
                            ),
                          ),
                        ),
                        Text(
                          _getTimeAgo(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppConstants.textSecondaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}