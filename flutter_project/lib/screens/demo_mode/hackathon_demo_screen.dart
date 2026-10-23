import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HackathonDemoScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HackathonDemoScreen({super.key, required this.onNavigate});

  @override
  State<HackathonDemoScreen> createState() => _HackathonDemoScreenState();
}

class _HackathonDemoScreenState extends State<HackathonDemoScreen> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _demoSteps = [
    {
      'step': 1,
      'title': 'चरण 1: एआई फसल डॉक्टर (AI Crop Doctor)',
      'subtitle': 'पत्ती की फोटो से रोग पहचान व सटीक दवा मात्रा',
      'scenario': '[SAMPLE DATA] किसान रामेश्वर जी ने गेहूँ की पत्ती पर पीला चूर्ण देखा। एआई मॉडल ने 94% सटीकता से "पीला रतुआ (Yellow Rust)" पहचाना और प्रोपिकोनाजोल 25% EC (200 ml/एकड़) का वैज्ञानिक उपचार बताया।',
      'actionLabel': 'फसल डॉक्टर खोलें',
      'targetNavIndex': 14, // Crop Doctor index
    },
    {
      'step': 2,
      'title': 'चरण 2: स्मार्ट मंडी विक्रय सलाहकार (Mandi Selling Advisor)',
      'subtitle': 'दूरी, डीजल खर्च व मंडी टैक्स घटाकर सर्वोत्तम मंडी का चयन',
      'scenario': '[SAMPLE DATA] स्थानीय देवास मंडी ₹2620 दे रही है जबकि 38 किमी दूर इंदौर मंडी ₹2750 दे रही है। भाड़ा घटाने के बाद भी इंदौर मंडी में ₹5,200 अधिक शुद्ध मुनाफा मिला।',
      'actionLabel': 'मंडी सलाहकार देखें',
      'targetNavIndex': 15, // Mandi Advisor index
    },
    {
      'step': 3,
      'title': 'चरण 3: मौसम आधारित कृषि अलर्ट (Agro Weather)',
      'subtitle': 'वर्षा व तेज हवा की चेतावनी के अनुसार स्प्रे व सिंचाई का पुनर्निर्धारण',
      'scenario': '[SAMPLE DATA] ओपन-मेटियो सैटेलाइट पूर्वानुमान के अनुसार 48 घंटे तक मौसम साफ़ है (बारिश संभावना 2%)। किसान ने बिना दवा बहे सुरक्षित कीटनाशक स्प्रे पूरा किया।',
      'actionLabel': 'मौसम अलर्ट देखें',
      'targetNavIndex': 2, // Weather tab
    },
    {
      'step': 4,
      'title': 'चरण 4: किसान साख व शुद्ध लाभ बहीखाता (Bank Readiness)',
      'subtitle': 'लागत घटाकर ₹91,800 शुद्ध मुनाफा व बैंक हेतु साख पत्र',
      'scenario': '[SAMPLE DATA] रबी 2026 में कुल ₹23,700 खर्च के मुकाबले ₹1,15,500 की उपज बिकी। बैंक ऋण व किसान क्रेडिट कार्ड (KCC) हेतु आधिकारिक साख सारांश तुरंत प्राप्त हुआ।',
      'actionLabel': 'बैंक साख सारांश देखें',
      'targetNavIndex': 17, // Loan readiness index
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sample Warning Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade400),
              ),
              child: const Row(
                children: [
                  Icon(Icons.flag, color: Colors.brown, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'हैकाथॉन प्रदर्शन मोड: इस स्क्रीन में प्रस्तुत सभी आंकड़े और परिदृश्य प्रात्यक्षिक नमूने [SAMPLE DEMO DATA] हैं।',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stepper
            Stepper(
              physics: const NeverScrollableScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              onStepContinue: () {
                if (_currentStep < _demoSteps.length - 1) {
                  setState(() => _currentStep++);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                }
              },
              steps: _demoSteps.map((ds) {
                final isCurrent = _currentStep == (ds['step'] as int) - 1;
                return Step(
                  isActive: _currentStep >= (ds['step'] as int) - 1,
                  state: _currentStep > (ds['step'] as int) - 1 ? StepState.complete : StepState.indexed,
                  title: Text(ds['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(ds['subtitle'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  content: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ds['scenario'] as String,
                          style: const TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => widget.onNavigate(ds['targetNavIndex'] as int),
                          icon: const Icon(Icons.arrow_forward, size: 14),
                          label: Text(ds['actionLabel'] as String),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
