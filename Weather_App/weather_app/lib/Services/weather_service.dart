import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/Models/forecast_model.dart';
import 'package:weather_app/Models/weather_model.dart';
import '../config/env.dart';
class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  final String _baseUrl = Env.weatherApiBaseUrl;
  final String _apiKey = Env.weatherApiKey;

  Future<WeatherModel> getCurrentWeather(double lat, double lon, {String units = 'metric'}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&units=$units&appid=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Weather API error: ${e.toString()}');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCity(String cityName, {String units = 'metric'}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?q=$cityName&units=$units&appid=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Weather API error: ${e.toString()}');
    }
  }

  Future<List<ForecastModel>> getForecast(double lat, double lon, {String units = 'metric'}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast/daily?lat=$lat&lon=$lon&cnt=5&units=$units&appid=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['list'] as List;
        return list.map((json) => ForecastModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load forecast: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Forecast API error: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    try {
      final url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to search cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('City search error: ${e.toString()}');
    }
  }
}