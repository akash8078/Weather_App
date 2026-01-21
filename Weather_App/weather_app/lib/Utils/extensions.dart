import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('EEEE, MMM d').format(this);
  String get formattedTime => DateFormat('h:mm a').format(this);
  String get dayName => DateFormat('EEE').format(this);
  String get shortDate => DateFormat('MMM d').format(this);
}

extension DoubleExtension on double {
  String toTemperature(String unit) {
    if (unit == 'fahrenheit') {
      final converted = (this * 9 / 5) + 32;
      return '${converted.toStringAsFixed(0)}°F';
    }
    return '${toStringAsFixed(0)}°C';
  }
}


extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
}