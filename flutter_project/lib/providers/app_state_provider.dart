import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../models/mandi_record.dart';
import '../models/weather_data.dart';
import '../models/soil_record.dart';
import '../models/crop_calendar_event.dart';
import '../models/farm_diary_entry.dart';
import '../core/services/mandi_service.dart';
import '../core/services/weather_service.dart';
import '../core/services/gemini_service.dart';

class AppStateProvider extends ChangeNotifier {
  final MandiService _mandiService = MandiService();
  final WeatherService _weatherService = WeatherService();
  final GeminiService _geminiService = GeminiService();

  // Language state: 'hi' (Hindi default) or 'en'
  String _currentLanguage = 'hi';
  String get currentLanguage => _currentLanguage;

  UserProfile _userProfile = UserProfile.defaultProfile();
  UserProfile get userProfile => _userProfile;

  // Mandi State
  List<MandiRecord> _mandiRecords = [];
  List<MandiRecord> get mandiRecords => _mandiRecords;
  bool _isLoadingMandi = false;
  bool get isLoadingMandi => _isLoadingMandi;
  String _selectedState = 'Madhya Pradesh';
  String get selectedState => _selectedState;
  String _selectedCommodity = 'All';
  String get selectedCommodity => _selectedCommodity;

  // Weather State
  WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;
  bool _isLoadingWeather = false;
  bool get isLoadingWeather => _isLoadingWeather;

  // AI Assistant Chat Messages
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'role': 'assistant',
      'text': 'नमस्ते किसान भाई! मैं आपका मंडी मित्र एआई सहायक हूँ। अपनी फसल में रोग, सही खाद की मात्रा, या मंडी भाव के बारे में पूछें। आप माइक दबाकर बोल भी सकते हैं। 🙏',
      'time': 'अब'
    }
  ];
  List<Map<String, dynamic>> get chatMessages => _chatMessages;
  bool _isAiResponding = false;
  bool get isAiResponding => _isAiResponding;

  // Crop Calendar
  final List<CropCalendarEvent> _calendarEvents = [
    CropCalendarEvent(
      id: 'cal_1',
      cropName: 'गेहूँ (Wheat)',
      activityType: 'प्रथम सिंचाई (CRI Stage)',
      dueDate: DateTime.now().add(const Duration(days: 4)),
      isCompleted: false,
      notes: 'बुवाई के 21 दिन बाद ताज मूल अवस्था पर सिंचाई अति आवश्यक है।',
    ),
    CropCalendarEvent(
      id: 'cal_2',
      cropName: 'गेहूँ (Wheat)',
      activityType: 'यूरिया की प्रथम टॉप ड्रेसिंग',
      dueDate: DateTime.now().add(const Duration(days: 6)),
      isCompleted: false,
      notes: 'सिंचाई के तुरंत बाद 45 कि.ग्रा. यूरिया प्रति एकड़ दें।',
    ),
  ];
  List<CropCalendarEvent> get calendarEvents => _calendarEvents;

  // Soil Records
  final List<SoilRecord> _soilRecords = [];
  List<SoilRecord> get soilRecords => _soilRecords;

  // Farm Diary
  final List<FarmDiaryEntry> _diaryEntries = [];
  List<FarmDiaryEntry> get diaryEntries => _diaryEntries;

  AppStateProvider() {
    initData();
  }

  Future<void> initData() async {
    await fetchMandiData();
    await fetchWeatherData();
  }

  void setLanguage(String langCode) {
    if (_currentLanguage != langCode) {
      _currentLanguage = langCode;
      notifyListeners();
    }
  }

  void updateProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  Future<void> fetchMandiData({String? state, String? commodity}) async {
    _isLoadingMandi = true;
    notifyListeners();
    if (state != null) _selectedState = state;
    if (commodity != null) _selectedCommodity = commodity;

    _mandiRecords = await _mandiService.fetchMandiPrices(
      state: _selectedState,
      commodity: _selectedCommodity == 'All' ? null : _selectedCommodity,
    );
    _isLoadingMandi = false;
    notifyListeners();
  }

  Future<void> fetchWeatherData() async {
    _isLoadingWeather = true;
    notifyListeners();
    _weatherData = await _weatherService.fetchWeather();
    _isLoadingWeather = false;
    notifyListeners();
  }

  Future<void> sendChatMessage(String prompt, {String? base64Image}) async {
    _chatMessages.add({
      'role': 'user',
      'text': prompt,
      'image': base64Image,
      'time': 'अब'
    });
    _isAiResponding = true;
    notifyListeners();

    final response = await _geminiService.askAssistant(
      prompt: prompt,
      language: _currentLanguage,
      base64Image: base64Image,
    );

    _chatMessages.add({
      'role': 'assistant',
      'text': response,
      'time': 'अब'
    });
    _isAiResponding = false;
    notifyListeners();
  }

  void addCalendarEvent(CropCalendarEvent event) {
    _calendarEvents.add(event);
    notifyListeners();
  }

  void toggleCalendarEvent(String id) {
    final idx = _calendarEvents.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _calendarEvents[idx].isCompleted = !_calendarEvents[idx].isCompleted;
      notifyListeners();
    }
  }

  void addDiaryEntry(FarmDiaryEntry entry) {
    _diaryEntries.insert(0, entry);
    notifyListeners();
  }

  void addSoilRecord(SoilRecord record) {
    _soilRecords.insert(0, record);
    notifyListeners();
  }
}
