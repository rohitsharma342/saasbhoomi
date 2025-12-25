import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../models/founder.dart';
import '../models/startup.dart';

class ChatService extends ChangeNotifier {
  final List<Chat> _chats = [];
  final Map<String, List<Message>> _messages = {};
  User? _currentUser;

  List<Chat> get chats => List.unmodifiable(_chats);
  
  void setCurrentUser(User user) {
    _currentUser = user;
  }

  List<Message> getMessagesForChat(String chatId) {
    return _messages[chatId] ?? [];
  }

  Chat? getChatWithParticipant(String participantId) {
    try {
      return _chats.firstWhere(
        (chat) => chat.participantId == participantId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Chat> startChatWithFounder(Founder founder) async {
    // Check if chat already exists
    final existingChat = getChatWithParticipant(founder.id);
    if (existingChat != null) {
      return existingChat;
    }

    // Create new chat
    final chat = Chat(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      participantId: founder.id,
      participantName: founder.name,
      participantImage: founder.profileImage,
      lastMessage: 'Chat started',
      lastMessageTime: DateTime.now(),
      isRead: true,
      participantType: 'founder',
    );

    _chats.add(chat);
    _messages[chat.id] = [];
    
    // Add initial message
    final initialMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chat.id,
      senderId: _currentUser?.id ?? 'current_user',
      content: 'Hi ${founder.name}! I\'d like to connect with you.',
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    _messages[chat.id]!.add(initialMessage);
    
    notifyListeners();
    return chat;
  }

  Future<Chat> startChatWithStartup(Startup startup, List<Founder> founders) async {
    // For startup chats, we'll chat with the first founder
    if (founders.isEmpty) {
      throw Exception('No founders available for this startup');
    }
    
    final primaryFounder = founders.first;
    
    // Check if chat already exists
    final existingChat = getChatWithParticipant(primaryFounder.id);
    if (existingChat != null) {
      return existingChat;
    }

    // Create new chat
    final chat = Chat(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      participantId: primaryFounder.id,
      participantName: '${startup.name} (${primaryFounder.name})',
      participantImage: startup.logo,
      lastMessage: 'Chat started',
      lastMessageTime: DateTime.now(),
      isRead: true,
      participantType: 'startup',
    );

    _chats.add(chat);
    _messages[chat.id] = [];
    
    // Add initial message
    final initialMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chat.id,
      senderId: _currentUser?.id ?? 'current_user',
      content: 'Hi! I\'m interested in learning more about ${startup.name}.',
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    _messages[chat.id]!.add(initialMessage);
    
    notifyListeners();
    return chat;
  }

  Future<void> sendMessage(String chatId, String content) async {
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: _currentUser?.id ?? 'current_user',
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
    );

    if (_messages[chatId] == null) {
      _messages[chatId] = [];
    }
    
    _messages[chatId]!.add(message);
    
    // Update chat's last message
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(
        lastMessage: content,
        lastMessageTime: DateTime.now(),
        isRead: false,
      );
    }
    
    // Simulate response after a delay
    Future.delayed(const Duration(seconds: 2), () {
      _simulateResponse(chatId);
    });
    
    notifyListeners();
  }

  void _simulateResponse(String chatId) {
    final responses = [
      'Thanks for reaching out! I\'d be happy to discuss this further.',
      'That sounds interesting. Let me know what specific information you need.',
      'I appreciate your interest. When would be a good time to connect?',
      'Great to hear from you! I\'ll get back to you with more details soon.',
      'Thanks for your message. I\'m excited to explore potential collaboration.',
    ];
    
    final chat = _chats.firstWhere((c) => c.id == chatId);
    final responseContent = responses[DateTime.now().millisecond % responses.length];
    
    final response = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: chat.participantId,
      content: responseContent,
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    _messages[chatId]!.add(response);
    
    // Update chat's last message
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(
        lastMessage: responseContent,
        lastMessageTime: DateTime.now(),
        isRead: false,
      );
    }
    
    notifyListeners();
  }

  void markChatAsRead(String chatId) {
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(isRead: true);
    }
    
    // Mark all messages in chat as read
    final messages = _messages[chatId];
    if (messages != null) {
      for (int i = 0; i < messages.length; i++) {
        if (messages[i].senderId != (_currentUser?.id ?? 'current_user')) {
          _messages[chatId]![i] = messages[i].copyWith(isRead: true);
        }
      }
    }
    
    notifyListeners();
  }

  int get unreadChatsCount {
    return _chats.where((chat) => !chat.isRead).length;
  }
}