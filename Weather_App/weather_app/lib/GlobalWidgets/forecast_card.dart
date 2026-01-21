import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Models/forecast_model.dart';
import 'package:weather_app/Utils/constants.dart';
import 'package:weather_app/Utils/extensions.dart';
import 'glass_card.dart';


class ForecastCard extends StatelessWidget {
  final ForecastModel forecast;
  final String temperatureUnit;

  const ForecastCard({
    super.key,
    required this.forecast,
    required this.temperatureUnit,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 100,
      padding: const EdgeInsets.all(AppConstants.paddingS),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            forecast.date.dayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CachedNetworkImage(
            imageUrl: forecast.iconUrl,
            width: 40,
            height: 40,
            placeholder: (context, url) => const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.wb_cloudy,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            forecast.tempMax.toTemperature(temperatureUnit),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            forecast.tempMin.toTemperature(temperatureUnit),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}