import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather_app/GlobalWidgets/error_widget.dart';
import 'package:weather_app/GlobalWidgets/forecast_card.dart';
import 'package:weather_app/GlobalWidgets/glass_card.dart';
import 'package:weather_app/GlobalWidgets/glass_container.dart';
import 'package:weather_app/GlobalWidgets/loading_indicator.dart';
import 'package:weather_app/Utils/constants.dart';
import 'package:weather_app/Utils/extensions.dart';
import 'package:weather_app/View/search/city_search_screen.dart';
import 'package:weather_app/View/settings/settings_screen.dart';
import 'package:weather_app/ViewModel/city_viewmodel.dart';
import 'package:weather_app/ViewModel/settings_viewmodel.dart';
import 'package:weather_app/ViewModel/weather_viewmodel.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadInitialData();
  });
}


  Future<void> _loadInitialData() async {
    final cityViewModel = context.read<CityViewModel>();
    final weatherViewModel = context.read<WeatherViewModel>();
    final settingsViewModel = context.read<SettingsViewModel>();

    await cityViewModel.loadFavoriteCities();

    if (cityViewModel.favoriteCities.isNotEmpty) {
      final firstCity = cityViewModel.favoriteCities.first;
      await weatherViewModel.fetchWeather(
        firstCity.lat,
        firstCity.lon,
        settingsViewModel.weatherUnits,
      );
    }
  }

  Future<void> _refreshWeather() async {
    final cityViewModel = context.read<CityViewModel>();
    final weatherViewModel = context.read<WeatherViewModel>();
    final settingsViewModel = context.read<SettingsViewModel>();

    if (cityViewModel.favoriteCities.isNotEmpty) {
      final firstCity = cityViewModel.favoriteCities.first;
      await weatherViewModel.refreshWeather(
        firstCity.lat,
        firstCity.lon,
        settingsViewModel.weatherUnits,
      );
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
          child: Consumer3<WeatherViewModel, CityViewModel, SettingsViewModel>(
            builder: (context, weather, city, settings, _) {
              if (city.favoriteCities.isEmpty) {
                return _buildEmptyState();
              }

              if (weather.isLoading && weather.currentWeather == null) {
                return const WeatherLoadingSkeleton();
              }

              if (weather.error != null && weather.currentWeather == null) {
                return ErrorDisplay(
                  message: weather.error!,
                  onRetry: _loadInitialData,
                );
              }

              if (weather.currentWeather == null) {
                return const LoadingIndicator(message: 'Loading weather...');
              }

              return RefreshIndicator(
                onRefresh: _refreshWeather,
                color: Colors.white,
                backgroundColor: Colors.blue,
                child: _buildWeatherContent(weather, settings),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 80,
              color: Colors.white,
            ).animate().fadeIn().scale(),
            const SizedBox(height: AppConstants.paddingL),
            const Text(
              'No Cities Added',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              'Add a city to see the weather forecast',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CitySearchScreen(),
                  ),
                );
              },
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                  vertical: AppConstants.paddingM,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Add City',
                      style: TextStyle(
                        color: Colors.white,
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
      ),
    );
  }

  Widget _buildWeatherContent(WeatherViewModel weather, SettingsViewModel settings) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          floating: true,
          title: Text(
            weather.currentWeather!.cityName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CitySearchScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: AppConstants.paddingL),

              // Current Weather Card
              _buildCurrentWeatherCard(weather, settings).animate().fadeIn().slideY(),

              const SizedBox(height: AppConstants.paddingXL),

              // Forecast Section
              if (weather.forecast.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '5-Day Forecast',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),
                _buildForecastList(weather, settings).animate().fadeIn(delay: 200.ms),
              ],

              const SizedBox(height: AppConstants.paddingXL),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeatherCard(WeatherViewModel weather, SettingsViewModel settings) {
    final currentWeather = weather.currentWeather!;

    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        children: [
          // Weather Icon
          CachedNetworkImage(
            imageUrl: currentWeather.iconUrl,
            width: 120,
            height: 120,
            placeholder: (context, url) => const SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.wb_cloudy,
              color: Colors.white,
              size: 120,
            ),
          ),

          const SizedBox(height: AppConstants.paddingM),

          // Temperature
          Text(
            currentWeather.temperature.toTemperature(settings.temperatureUnit),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Condition
          Text(
            currentWeather.description.capitalizeWords,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: AppConstants.paddingL),

          // High/Low & Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(
                'High',
                currentWeather.tempMax.toTemperature(settings.temperatureUnit),
                Icons.arrow_upward,
              ),
              _buildWeatherDetail(
                'Low',
                currentWeather.tempMin.toTemperature(settings.temperatureUnit),
                Icons.arrow_downward,
              ),
              _buildWeatherDetail(
                'Humidity',
                '${currentWeather.humidity}%',
                Icons.water_drop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastList(WeatherViewModel weather, SettingsViewModel settings) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: weather.forecast.length,
        itemBuilder: (context, index) {
          return ForecastCard(
            forecast: weather.forecast[index],
            temperatureUnit: settings.temperatureUnit,
          );
        },
      ),
    );
  }
}