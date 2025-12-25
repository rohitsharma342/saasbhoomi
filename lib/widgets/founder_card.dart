import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/founder.dart';
import '../utils/constants.dart';

class FounderCard extends StatelessWidget {
  final Founder founder;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;
  final VoidCallback? onSave;
  final bool showConnectButton;
  final bool showSaveButton;

  const FounderCard({
    Key? key,
    required this.founder,
    this.onTap,
    this.onConnect,
    this.onSave,
    this.showConnectButton = true,
    this.showSaveButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppConstants.surfaceColor,
                    backgroundImage: founder.profileImage != null
                        ? CachedNetworkImageProvider(founder.profileImage!)
                        : null,
                    child: founder.profileImage == null
                        ? const Icon(
                            Icons.person,
                            color: AppConstants.textSecondaryColor,
                            size: 30,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          founder.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (founder.startupIds.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${founder.startupIds.length} Startup${founder.startupIds.length > 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppConstants.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (showSaveButton)
                    IconButton(
                      onPressed: onSave,
                      icon: Icon(
                        founder.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: founder.isSaved
                            ? AppConstants.primaryColor
                            : AppConstants.textSecondaryColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (founder.bio != null)
                Text(
                  founder.bio!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondaryColor,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (founder.skills.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: founder.skills.take(3).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (showConnectButton) ...<Widget>[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: founder.isConnected || founder.isConnectionPending
                            ? null
                            : onConnect,
                        icon: Icon(
                          founder.isConnected
                              ? Icons.check_circle
                              : founder.isConnectionPending
                                  ? Icons.schedule
                                  : Icons.person_add,
                          size: 18,
                        ),
                        label: Text(
                          founder.isConnected
                              ? 'Connected'
                              : founder.isConnectionPending
                                  ? 'Pending'
                                  : 'Connect',
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: founder.isConnected
                                ? AppConstants.primaryColor
                                : founder.isConnectionPending
                                    ? AppConstants.textSecondaryColor
                                    : AppConstants.primaryColor,
                          ),
                          foregroundColor: founder.isConnected
                              ? AppConstants.primaryColor
                              : founder.isConnectionPending
                                  ? AppConstants.textSecondaryColor
                                  : AppConstants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}