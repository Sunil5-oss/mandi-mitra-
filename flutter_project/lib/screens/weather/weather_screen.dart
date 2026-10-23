import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/weather_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';
    final weather = state.weatherData;

    return Scaffold(
      body: weather == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => state.fetchWeatherData(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherCard(
                      data: weather,
                      onRefresh: () => state.fetchWeatherData(),
                    ),
                    const SizedBox(height: 20),

                    // Agro Advisory Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.eco, color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isHindi ? 'कृषि सलाह (Agro Advisory)' : 'Agricultural Weather Advisory',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _advisoryItem(
                            Icons.check_circle_outline,
                            AppColors.success,
                            isHindi ? 'छिड़काव अनुकूलता' : 'Spraying Advisory',
                            isHindi
                                ? 'हवा की गति 12 किमी/घंटा से कम है और वर्षा की संभावना कम है। कीटनाशक व फफूंदनाशक छिड़काव हेतु उत्तम समय है।'
                                : 'Wind speed is below 12 km/h and rain chance is low. Good conditions for pesticide and fungicide sprays.',
                          ),
                          const SizedBox(height: 10),
                          _advisoryItem(
                            Icons.water_drop_outlined,
                            AppColors.info,
                            isHindi ? 'सिंचाई सलाह' : 'Irrigation Advisory',
                            isHindi
                                ? 'आगामी 3 दिन धूप खिली रहेगी। संवेदनशील अवस्था में खड़ी फसलों (जैसे गेहूँ, चना) में हल्की सिंचाई करें।'
                                : 'Clear skies expected for next 3 days. Light irrigation recommended for sensitive crop stages.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 7-Day Forecast
                    Text(
                      isHindi ? '7 दिनों का पूर्वानुमान' : '7-Day Forecast',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: weather.dailyForecasts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final df = weather.dailyForecasts[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  df.dayName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                              ),
                              const Icon(Icons.wb_sunny, color: AppColors.accent, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'बारिश ${df.rainChance.toInt()}%',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ),
                              Text(
                                '${df.maxTemp.toInt()}° / ${df.minTemp.toInt()}°C',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _advisoryItem(IconData icon, Color color, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}
