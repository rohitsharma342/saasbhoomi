import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../services/auth_service.dart';
import '../widgets/startup_card.dart';
import '../widgets/founder_card.dart';
import '../utils/constants.dart';
import 'startup_detail_screen.dart';
import 'founder_profile_screen.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataService>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: const Text(
          'Logout',
          style: TextStyle(color: AppConstants.textPrimaryColor),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppConstants.textSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<AuthService>(context, listen: false).logout();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppConstants.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('SaaSBoomi'),
        backgroundColor: AppConstants.surfaceColor,
        elevation: 1,
        actions: [
          Consumer<DataService>(
            builder: (context, dataService, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  if (dataService.unreadNotificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppConstants.errorColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${dataService.unreadNotificationCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppConstants.errorColor),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(color: AppConstants.textPrimaryColor),
                    ),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppConstants.textPrimaryColor),
                  decoration: InputDecoration(
                    hintText: 'Search startups, founders...',
                    hintStyle: const TextStyle(
                      color: AppConstants.textSecondaryColor,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppConstants.textSecondaryColor,
                    ),
                    filled: true,
                    fillColor: AppConstants.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    Provider.of<DataService>(context, listen: false)
                        .setSearchQuery(value);
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: AppConstants.primaryColor,
                labelColor: AppConstants.primaryColor,
                unselectedLabelColor: AppConstants.textSecondaryColor,
                tabs: const [
                  Tab(text: 'Discover'),
                  Tab(text: 'Connections'),
                  Tab(text: 'Saved'),
                  Tab(text: 'My Profile'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverTab(),
          _buildConnectionsTab(),
          _buildSavedTab(),
          _buildProfileTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create startup feature coming soon!'),
            ),
          );
        },
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final startups = dataService.getFilteredStartups();
        final founders = dataService.getFilteredFounders();

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: AppConstants.primaryColor,
                labelColor: AppConstants.primaryColor,
                unselectedLabelColor: AppConstants.textSecondaryColor,
                tabs: [
                  Tab(text: 'Startups'),
                  Tab(text: 'Founders'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildStartupsList(startups, dataService),
                    _buildFoundersList(founders, dataService),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStartupsList(startups, dataService) {
    if (startups.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'No startups found',
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: startups.length,
      itemBuilder: (context, index) {
        final startup = startups[index];
        return StartupCard(
          startup: startup,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartupDetailScreen(startup: startup),
              ),
            );
          },
          onSave: () {
            dataService.toggleSaveStartup(startup.id);
          },
        );
      },
    );
  }

  Widget _buildFoundersList(founders, dataService) {
    if (founders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'No founders found',
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: founders.length,
      itemBuilder: (context, index) {
        final founder = founders[index];
        return FounderCard(
          founder: founder,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FounderProfileScreen(founder: founder),
              ),
            );
          },
          onConnect: () {
            dataService.sendConnectionRequest(founder.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connection request sent!'),
              ),
            );
          },
          onSave: () {
            dataService.toggleSaveFounder(founder.id);
          },
        );
      },
    );
  }

  Widget _buildConnectionsTab() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final connections = dataService.connections;

        if (connections.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: AppConstants.textSecondaryColor,
                ),
                SizedBox(height: 16),
                Text(
                  'No connections yet',
                  style: TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Start connecting with founders to build your network',
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
          itemCount: connections.length,
          itemBuilder: (context, index) {
            final founder = connections[index];
            return FounderCard(
              founder: founder,
              showConnectButton: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FounderProfileScreen(founder: founder),
                  ),
                );
              },
              onSave: () {
                dataService.toggleSaveFounder(founder.id);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSavedTab() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: AppConstants.primaryColor,
                labelColor: AppConstants.primaryColor,
                unselectedLabelColor: AppConstants.textSecondaryColor,
                tabs: [
                  Tab(text: 'Startups'),
                  Tab(text: 'Founders'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSavedStartups(dataService),
                    _buildSavedFounders(dataService),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSavedStartups(DataService dataService) {
    if (dataService.savedStartups.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'No saved startups',
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dataService.savedStartups.length,
      itemBuilder: (context, index) {
        final startup = dataService.savedStartups[index];
        return StartupCard(
          startup: startup,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartupDetailScreen(startup: startup),
              ),
            );
          },
          onSave: () {
            dataService.toggleSaveStartup(startup.id);
          },
        );
      },
    );
  }

  Widget _buildSavedFounders(DataService dataService) {
    if (dataService.savedFounders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'No saved founders',
              style: TextStyle(
                color: AppConstants.textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dataService.savedFounders.length,
      itemBuilder: (context, index) {
        final founder = dataService.savedFounders[index];
        return FounderCard(
          founder: founder,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FounderProfileScreen(founder: founder),
              ),
            );
          },
          onSave: () {
            dataService.toggleSaveFounder(founder.id);
          },
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;
        if (user == null) return const SizedBox();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppConstants.surfaceColor,
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : null,
                child: user.profileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: AppConstants.textSecondaryColor,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: const TextStyle(
                  color: AppConstants.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
              if (user.bio != null) ...<Widget>[
                const SizedBox(height: 16),
                Text(
                  user.bio!,
                  style: const TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (user.skills.isNotEmpty) ...<Widget>[
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Skills',
                    style: TextStyle(
                      color: AppConstants.textPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.skills.map((skill) {
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
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Member Since',
                        style: TextStyle(
                          color: AppConstants.textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                        style: const TextStyle(
                          color: AppConstants.textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}