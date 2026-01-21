import 'package:flutter/material.dart';
import 'package:weather_app/Utils/constants.dart';


class WeatherIcon extends StatelessWidget {
  final String condition;
  final double size;
  final Color? color;

  const WeatherIcon({
    super.key,
    required this.condition,
    this.size = 100,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final icon = AppConstants.weatherIcons[condition] ?? Icons.wb_cloudy;

    return Icon(
      icon,
      size: size,
      color: color ?? Colors.white,
    );
  }
}