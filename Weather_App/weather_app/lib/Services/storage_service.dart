import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Temperature Unit
  Future<void> setTemperatureUnit(String unit) async {
    await _prefs?.setString('temperature_unit', unit);
  }

  String getTemperatureUnit() {
    return _prefs?.getString('temperature_unit') ?? 'celsius';
  }

  // Dark Mode
  Future<void> setDarkMode(bool isDark) async {
    await _prefs?.setBool('dark_mode', isDark);
  }

  bool getDarkMode() {
    return _prefs?.getBool('dark_mode') ?? false;
  }

  // Last Selected City
  Future<void> setLastCity(String cityName, double lat, double lon) async {
    await _prefs?.setString('last_city_name', cityName);
    await _prefs?.setDouble('last_city_lat', lat);
    await _prefs?.setDouble('last_city_lon', lon);
  }

  Map<String, dynamic>? getLastCity() {
    final name = _prefs?.getString('last_city_name');
    final lat = _prefs?.getDouble('last_city_lat');
    final lon = _prefs?.getDouble('last_city_lon');

    if (name != null && lat != null && lon != null) {
      return {'name': name, 'lat': lat, 'lon': lon};
    }
    return null;
  }
}