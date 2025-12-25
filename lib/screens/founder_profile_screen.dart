import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/founder.dart';
import '../services/data_service.dart';
import '../services/chat_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/startup_card.dart';
import '../utils/constants.dart';
import 'startup_detail_screen.dart';
import 'chat_screen.dart';

class FounderProfileScreen extends StatelessWidget {
  final Founder founder;

  const FounderProfileScreen({super.key, required this.founder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppConstants.surfaceColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                founder.name,
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
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppConstants.cardColor,
                    backgroundImage: founder.profileImage != null
                        ? CachedNetworkImageProvider(founder.profileImage!)
                        : null,
                    child: founder.profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppConstants.textSecondaryColor,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<DataService>(
                builder: (context, dataService, child) {
                  return IconButton(
                    onPressed: () {
                      dataService.toggleSaveFounder(founder.id);
                    },
                    icon: Icon(
                      founder.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: founder.isSaved
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
                  Text(
                    founder.email,
                    style: const TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (founder.bio != null) ...<Widget>[
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
                      founder.bio!,
                      style: const TextStyle(
                        color: AppConstants.textSecondaryColor,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppConstants.textSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Joined ${founder.joinedDate.year}',
                        style: const TextStyle(
                          color: AppConstants.textSecondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (founder.skills.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 24),
                    const Text(
                      'Skills',
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
                      children: founder.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: AppConstants.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (founder.interests.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 24),
                    const Text(
                      'Interests',
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
                      children: founder.interests.map((interest) {
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
                            interest,
                            style: const TextStyle(
                              color: AppConstants.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (founder.startupIds.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 24),
                    const Text(
                      'Associated Startups',
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
                          children: founder.startupIds.map((startupId) {
                            final startup = dataService.getStartupById(startupId);
                            if (startup == null) return const SizedBox();
                            
                            return StartupCard(
                              startup: startup,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StartupDetailScreen(
                                      startup: startup,
                                    ),
                                  ),
                                );
                              },
                              onSave: () {
                                dataService.toggleSaveStartup(startup.id);
                              },
                              showSaveButton: false,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 32),
                  Consumer<DataService>(
                    builder: (context, dataService, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: founder.isConnected
                                  ? 'Connected'
                                  : founder.isConnectionPending
                                      ? 'Pending'
                                      : 'Connect',
                              onPressed: founder.isConnected || founder.isConnectionPending
                                  ? null
                                  : () {
                                      dataService.sendConnectionRequest(founder.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Connection request sent!'),
                                        ),
                                      );
                                    },
                              backgroundColor: founder.isConnected
                                  ? AppConstants.primaryColor.withOpacity(0.7)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Message',
                              isOutlined: true,
                              onPressed: () {
                                final chatService = Provider.of<ChatService>(context, listen: false);
                                
                                chatService.startChatWithFounder(founder).then((chat) {
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
                              },
                            ),
                          ),
                        ],
                      );
                    },
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