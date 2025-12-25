import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/chat.dart';
import '../utils/constants.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListItem({
    Key? key,
    required this.chat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppConstants.surfaceColor,
              backgroundImage: chat.participantImage != null
                  ? CachedNetworkImageProvider(chat.participantImage!)
                  : null,
              child: chat.participantImage == null
                  ? Icon(
                      chat.participantType == 'startup' 
                          ? Icons.business 
                          : Icons.person,
                      color: AppConstants.textSecondaryColor,
                      size: 28,
                    )
                  : null,
            ),
            if (!chat.isRead)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          chat.participantName,
          style: TextStyle(
            color: AppConstants.textPrimaryColor,
            fontWeight: chat.isRead ? FontWeight.w500 : FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat.lastMessage,
              style: TextStyle(
                color: chat.isRead 
                    ? AppConstants.textSecondaryColor 
                    : AppConstants.textPrimaryColor,
                fontWeight: chat.isRead ? FontWeight.normal : FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  chat.participantType == 'startup' 
                      ? Icons.business_outlined 
                      : Icons.person_outline,
                  size: 14,
                  color: AppConstants.textSecondaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  chat.participantType == 'startup' ? 'Startup' : 'Founder',
                  style: const TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(chat.lastMessageTime),
              style: TextStyle(
                color: chat.isRead 
                    ? AppConstants.textSecondaryColor 
                    : AppConstants.primaryColor,
                fontSize: 12,
                fontWeight: chat.isRead ? FontWeight.normal : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppConstants.textSecondaryColor,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${timestamp.day}/${timestamp.month}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Now';
    }
  }
}