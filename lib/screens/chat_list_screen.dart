import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';
import '../widgets/chat_list_item.dart';
import '../utils/constants.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: AppConstants.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppConstants.surfaceColor,
        elevation: 1,
        iconTheme: const IconThemeData(
          color: AppConstants.textPrimaryColor,
        ),
      ),
      body: Consumer<ChatService>(
        builder: (context, chatService, child) {
          final chats = chatService.chats;
          
          if (chats.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: AppConstants.textSecondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      color: AppConstants.textPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start connecting with founders and startups\nto begin conversations',
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
          
          // Sort chats by last message time
          final sortedChats = List.from(chats)
            ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sortedChats.length,
            itemBuilder: (context, index) {
              final chat = sortedChats[index];
              return ChatListItem(
                chat: chat,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chat: chat),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}