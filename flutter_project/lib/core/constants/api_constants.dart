class ApiConstants {
  // Backend base URL (can be customized via environment or server proxy)
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android Emulator alias
  static const String webBaseUrl = '/api'; // For Flutter Web / Browser

  // Backend Endpoints
  static const String chatEndpoint = '/chat';
  static const String mandiEndpoint = '/mandi';
  static const String weatherEndpoint = '/weather';
  static const String schemesEndpoint = '/schemes';
  static const String machineryEndpoint = '/machinery';
  static const String marketplaceEndpoint = '/marketplace';
  static const String communityEndpoint = '/community';
  static const String diaryEndpoint = '/diary';
  static const String soilEndpoint = '/soil';

  // Open-Meteo Public Fallback Endpoint
  static const String openMeteoBase = 'https://api.open-meteo.com/v1/forecast';
}
