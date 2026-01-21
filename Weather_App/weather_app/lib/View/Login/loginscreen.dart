import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/GlobalWidgets/glass_button.dart';
import 'package:weather_app/GlobalWidgets/glass_textfield.dart';
import 'package:weather_app/GlobalWidgets/global_snackbar.dart';
import 'package:weather_app/Utils/constants.dart';
import 'package:weather_app/View/Login/signup_screen.dart';
import 'package:weather_app/ViewModel/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = context.read<AuthViewModel>();
      final success = await authViewModel.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (!success && authViewModel.error != null) {
          GlobalSnackbar.show(
            context,
            message: authViewModel.error!,
            icon: Icons.error_outline,
            backgroundColor: Colors.red,
          );
        } else if (success) {
          GlobalSnackbar.show(
            context,
            message: 'Welcome back!',
            icon: Icons.check_circle,
            backgroundColor: Colors.green,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppConstants.darkBackgroundGradient
              : AppConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.1),
                  
                  // App Logo/Title
                  const Icon(
                    Icons.cloud,
                    size: 80,
                    color: Colors.white,
                  ).animate().fadeIn().scale(),
                  
                  const SizedBox(height: AppConstants.paddingM),
                  
                  const Text(
                    'Glasscast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  
                  const SizedBox(height: AppConstants.paddingS),
                  
                  Text(
                    'Your minimal weather companion',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  
                  const SizedBox(height: AppConstants.paddingXL * 2),
                  
                  // Email Field
                  GlassTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 300.ms).slideX(),
                  
                  const SizedBox(height: AppConstants.paddingM),
                  
                  // Password Field
                  GlassTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleLogin(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 400.ms).slideX(),
                  
                  const SizedBox(height: AppConstants.paddingXL),
                  
                  // Login Button
                  Consumer<AuthViewModel>(
                    builder: (context, auth, _) {
                      return GlassButton(
                        text: 'Sign In',
                        onPressed: _handleLogin,
                        isLoading: auth.isLoading,
                        width: double.infinity,
                      );
                    },
                  ).animate().fadeIn(delay: 500.ms).slideY(),
                  
                  const SizedBox(height: AppConstants.paddingL),
                  
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}