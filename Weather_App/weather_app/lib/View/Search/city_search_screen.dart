import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/GlobalWidgets/glass_card.dart';
import 'package:weather_app/GlobalWidgets/glass_textfield.dart';
import 'package:weather_app/Models/city_models.dart';
import 'package:weather_app/Utils/constants.dart';
import 'package:weather_app/ViewModel/city_viewmodel.dart';
import 'package:weather_app/ViewModel/login_viewmodel.dart';
import 'package:weather_app/ViewModel/settings_viewmodel.dart';
import 'package:weather_app/ViewModel/weather_viewmodel.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear search results when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CityViewModel>().clearSearchResults();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Clear search results when leaving the screen
    context.read<CityViewModel>().clearSearchResults();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      context.read<CityViewModel>().searchCities(query);
    } else {
      context.read<CityViewModel>().clearSearchResults();
    }
  }

  Future<void> _addCity(Map<String, dynamic> cityData) async {
    final authViewModel = context.read<AuthViewModel>();
    final cityViewModel = context.read<CityViewModel>();
    final weatherViewModel = context.read<WeatherViewModel>();
    final settingsViewModel = context.read<SettingsViewModel>();

    final city = CityModel(
      userId: authViewModel.currentUser!.id,
      cityName: cityData['name'],
      lat: cityData['lat'],
      lon: cityData['lon'],
    );

    final success = await cityViewModel.addFavoriteCity(city);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${city.cityName} added to favorites'),
            backgroundColor: Colors.green,
          ),
        );

        // Load weather for the newly added city
        await weatherViewModel.fetchWeather(
          city.lat,
          city.lon,
          settingsViewModel.weatherUnits,
        );

        // Clear search after adding
        _searchController.clear();
        cityViewModel.clearSearchResults();

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(cityViewModel.error ?? 'Failed to add city'),
            backgroundColor: Colors.red,
          ),
        );
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
                      'Search Cities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),

              // Search Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                child: GlassTextField(
                  controller: _searchController,
                  hintText: 'Search for a city...',
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  onChanged: _handleSearch,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                            context.read<CityViewModel>().clearSearchResults();
                          },
                        )
                      : null,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(),

              const SizedBox(height: AppConstants.paddingL),

              // Search Results
              Expanded(
                child: Consumer<CityViewModel>(
                  builder: (context, cityViewModel, _) {
                    if (cityViewModel.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }

                    if (cityViewModel.searchResults.isEmpty && _searchController.text.isEmpty) {
                      return _buildFavoriteCitiesList(cityViewModel);
                    }

                    if (cityViewModel.searchResults.isEmpty) {
                      return Center(
                        child: Text(
                          'No cities found',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                      itemCount: cityViewModel.searchResults.length,
                      itemBuilder: (context, index) {
                        final city = cityViewModel.searchResults[index];
                        return GlassCard(
                          margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
                          onTap: () => _addCity(city),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.white),
                              const SizedBox(width: AppConstants.paddingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      city['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (city['state'] != null)
                                      Text(
                                        '${city['state']}, ${city['country']}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      )
                                    else
                                      Text(
                                        city['country'],
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.add, color: Colors.white),
                            ],
                          ),
                        ).animate().fadeIn(delay: (50 * index).ms).slideX();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCitiesList(CityViewModel cityViewModel) {
    if (cityViewModel.favoriteCities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_outlined,
                size: 80,
                color: Colors.white54,
              ),
              const SizedBox(height: AppConstants.paddingL),
              Text(
                'Search for cities to add to your favorites',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
          child: const Text(
            'Favorite Cities',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
            itemCount: cityViewModel.favoriteCities.length,
            itemBuilder: (context, index) {
              final city = cityViewModel.favoriteCities[index];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
                child: Row(
                  children: [
                    const Icon(Icons.location_city, color: Colors.white),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: Text(
                        city.cityName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove City'),
                            content: Text('Remove ${city.cityName} from favorites?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Remove'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && city.id != null) {
                          await cityViewModel.removeFavoriteCity(city.id!);
                        }
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (50 * index).ms).slideX();
            },
          ),
        ),
      ],
    );
  }
}