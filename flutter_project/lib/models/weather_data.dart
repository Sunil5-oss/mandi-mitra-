class WeatherData {
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double precipitationProbability;
  final double windSpeed;
  final int weatherCode;
  final String conditionText;
  final String locationName;
  final String agroAdvisory;
  final List<DailyForecast> dailyForecasts;

  WeatherData({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.weatherCode,
    required this.conditionText,
    required this.locationName,
    required this.agroAdvisory,
    required this.dailyForecasts,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var forecastsList = (json['daily'] as List<dynamic>?)
        ?.map((item) => DailyForecast.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];

    return WeatherData(
      temperature: (json['temperature'] ?? 28.5).toDouble(),
      apparentTemperature: (json['apparentTemperature'] ?? 30.0).toDouble(),
      relativeHumidity: (json['relativeHumidity'] ?? 65).toInt(),
      precipitationProbability: (json['precipitationProbability'] ?? 15.0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 12.0).toDouble(),
      weatherCode: (json['weatherCode'] ?? 1).toInt(),
      conditionText: json['conditionText'] ?? 'Clear Sky (साफ़ मौसम)',
      locationName: json['locationName'] ?? 'Indore, Madhya Pradesh',
      agroAdvisory: json['agroAdvisory'] ?? 'मौसम कीटनाशक छिड़काव व सिंचाई के अनुकूल है।',
      dailyForecasts: forecastsList,
    );
  }
}

class DailyForecast {
  final String dayName;
  final String date;
  final double maxTemp;
  final double minTemp;
  final double rainChance;
  final String condition;

  DailyForecast({
    required this.dayName,
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.rainChance,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      dayName: json['dayName'] ?? 'Today',
      date: json['date'] ?? '',
      maxTemp: (json['maxTemp'] ?? 32.0).toDouble(),
      minTemp: (json['minTemp'] ?? 20.0).toDouble(),
      rainChance: (json['rainChance'] ?? 10.0).toDouble(),
      condition: json['condition'] ?? 'Sunny',
    );
  }
}
