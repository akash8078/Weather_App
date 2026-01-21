import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/GlobalWidgets/glass_button.dart';
import 'package:weather_app/GlobalWidgets/glass_textfield.dart';
import 'package:weather_app/GlobalWidgets/global_snackbar.dart';
import 'package:weather_app/Utils/constants.dart';
import 'package:weather_app/ViewModel/login_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = context.read<AuthViewModel>();
      
      // Sign up the user
      final success = await authViewModel.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Show success message
        GlobalSnackbar.show(
          context,
          message: 'Account created successfully!',
          icon: Icons.check_circle,
          backgroundColor: Colors.green,
        );

        // Wait a moment for the message to show
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        // Automatically sign in after successful signup
        final signInSuccess = await authViewModel.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (!mounted) return;

        if (signInSuccess) {
          // Pop back - AuthWrapper will handle navigation to HomeScreen
          Navigator.of(context).pop();
        } else {
          // Sign in failed after signup - show error
          GlobalSnackbar.show(
            context,
            message: authViewModel.error ?? 'Please sign in manually',
            icon: Icons.info_outline,
            backgroundColor: Colors.orange,
          );
          // Still pop back to login screen
          Navigator.of(context).pop();
        }
      } else {
        // Check if user already exists
        if (authViewModel.error == 'USER_EXISTS') {
          // Show message and navigate to login
          GlobalSnackbar.show(
            context,
            message: 'Account already exists with this email. Please sign in.',
            icon: Icons.info_outline,
            backgroundColor: Colors.orange,
          );
          
          // Wait a moment then navigate to login
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.of(context).pop(); // Go back to login
          }
        } else {
          // Show other errors
          GlobalSnackbar.show(
            context,
            message: authViewModel.error ?? 'Sign up failed',
            icon: Icons.error_outline,
            backgroundColor: Colors.red,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  const SizedBox(height: AppConstants.paddingXL),
                  
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingL),
                  
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().scale(),
                  
                  const SizedBox(height: AppConstants.paddingS),
                  
                  Text(
                    'Sign up to get started',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  
                  const SizedBox(height: AppConstants.paddingXL),
                  
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
                  ).animate().fadeIn(delay: 200.ms).slideX(),
                  
                  const SizedBox(height: AppConstants.paddingM),
                  
                  // Password Field
                  GlassTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    textInputAction: TextInputAction.next,
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
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 300.ms).slideX(),
                  
                  const SizedBox(height: AppConstants.paddingM),
                  
                  // Confirm Password Field
                  GlassTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSignUp(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 400.ms).slideX(),
                  
                  const SizedBox(height: AppConstants.paddingXL),
                  
                  // Sign Up Button
                  Consumer<AuthViewModel>(
                    builder: (context, auth, _) {
                      return GlassButton(
                        text: 'Sign Up',
                        onPressed: _handleSignUp,
                        isLoading: auth.isLoading,
                        width: double.infinity,
                      );
                    },
                  ).animate().fadeIn(delay: 500.ms).slideY(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}