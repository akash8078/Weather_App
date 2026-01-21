import 'package:flutter/material.dart';
import 'package:weather_app/Services/storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _isDarkMode = false;
  String _temperatureUnit = 'celsius'; // 'celsius' or 'fahrenheit'

  bool get isDarkMode => _isDarkMode;
  String get temperatureUnit => _temperatureUnit;
  String get temperatureSymbol => _temperatureUnit == 'celsius' ? '°C' : '°F';
  String get weatherUnits => _temperatureUnit == 'celsius' ? 'metric' : 'imperial';

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _storageService.init();
    _isDarkMode = _storageService.getDarkMode();
    _temperatureUnit = _storageService.getTemperatureUnit();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setTemperatureUnit(String unit) async {
    _temperatureUnit = unit;
    await _storageService.setTemperatureUnit(unit);
    notifyListeners();
  }

  Future<void> toggleTemperatureUnit() async {
    _temperatureUnit = _temperatureUnit == 'celsius' ? 'fahrenheit' : 'celsius';
    await _storageService.setTemperatureUnit(_temperatureUnit);
    notifyListeners();
  }
}