import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/startup.dart';
import '../utils/constants.dart';

class StartupCard extends StatelessWidget {
  final Startup startup;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool showSaveButton;

  const StartupCard({
    Key? key,
    required this.startup,
    this.onTap,
    this.onSave,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: startup.logo ?? AppConstants.sampleStartupLogo,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 50,
                        height: 50,
                        color: AppConstants.surfaceColor,
                        child: const Icon(
                          Icons.business,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 50,
                        height: 50,
                        color: AppConstants.surfaceColor,
                        child: const Icon(
                          Icons.business,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          startup.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                            startup.stage,
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
                        startup.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: startup.isSaved
                            ? AppConstants.primaryColor
                            : AppConstants.textSecondaryColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                startup.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondaryColor,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    startup.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Founded ${startup.foundedDate.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              if (startup.tags.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: startup.tags.take(3).map((tag) {
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
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}