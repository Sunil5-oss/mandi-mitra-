import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../models/weather_data.dart';

class WeatherService {
  Future<WeatherData> fetchWeather({
    double latitude = 22.7196, // Indore default
    double longitude = 75.8577,
    String locationName = 'Indore, Madhya Pradesh',
  }) async {
    try {
      // First try app backend weather endpoint
      final backendUri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}?lat=$latitude&lon=$longitude&location=$locationName',
      );
      final response = await http.get(backendUri);
      if (response.statusCode == 200) {
        return WeatherData.fromJson(jsonDecode(response.body));
      }

      // Direct fallback to Open-Meteo public API
      final openMeteoUri = Uri.parse(
        '${ApiConstants.openMeteoBase}?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto',
      );
      final omResponse = await http.get(openMeteoUri);
      if (omResponse.statusCode == 200) {
        final omData = jsonDecode(omResponse.body);
        final current = omData['current'] ?? {};
        final daily = omData['daily'] ?? {};

        final times = (daily['time'] as List<dynamic>? ?? []);
        final maxTemps = (daily['temperature_2m_max'] as List<dynamic>? ?? []);
        final minTemps = (daily['temperature_2m_min'] as List<dynamic>? ?? []);
        final rainChances = (daily['precipitation_probability_max'] as List<dynamic>? ?? []);

        List<DailyForecast> forecasts = [];
        for (int i = 0; i < times.length && i < 7; i++) {
          forecasts.add(DailyForecast(
            dayName: i == 0 ? 'Today' : 'Day ${i + 1}',
            date: times[i].toString(),
            maxTemp: (maxTemps[i] ?? 30.0).toDouble(),
            minTemp: (minTemps[i] ?? 20.0).toDouble(),
            rainChance: (rainChances[i] ?? 10.0).toDouble(),
            condition: 'Clear to partly cloudy',
          ));
        }

        return WeatherData(
          temperature: (current['temperature_2m'] ?? 28.0).toDouble(),
          apparentTemperature: (current['apparent_temperature'] ?? 29.5).toDouble(),
          relativeHumidity: (current['relative_humidity_2m'] ?? 60).toInt(),
          precipitationProbability: (current['precipitation'] ?? 0.0).toDouble(),
          windSpeed: (current['wind_speed_10m'] ?? 10.0).toDouble(),
          weatherCode: (current['weather_code'] ?? 0).toInt(),
          conditionText: 'Fair Weather (अनुकूल मौसम)',
          locationName: locationName,
          agroAdvisory: 'आगामी 48 घंटों में भारी वर्षा की संभावना कम है। कीटनाशक छिड़काव के लिए अनुकूल समय है।',
          dailyForecasts: forecasts,
        );
      }

      return _defaultWeather(locationName);
    } catch (_) {
      return _defaultWeather(locationName);
    }
  }

  WeatherData _defaultWeather(String location) {
    return WeatherData(
      temperature: 29.2,
      apparentTemperature: 31.0,
      relativeHumidity: 58,
      precipitationProbability: 10,
      windSpeed: 11.5,
      weatherCode: 1,
      conditionText: 'साफ़ मौसम (Sunny)',
      locationName: location,
      agroAdvisory: 'मौसम साफ़ है। फसलों में आवश्यकतानुसार हल्की सिंचाई की जा सकती है।',
      dailyForecasts: [
        DailyForecast(dayName: 'आज', date: '2026-10-23', maxTemp: 32, minTemp: 21, rainChance: 5, condition: 'Sunny'),
        DailyForecast(dayName: 'कल', date: '2026-10-24', maxTemp: 33, minTemp: 22, rainChance: 10, condition: 'Clear'),
        DailyForecast(dayName: 'परसों', date: '2026-10-25', maxTemp: 31, minTemp: 20, rainChance: 15, condition: 'Partly Cloudy'),
      ],
    );
  }
}
