import 'package:flutter/material.dart';
import 'package:weather_app/Models/city_models.dart';
import 'package:weather_app/Services/weather_service.dart';
import 'package:weather_app/services/supabase_service.dart';

class CityViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final WeatherService _weatherService = WeatherService();

  List<CityModel> _favoriteCities = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  List<CityModel> get favoriteCities => _favoriteCities;
  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFavoriteCities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favoriteCities = await _supabaseService.getFavoriteCities();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addFavoriteCity(CityModel city) async {
    try {
      final addedCity = await _supabaseService.addFavoriteCity(city);
      _favoriteCities.insert(0, addedCity);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavoriteCity(String cityId) async {
    try {
      await _supabaseService.removeFavoriteCity(cityId);
      _favoriteCities.removeWhere((city) => city.id == cityId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _weatherService.searchCities(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Add this method to clear all data on sign out
  void clearAllData() {
    _favoriteCities = [];
    _searchResults = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}