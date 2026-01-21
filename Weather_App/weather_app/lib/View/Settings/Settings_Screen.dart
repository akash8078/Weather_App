import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/GlobalWidgets/glass_button.dart';
import 'package:weather_app/GlobalWidgets/glass_card.dart';
import 'package:weather_app/GlobalWidgets/glass_container.dart';
import 'package:weather_app/GlobalWidgets/global_snackbar.dart';
import 'package:weather_app/Utils/constants.dart';
import 'package:weather_app/ViewModel/login_viewmodel.dart';
import 'package:weather_app/ViewModel/settings_viewmodel.dart';
import 'package:weather_app/ViewModel/city_viewmodel.dart';
import 'package:weather_app/ViewModel/weather_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppConstants.paddingS),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: AppConstants.paddingL),

              // Settings Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Section
                      Consumer<AuthViewModel>(
                        builder: (context, auth, _) {
                          return GlassCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: AppConstants.paddingM),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Signed in as',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        auth.currentUser?.email ?? 'User',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn().slideX();
                        },
                      ),

                      const SizedBox(height: AppConstants.paddingXL),

                      // Preferences Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingS),
                        child: Text(
                          'Preferences',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingM),

                      // Temperature Unit Toggle
                      Consumer<SettingsViewModel>(
                        builder: (context, settings, _) {
                          return GlassCard(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.thermostat,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: AppConstants.paddingM),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Temperature Unit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Choose Celsius or Fahrenheit',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GlassContainer(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildUnitButton(
                                        context,
                                        '°C',
                                        settings.temperatureUnit == 'celsius',
                                        () => settings.setTemperatureUnit('celsius'),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildUnitButton(
                                        context,
                                        '°F',
                                        settings.temperatureUnit == 'fahrenheit',
                                        () => settings.setTemperatureUnit('fahrenheit'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 100.ms).slideX();
                        },
                      ),

                      const SizedBox(height: AppConstants.paddingM),

                      // Dark Mode Toggle
                      Consumer<SettingsViewModel>(
                        builder: (context, settings, _) {
                          return GlassCard(
                            child: Row(
                              children: [
                                Icon(
                                  settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: AppConstants.paddingM),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dark Mode',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Switch between light and dark theme',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: settings.isDarkMode,
                                  onChanged: (_) => settings.toggleDarkMode(),
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.blue,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 200.ms).slideX();
                        },
                      ),

                      const SizedBox(height: AppConstants.paddingXL),

                      // About Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingS),
                        child: Text(
                          'About',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingM),

                      GlassCard(
                        child: Column(
                          children: [
                            _buildInfoRow('App Name', AppConstants.appName),
                            const Divider(color: Colors.white24),
                            _buildInfoRow('Version', AppConstants.appVersion),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideX(),

                      const SizedBox(height: AppConstants.paddingXL),

                      // Sign Out Button
                      Consumer<AuthViewModel>(
                        builder: (context, auth, _) {
                          return GlassButton(
                            text: 'Sign Out',
                            icon: Icons.logout,
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Sign Out'),
                                  content: const Text('Are you sure you want to sign out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Sign Out'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm != true || !context.mounted) return;

                              // Clear all ViewModels data BEFORE signing out
                              final cityViewModel = context.read<CityViewModel>();
                              final weatherViewModel = context.read<WeatherViewModel>();
                              
                              cityViewModel.clearAllData();
                              weatherViewModel.clearAllData();

                              // Now sign out
                              final success = await auth.signOut();

                              if (!context.mounted) return;

                              if (success) {
                                GlobalSnackbar.show(
                                  context,
                                  message: 'Signed out successfully',
                                  icon: Icons.logout,
                                  backgroundColor: Colors.green,
                                );
                                
                                // Pop all routes - AuthWrapper will handle navigation to LoginScreen
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              } else if (auth.error != null) {
                                GlobalSnackbar.show(
                                  context,
                                  message: auth.error!,
                                  icon: Icons.error_outline,
                                  backgroundColor: Colors.redAccent,
                                );
                              }
                            },
                            isLoading: auth.isLoading,
                            width: double.infinity,
                            textColor: Colors.red,
                          ).animate().fadeIn(delay: 400.ms).slideY();
                        },
                      ),

                      const SizedBox(height: AppConstants.paddingXL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusS),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}