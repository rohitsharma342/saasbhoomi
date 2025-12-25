import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/constants.dart';
import 'registration_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    }
  }

  void _skipLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipLogin,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    size: 80,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue building with the SaaS community',
                    style: TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    isRequired: true,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: _validatePassword,
                    isRequired: true,
                    prefixIcon: Icons.lock_outlined,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Forgot password feature coming soon!'),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppConstants.errorColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppConstants.errorColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Consumer<AuthService>(
                    builder: (context, authService, child) {
                      return CustomButton(
                        text: 'Sign In',
                        onPressed: authService.isLoading ? null : _login,
                        isLoading: authService.isLoading,
                        width: double.infinity,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Demo Credentials',
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Email: test@example.com',
                          style: TextStyle(
                            color: AppConstants.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'Password: password',
                          style: TextStyle(
                            color: AppConstants.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}