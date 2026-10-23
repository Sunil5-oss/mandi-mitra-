import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'widgets/custom_app_bar.dart';
import 'screens/home/home_screen.dart';
import 'screens/mandi/mandi_screen.dart';
import 'screens/weather/weather_screen.dart';
import 'screens/ai_assistant/ai_assistant_screen.dart';
import 'screens/fertilizer/fertilizer_screen.dart';
import 'screens/soil_health/soil_health_screen.dart';
import 'screens/crop_calendar/crop_calendar_screen.dart';
import 'screens/profit_calculator/profit_calculator_screen.dart';
import 'screens/government_schemes/government_schemes_screen.dart';
import 'screens/machinery/machinery_screen.dart';
import 'screens/marketplace/marketplace_screen.dart';
import 'screens/community/community_screen.dart';
import 'screens/farm_diary/farm_diary_screen.dart';
import 'screens/profile/profile_screen.dart';

class MandiMitraApp extends StatelessWidget {
  const MandiMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandi Mitra AI 🌾',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onSelectTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final lang = state.currentLanguage;
    final isHindi = lang == 'hi';

    final screens = [
      HomeScreen(onNavigate: _onSelectTab),
      const MandiScreen(),
      const WeatherScreen(),
      const AiAssistantScreen(),
      const ProfileScreen(),
      const FertilizerScreen(),
      const SoilHealthScreen(),
      const CropCalendarScreen(),
      const ProfitCalculatorScreen(),
      const GovernmentSchemesScreen(),
      const MachineryScreen(),
      const MarketplaceScreen(),
      const CommunityScreen(),
      const FarmDiaryScreen(),
    ];

    final titles = [
      AppStrings.get('appName', lang),
      AppStrings.get('mandi', lang),
      AppStrings.get('weather', lang),
      AppStrings.get('aiAssistant', lang),
      AppStrings.get('profile', lang),
      isHindi ? 'खाद कैलकुलेटर' : 'Fertilizer Calculator',
      isHindi ? 'मृदा स्वास्थ्य (Soil Health)' : 'Soil Health',
      isHindi ? 'फसल कैलेंडर (Crop Calendar)' : 'Crop Calendar',
      isHindi ? 'मुनाफा कैलकुलेटर (Profit)' : 'Profit Calculator',
      isHindi ? 'सरकारी योजनाएं (Govt Schemes)' : 'Government Schemes',
      isHindi ? 'कृषि यंत्र किराया (Rental)' : 'Machinery Rental',
      isHindi ? 'फसल बाज़ार (Marketplace)' : 'Crop Marketplace',
      isHindi ? 'किसान चौपाल (Community)' : 'Kisan Community',
      isHindi ? 'कृषि दैनिकी (Farm Diary)' : 'Farm Diary',
    ];

    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: CustomAppBar(
        title: titles[_currentIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.agriculture, color: Colors.white, size: 38),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.get('appName', lang),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.userProfile.name,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            _drawerItem(Icons.home, AppStrings.get('home', lang), 0),
            _drawerItem(Icons.currency_rupee, AppStrings.get('mandi', lang), 1),
            _drawerItem(Icons.wb_sunny_outlined, AppStrings.get('weather', lang), 2),
            _drawerItem(Icons.auto_awesome, AppStrings.get('aiAssistant', lang), 3),
            const Divider(),
            _drawerItem(Icons.biotech, isHindi ? 'खाद कैलकुलेटर' : 'Fertilizer Calc', 5),
            _drawerItem(Icons.landscape, isHindi ? 'मृदा स्वास्थ्य' : 'Soil Health', 6),
            _drawerItem(Icons.calendar_month, isHindi ? 'फसल कैलेंडर' : 'Crop Calendar', 7),
            _drawerItem(Icons.calculate, isHindi ? 'मुनाफा कैलकुलेटर' : 'Profit Calculator', 8),
            _drawerItem(Icons.account_balance, isHindi ? 'सरकारी योजनाएं' : 'Govt Schemes', 9),
            _drawerItem(Icons.agriculture, isHindi ? 'यंत्र किराया' : 'Machinery Rental', 10),
            _drawerItem(Icons.storefront, isHindi ? 'फसल बाज़ार' : 'Crop Marketplace', 11),
            _drawerItem(Icons.groups, isHindi ? 'किसान चौपाल' : 'Community', 12),
            _drawerItem(Icons.menu_book, isHindi ? 'कृषि दैनिकी' : 'Farm Diary', 13),
            _drawerItem(Icons.person, AppStrings.get('profile', lang), 4),
          ],
        ),
      ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _currentIndex > 4 ? 0 : _currentIndex,
              onDestinationSelected: _onSelectTab,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: Text(AppStrings.get('home', lang))),
                NavigationRailDestination(icon: const Icon(Icons.currency_rupee), selectedIcon: const Icon(Icons.currency_rupee), label: Text(AppStrings.get('mandi', lang))),
                NavigationRailDestination(icon: const Icon(Icons.wb_sunny_outlined), selectedIcon: const Icon(Icons.wb_sunny), label: Text(AppStrings.get('weather', lang))),
                NavigationRailDestination(icon: const Icon(Icons.auto_awesome_outlined), selectedIcon: const Icon(Icons.auto_awesome), label: Text(AppStrings.get('aiAssistant', lang))),
                NavigationRailDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: Text(AppStrings.get('profile', lang))),
              ],
            ),
          Expanded(child: screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
              onTap: _onSelectTab,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppStrings.get('home', lang)),
                BottomNavigationBarItem(icon: const Icon(Icons.currency_rupee), label: AppStrings.get('mandi', lang)),
                BottomNavigationBarItem(icon: const Icon(Icons.wb_sunny_outlined), label: AppStrings.get('weather', lang)),
                BottomNavigationBarItem(icon: const Icon(Icons.auto_awesome), label: AppStrings.get('aiAssistant', lang)),
                BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: AppStrings.get('profile', lang)),
              ],
            ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    final isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        setState(() => _currentIndex = index);
      },
    );
  }
}
