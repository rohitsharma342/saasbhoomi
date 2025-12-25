import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        _currentUser = User(
          id: 'user_1',
          name: 'John Doe',
          email: 'john@example.com',
          bio: 'Passionate SaaS entrepreneur building the future',
          profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          skills: ['Flutter', 'AI', 'SaaS'],
          interests: ['Startups', 'Technology', 'Innovation'],
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        );
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (email == 'test@example.com' && password == 'password') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', 'dummy_token');
        
        _currentUser = User(
          id: 'user_1',
          name: 'John Doe',
          email: email,
          bio: 'Passionate SaaS entrepreneur building the future',
          profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          skills: ['Flutter', 'AI', 'SaaS'],
          interests: ['Startups', 'Technology', 'Innovation'],
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        );
        _isAuthenticated = true;
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'dummy_token');
      
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        bio: 'New member of SaasBhoomi community',
        skills: [],
        interests: [],
        createdAt: DateTime.now(),
      );
      _isAuthenticated = true;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}