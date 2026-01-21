class ForecastModel {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String icon;

  ForecastModel({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final temp = json['temp'] as Map<String, dynamic>;
    final weather = (json['weather'] as List).first as Map<String, dynamic>;

    return ForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      tempMin: (temp['min'] as num).toDouble(),
      tempMax: (temp['max'] as num).toDouble(),
      condition: weather['main'] as String,
      icon: weather['icon'] as String,
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/${icon}@2x.png';
}