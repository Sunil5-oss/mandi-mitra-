# Mandi Mitra AI 🌾 (मंडी मित्र एआई) — Competition & Hackathon Ready Edition
### Advanced Smart Agriculture Flutter & Dart Platform for Indian Farmers

Mandi Mitra AI is a production-grade, multi-platform Flutter application (Android, iOS, Web) designed to empower Indian farmers with real-time agronomic intelligence, AI-assisted diagnosis, fair market selling advisory, and financial readiness.

---

## 🌟 Upgraded Competition & Hackathon Features

1. **AI Crop Doctor (एआई फसल डॉक्टर)**
   - Upload or capture crop leaf photos.
   - Powered by Gemini 3.8 Flash Vision model via secure backend.
   - Returns disease name (Hindi + scientific), confidence level, severity, causal organism (Fungus/Insect/Bacteria).
   - Prescribes verified chemical treatments (with doses per acre & 15-L knapsack pump) and organic/traditional remedies.
   - Official KVK advisory disclaimer.
   - 1-Click "किसान ज्ञान पत्र बनाएं" button to generate a shareable knowledge card.

2. **Smart Mandi Selling Advisor (स्मार्ट मंडी विक्रय सलाहकार)**
   - Multi-mandi cross-comparison for the same crop.
   - Calculates distance, round-trip vehicle freight (₹/km), loading/unloading fees, and mandi cess.
   - Computes net in-hand earnings per quintal and total net profit.
   - Highlights the highest net profit market with a "सुझावित (Top Choice)" badge.
   - Never fabricates prices or guarantees future price surges.

3. **Innovative Feature: Farmer Knowledge Card (किसान ज्ञान पत्र)**
   - Converts any crop issue, diagnosis, or agricultural question into a high-visibility, shareable Hindi knowledge card.
   - Formatted in readable Devanagari typography with crop name, problem, remedy, dosage, precautions, and verified ICAR/KVK source.
   - 1-click WhatsApp and social sharing.

4. **Farm Profit & Loan Readiness Dashboard (किसान साख सारांश)**
   - Comprehensive cost of cultivation tracking: seed, fertilizer, labour, irrigation, machinery, freight, and other costs.
   - Computes gross revenue, net profit, profit per acre, and credit readiness ratio.
   - Multi-season records (Rabi 2026, Kharif 2025).
   - Generates an exportable/printable "किसान साख सारांश पत्र (Farmer Credit Summary)" for Kisan Credit Card (KCC) and bank loan applications.

5. **Weather-Based Farm Alerts (मौसम व कृषि अलर्ट)**
   - Live satellite observations and 7-day forecasts from the Open-Meteo API.
   - Severe weather alerts: wind speed spray warnings, rainfall irrigation postponement, and heat advisories.
   - Distinguishes live observations from forecasts.

6. **Personalized Crop Planner (व्यक्तिगत फसल योजनाकार)**
   - Crop activity milestones: Sowing, CRI stage irrigation, tillering, nitrogen top-dressing, heading, and harvesting.
   - Mark tasks complete, edit milestone dates, and receive reminders.

7. **Government Scheme Matcher (सरकारी योजना मैच)**
   - Interactive questionnaire (land size in acres, farmer category, irrigation source).
   - Matches eligible schemes: PM-KISAN, PMFBY, KCC, PM-KUSUM Solar Pump, and SMAM agricultural mechanization.
   - Official government portal links and requirements.

8. **AI Farming Copilot (एआई कृषि सह-पायलट)**
   - Hindi-first natural language assistant understanding Hindi, English, and Hinglish.
   - Speech-to-Text (voice mic) and Text-to-Speech (audio read-aloud).
   - Server-side API protection — never exposes Gemini API keys in the client.

9. **Low-Network & Offline Cache Support**
   - High-contrast touch targets for outdoor sunlight readability.
   - Offline cache indicator showing last-synced time.

10. **Hackathon Demonstration Mode (हैकाथॉन डेमो मोड)**
    - Guided 4-step farmer journey:
      - Step 1: Diagnose Yellow Rust with leaf photo.
      - Step 2: Compare Mandis & save ₹5,200 net transport freight.
      - Step 3: Reschedule spraying around satellite rain forecast.
      - Step 4: Generate bank credit readiness summary.
    - All sample demonstration records clearly labeled with `[SAMPLE DATA]`.

---

## 🧪 Automated Unit & Widget Tests

Automated tests are included in `test/agriculture_calculator_test.dart`:
- Net earnings calculation factoring round-trip transport freight and mandi tax.
- Optimal market selection logic based on net in-hand return.
- Cultivation cost, gross revenue, net profit, and profit per acre verification.

Run tests via:
```bash
flutter test
```

---

## 🚀 How to Run in Android Studio or VS Code

1. Download the ZIP from the app header or via `/api/download-flutter-zip`.
2. Extract the archive and open the `mandi_mitra_ai` directory.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Verify tests:
   ```bash
   flutter test
   ```
5. Run the application:
   ```bash
   flutter run -d android   # Run on Android device / emulator
   flutter run -d chrome    # Run in Chrome for Web
   ```
