import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/mandi_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final lang = state.currentLanguage;
    final isHindi = lang == 'hi';

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await state.fetchMandiData();
          await state.fetchWeatherData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 22,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.get('welcomeFarmer', lang),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            '${state.userProfile.name} • ${state.userProfile.district}, ${state.userProfile.state}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: AppColors.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Weather Card
              if (state.weatherData != null)
                WeatherCard(
                  data: state.weatherData!,
                  onRefresh: () => state.fetchWeatherData(),
                )
              else
                const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),

              // AI Ask Bar Shortcut
              InkWell(
                onTap: () => onNavigate(3), // Navigate to AI Assistant tab
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1AEAA023),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.accentLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi ? 'एआई मित्र से कुछ भी पूछें' : 'Ask AI Farming Assistant',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            Text(
                              isHindi ? 'फसल रोग, खाद व मौसम सलाह...' : 'Crop disease, fertilizer dosage...',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic, color: AppColors.primary, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Feature Grid
              Text(
                isHindi ? 'प्रमुख सुविधाएं' : 'Core Features',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
                children: [
                  _quickAction(Icons.currency_rupee, isHindi ? 'मंडी भाव' : 'Mandi', AppColors.primary, () => onNavigate(1)),
                  _quickAction(Icons.wb_sunny_outlined, isHindi ? 'मौसम' : 'Weather', Colors.orange, () => onNavigate(2)),
                  _quickAction(Icons.biotech, isHindi ? 'खाद कैलकुलेटर' : 'Fertilizer', Colors.teal, () => onNavigate(5)),
                  _quickAction(Icons.landscape, isHindi ? 'मृदा स्वास्थ्य' : 'Soil Health', Colors.brown, () => onNavigate(6)),
                  _quickAction(Icons.calendar_month, isHindi ? 'कैलेंडर' : 'Calendar', Colors.indigo, () => onNavigate(7)),
                  _quickAction(Icons.calculate, isHindi ? 'मुनाफा' : 'Profit', Colors.green, () => onNavigate(8)),
                  _quickAction(Icons.account_balance, isHindi ? 'योजनाएं' : 'Schemes', Colors.blueGrey, () => onNavigate(9)),
                  _quickAction(Icons.agriculture, isHindi ? 'किराया' : 'Rental', Colors.deepOrange, () => onNavigate(10)),
                ],
              ),
              const SizedBox(height: 24),

              // Today's Mandi Highlights
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.get('todayMandiRates', lang),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () => onNavigate(1),
                    child: Text(
                      AppStrings.get('viewAll', lang),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (state.isLoadingMandi)
                const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
              else if (state.mandiRecords.isEmpty)
                const Text('मंडी डेटा उपलब्ध नहीं है।', style: TextStyle(color: AppColors.textMuted))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.mandiRecords.take(3).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return MandiCard(record: state.mandiRecords[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
