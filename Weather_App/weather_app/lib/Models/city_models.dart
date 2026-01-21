class CityModel {
  final String? id;
  final String userId;
  final String cityName;
  final double lat;
  final double lon;
  final DateTime? createdAt;
  CityModel({
    this.id,
    required this.userId,
    required this.cityName,
    required this.lat,
    required this.lon,
    this.createdAt,
  });
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id']?.toString(),
      userId: json['user_id'] as String,
      cityName: json['city_name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'city_name': cityName,
      'lat': lat,
      'lon': lon,
      'created_at': createdAt?.toIso8601String(),
    };
  }
  CityModel copyWith({
    String? id,
    String? userId,
    String? cityName,
    double? lat,
    double? lon,
    DateTime? createdAt,
  }) {
    return CityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cityName: cityName ?? this.cityName,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}