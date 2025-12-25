import 'package:flutter/foundation.dart';
import '../models/startup.dart';
import '../models/founder.dart';
import '../models/notification.dart';
import '../utils/constants.dart';

class DataService extends ChangeNotifier {
  List<Startup> _startups = [];
  List<Founder> _founders = [];
  List<AppNotification> _notifications = [];
  List<Startup> _savedStartups = [];
  List<Founder> _savedFounders = [];
  List<Founder> _connections = [];
  String _searchQuery = '';
  int _selectedTabIndex = 0;

  List<Startup> get startups => _startups;
  List<Founder> get founders => _founders;
  List<AppNotification> get notifications => _notifications;
  List<Startup> get savedStartups => _savedStartups;
  List<Founder> get savedFounders => _savedFounders;
  List<Founder> get connections => _connections;
  String get searchQuery => _searchQuery;
  int get selectedTabIndex => _selectedTabIndex;
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  void initialize() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _startups = [
      Startup(
        id: '1',
        name: 'TechFlow AI',
        description: 'AI-powered workflow automation platform for businesses',
        logo: AppConstants.sampleStartupLogo,
        founderIds: ['f1'],
        category: 'AI/ML',
        stage: 'Series A',
        foundedDate: DateTime(2022, 1, 15),
        website: 'https://techflow.ai',
        tags: ['AI', 'Automation', 'SaaS'],
      ),
      Startup(
        id: '2',
        name: 'DataSync Pro',
        description: 'Real-time data synchronization for enterprise applications',
        logo: AppConstants.sampleTechImage,
        founderIds: ['f2'],
        category: 'Enterprise Software',
        stage: 'Seed',
        foundedDate: DateTime(2023, 3, 20),
        website: 'https://datasync.pro',
        tags: ['Data', 'Enterprise', 'Integration'],
      ),
      Startup(
        id: '3',
        name: 'CloudScale',
        description: 'Scalable cloud infrastructure management platform',
        logo: AppConstants.sampleStartupLogo,
        founderIds: ['f3'],
        category: 'DevOps',
        stage: 'MVP',
        foundedDate: DateTime(2023, 6, 10),
        tags: ['Cloud', 'DevOps', 'Infrastructure'],
      ),
    ];

    _founders = [
      Founder(
        id: 'f1',
        name: 'Priya Sharma',
        email: 'priya@techflow.ai',
        bio: 'AI researcher turned entrepreneur. Building the future of automation.',
        profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        startupIds: ['1'],
        skills: ['AI/ML', 'Python', 'Product Strategy'],
        interests: ['Artificial Intelligence', 'Startups', 'Technology'],
        joinedDate: DateTime(2022, 1, 1),
      ),
      Founder(
        id: 'f2',
        name: 'Rahul Gupta',
        email: 'rahul@datasync.pro',
        bio: 'Former Google engineer passionate about data infrastructure',
        profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        startupIds: ['2'],
        skills: ['Backend Development', 'System Design', 'Leadership'],
        interests: ['Data Engineering', 'Scalability', 'Innovation'],
        joinedDate: DateTime(2023, 2, 15),
      ),
      Founder(
        id: 'f3',
        name: 'Ananya Patel',
        email: 'ananya@cloudscale.io',
        bio: 'DevOps expert building next-gen cloud solutions',
        profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        startupIds: ['3'],
        skills: ['DevOps', 'Kubernetes', 'Cloud Architecture'],
        interests: ['Cloud Computing', 'Open Source', 'Mentoring'],
        joinedDate: DateTime(2023, 5, 20),
      ),
    ];

    _notifications = [
      AppNotification(
        id: '1',
        title: 'Connection Request',
        message: 'Priya Sharma wants to connect with you',
        type: NotificationType.connectionRequest,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        relatedId: 'f1',
        senderName: 'Priya Sharma',
        senderImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      ),
      AppNotification(
        id: '2',
        title: 'New Startup Posted',
        message: 'CloudScale just launched their MVP',
        type: NotificationType.startupUpdate,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        relatedId: '3',
      ),
    ];

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  List<Startup> getFilteredStartups() {
    if (_searchQuery.isEmpty) return _startups;
    return _startups.where((startup) {
      return startup.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             startup.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             startup.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  List<Founder> getFilteredFounders() {
    if (_searchQuery.isEmpty) return _founders;
    return _founders.where((founder) {
      return founder.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             founder.bio?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
             founder.skills.any((skill) => skill.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  void toggleSaveStartup(String startupId) {
    final startup = _startups.firstWhere((s) => s.id == startupId);
    final index = _startups.indexOf(startup);
    _startups[index] = startup.copyWith(isSaved: !startup.isSaved);
    
    if (startup.isSaved) {
      _savedStartups.removeWhere((s) => s.id == startupId);
    } else {
      _savedStartups.add(_startups[index]);
    }
    notifyListeners();
  }

  void toggleSaveFounder(String founderId) {
    final founder = _founders.firstWhere((f) => f.id == founderId);
    final index = _founders.indexOf(founder);
    _founders[index] = founder.copyWith(isSaved: !founder.isSaved);
    
    if (founder.isSaved) {
      _savedFounders.removeWhere((f) => f.id == founderId);
    } else {
      _savedFounders.add(_founders[index]);
    }
    notifyListeners();
  }

  void sendConnectionRequest(String founderId) {
    final founder = _founders.firstWhere((f) => f.id == founderId);
    final index = _founders.indexOf(founder);
    
    if (!founder.isConnected && !founder.isConnectionPending) {
      _founders[index] = founder.copyWith(isConnectionPending: true);
      notifyListeners();
    }
  }

  void acceptConnectionRequest(String founderId) {
    final founder = _founders.firstWhere((f) => f.id == founderId);
    final index = _founders.indexOf(founder);
    
    _founders[index] = founder.copyWith(
      isConnected: true,
      isConnectionPending: false,
    );
    _connections.add(_founders[index]);
    notifyListeners();
  }

  void markNotificationAsRead(String notificationId) {
    final notification = _notifications.firstWhere((n) => n.id == notificationId);
    final index = _notifications.indexOf(notification);
    _notifications[index] = notification.copyWith(isRead: true);
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  Startup? getStartupById(String id) {
    try {
      return _startups.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  Founder? getFounderById(String id) {
    try {
      return _founders.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }
}