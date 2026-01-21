import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/Utils/constants.dart';
import 'glass_container.dart';


class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          if (message != null) ...[
            const SizedBox(height: AppConstants.paddingM),
            Text(
              message!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WeatherLoadingSkeleton extends StatelessWidget {
  const WeatherLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Column(
        children: [
          GlassContainer(
            height: 300,
            width: double.infinity,
            margin: const EdgeInsets.all(AppConstants.paddingM),
            child: Container(),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: List.generate(
              5,
              (index) => Expanded(
                child: GlassContainer(
                  height: 120,
                  margin: const EdgeInsets.all(AppConstants.paddingS),
                  child: Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}