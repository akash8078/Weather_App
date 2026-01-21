import 'package:flutter/material.dart';
import 'package:weather_app/Models/forecast_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Services/weather_service.dart';


class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  bool _isLoading = false;
  String? _error;

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  void clearAllData() {
  _currentWeather = null;
  _forecast = [];
  _error = null;
  _isLoading = false;
  notifyListeners();
}

  Future<void> fetchWeather(double lat, double lon, String units) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeather(lat, lon, units: units);
      _forecast = await _weatherService.getForecast(lat, lon, units: units);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCity(String cityName, String units) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName, units: units);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWeather(double lat, double lon, String units) async {
    await fetchWeather(lat, lon, units);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}