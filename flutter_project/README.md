# Mandi Mitra AI 🌾 (मंडी मित्र एआई)
### Complete Smart Agriculture Flutter Application for Indian Farmers

Mandi Mitra AI is a production-grade, multi-platform Flutter application (Android, iOS, Web) designed specifically to empower Indian farmers with real-time agricultural intelligence.

---

## 🌟 Key Features

1. **Bilingual by Design**: Native **Hindi (हिन्दी - Default)** and **English** localization with full dynamic language switching.
2. **Live Mandi Prices (लाइव मंडी भाव)**: Live market rates across states, districts, and commodities (Wheat, Paddy, Cotton, Mustard, Soybean, Tomato, Onion, etc.) with minimum, maximum, and modal price indicators.
3. **Agro-Weather Forecast (मौसम व कृषि सलाह)**: 7-day accurate Open-Meteo weather forecasts with rainfall probability, wind, humidity, and real-time farming advisories (spraying suitability, irrigation alerts).
4. **Gemini AI Farming Assistant & Plant Doctor (एआई कृषि मित्र)**: Secure backend-proxied Gemini 3.8 Flash model delivering agronomy advice, fertilizer scheduling, organic solutions, and crop disease diagnosis from photos.
5. **Hindi Voice Assistant (आवाज़ से पूछें)**: Integrated Speech-to-Text and Text-to-Speech allowing farmers to speak their queries in Hindi or English and listen to spoken answers.
6. **Soil Health Module (मृदा स्वास्थ्य)**: Soil type identification, pH, NPK analysis, organic carbon tracking, and certified improvement recommendations.
7. **Transparent Fertilizer Calculator (खाद कैलकुलेटर)**: Transparent mathematical formulas for Urea, DAP, and MOP requirements based on crop and land size (Bigha, Acre, Hectare).
8. **Crop Calendar & Farm Tasks (फसल कैलेंडर)**: Sowing to harvest milestone tracking with irrigation and fertilizer alerts.
9. **Farm Profit Calculator (मुनाफा कैलकुलेटर)**: Cost of cultivation analysis (seeds, fertilizer, labor, irrigation, diesel) vs. market yield revenue.
10. **Government Schemes (सरकारी योजनाएं)**: Verified info on PM-KISAN, PMFBY, KCC, Solar Pump Kusuma with eligibility and official links.
11. **Machinery Rental (कृषि यंत्र किराया)**: Tractor, rotavator, drone, and harvester rental directory with booking requests.
12. **Crop Marketplace (फसल बाज़ार)**: Farmer-to-buyer direct crop listings.
13. **Kisan Community (किसान चौपाल)**: Peer-to-peer discussion forum for farmers.
14. **Farm Diary / Bahi-Khata (कृषि दैनिकी)**: Offline-first farm journal for activities, expenses, and harvests.

---

## 🚀 How to Run in Android Studio or VS Code

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.16.0 or later)
- [Dart SDK](https://dart.dev/get-dart) (v3.2.0 or later)
- Android Studio with Android SDK 33+ or VS Code with Flutter extension
- An Android device or emulator with Developer Mode enabled

### Setup Steps

1. **Unzip the Project**:
   ```bash
   unzip mandi_mitra_ai_flutter.zip
   cd mandi_mitra_ai
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Environment / Backend API**:
   - The app communicates with your Mandi Mitra backend service.
   - Open `lib/core/constants/api_constants.dart` and set `baseUrl` to your deployed backend URL (or `http://10.0.2.2:3000` for Android Emulator local testing).

4. **Run the App**:
   ```bash
   # Run on connected Android device/emulator
   flutter run -d android

   # Run in Chrome for Web
   flutter run -d chrome
   ```

5. **Building Release APK**:
   ```bash
   flutter build apk --release
   ```
   The generated APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📁 Clean Flutter Architecture

```
lib/
├── main.dart                       # App entry point with Provider scope
├── app.dart                        # MaterialApp configuration & theme setup
├── core/
│   ├── constants/                  # API URLs, color schemes, Hindi/English dictionary
│   ├── theme/                      # Agriculture green & golden theme
│   └── services/                   # HTTP client, Gemini backend, Weather, Mandi, Storage
├── models/                         # MandiRecord, WeatherData, CropEvent, SoilRecord, etc.
├── providers/                      # AppStateProvider (language, state), MandiProvider, AuthProvider
├── screens/
│   ├── home/                       # Farmer dashboard
│   ├── mandi/                      # Searchable mandi prices
│   ├── weather/                    # Open-Meteo agro weather
│   ├── ai_assistant/               # Gemini AI chat & crop disease camera
│   ├── soil_health/                # Soil health card & NPK tests
│   ├── fertilizer/                 # Fertilizer calculation engine
│   ├── crop_calendar/              # Farm calendar & tasks
│   ├── profit_calculator/          # Profit & loss calculator
│   ├── government_schemes/         # Verified government schemes
│   ├── machinery/                  # Tractor & tool rental
│   ├── marketplace/                # Farmer marketplace
│   ├── community/                  # Kisan community forum
│   ├── farm_diary/                 # Farm ledger & diary
│   ├── profile/                    # Farmer profile & farm info
│   └── auth/                       # Login & registration
└── widgets/                        # Custom app bars, stats, cards, voice mic button
```
