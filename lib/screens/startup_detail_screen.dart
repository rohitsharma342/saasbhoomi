import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/startup.dart';
import '../models/founder.dart';
import '../services/data_service.dart';
import '../services/chat_service.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'founder_profile_screen.dart';
import 'chat_screen.dart';

class StartupDetailScreen extends StatelessWidget {
  final Startup startup;

  const StartupDetailScreen({super.key, required this.startup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppConstants.surfaceColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                startup.name,
                style: const TextStyle(
                  color: AppConstants.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.primaryColor.withOpacity(0.3),
                      AppConstants.surfaceColor,
                    ],
                  ),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: startup.logo ?? AppConstants.sampleStartupLogo,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 100,
                        color: AppConstants.cardColor,
                        child: const Icon(
                          Icons.business,
                          color: AppConstants.textSecondaryColor,
                          size: 50,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: AppConstants.cardColor,
                        child: const Icon(
                          Icons.business,
                          color: AppConstants.textSecondaryColor,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<DataService>(
                builder: (context, dataService, child) {
                  return IconButton(
                    onPressed: () {
                      dataService.toggleSaveStartup(startup.id);
                    },
                    icon: Icon(
                      startup.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: startup.isSaved
                          ? AppConstants.primaryColor
                          : AppConstants.textPrimaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          startup.stage,
                          style: const TextStyle(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          startup.category,
                          style: const TextStyle(
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'About',
                    style: TextStyle(
                      color: AppConstants.textPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    startup.description,
                    style: const TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppConstants.textSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Founded in ${startup.foundedDate.year}',
                        style: const TextStyle(
                          color: AppConstants.textSecondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (startup.website != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: AppConstants.textSecondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            startup.website!,
                            style: const TextStyle(
                              color: AppConstants.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (startup.tags.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 24),
                    const Text(
                      'Tags',
                      style: TextStyle(
                        color: AppConstants.textPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: startup.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: AppConstants.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Founders',
                    style: TextStyle(
                      color: AppConstants.textPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<DataService>(
                    builder: (context, dataService, child) {
                      return Column(
                        children: startup.founderIds.map((founderId) {
                          final founder = dataService.getFounderById(founderId);
                          if (founder == null) return const SizedBox();
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppConstants.surfaceColor,
                                backgroundImage: founder.profileImage != null
                                    ? CachedNetworkImageProvider(founder.profileImage!)
                                    : null,
                                child: founder.profileImage == null
                                    ? const Icon(
                                        Icons.person,
                                        color: AppConstants.textSecondaryColor,
                                      )
                                    : null,
                              ),
                              title: Text(
                                founder.name,
                                style: const TextStyle(
                                  color: AppConstants.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                founder.email,
                                style: const TextStyle(
                                  color: AppConstants.textSecondaryColor,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppConstants.textSecondaryColor,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FounderProfileScreen(
                                      founder: founder,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Connect',
                          onPressed: () {
                            final dataService = Provider.of<DataService>(context, listen: false);
                            final chatService = Provider.of<ChatService>(context, listen: false);
                            
                            // Get founders for this startup
                            final founders = startup.founderIds
                                .map((id) => dataService.getFounderById(id))
                                .where((founder) => founder != null)
                                .cast<Founder>()
                                .toList();
                            
                            if (founders.isNotEmpty) {
                              chatService.startChatWithStartup(startup, founders).then((chat) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(chat: chat),
                                  ),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error starting chat: $error'),
                                  ),
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No founders available for this startup'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Contact',
                          isOutlined: true,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Contact feature coming soon!'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}