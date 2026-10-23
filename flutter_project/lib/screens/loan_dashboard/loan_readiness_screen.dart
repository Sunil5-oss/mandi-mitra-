import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LoanReadinessScreen extends StatelessWidget {
  const LoanReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank Readiness Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'किसान साख एवं बैंक ऋण तैयारी डैशबोर्ड',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                        ),
                        Text(
                          'लागत, उत्पादन व फसल विक्रय का आधिकारिक बैंक योग्य वित्तीय सारांश',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Credit Score / Readiness Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E7E34), Color(0xFF155724)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'कृषि साख स्वास्थ्य (Credit Readiness):',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
                        child: const Text('उच्च साख (High Readiness)', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('शुद्ध वार्षिक कृषि अधिशेष (Net Surplus):', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const Text('₹1,84,500', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _miniMetric('कुल कृषि लागत', '₹71,200'),
                      _miniMetric('कुल सकल आय', '₹2,55,700'),
                      _miniMetric('आय-लागत अनुपात', '3.59x'),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Season Wise Breakdown Table
            const Text('फसल सत्रवार रिकॉर्ड (Season-wise Cultivation Logs):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _seasonRow('रबी 2026', 'गेहूँ + सरसों (5 एकड़)', '₹23,700', '₹1,15,500', '+₹91,800'),
            _seasonRow('खरीफ 2025', 'सोयाबीन (5 एकड़)', '₹28,500', '₹1,21,200', '+₹92,700'),
            const SizedBox(height: 16),

            // Important Bank Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber.shade300)),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.brown, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'सावधानी: यह वित्तीय सारांश किसान द्वारा दर्ज प्रमाणित बहीखाता डेटा पर आधारित है। अंतिम ऋण स्वीकृति बैंक एवं संबंधित वित्तीय संस्थान के नियमों पर निर्भर करती है।',
                      style: TextStyle(fontSize: 11, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Print / Export Bank Statement Button
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('बैंक हेतु "किसान साख सारांश पत्र" PDF तैयार कर लिया गया है!')),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('बैंक ऋण सारांश पत्र (PDF) डाउनलोड करें'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniMetric(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _seasonRow(String season, String crops, String cost, String rev, String profit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(season, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
              Text(crops, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(profit, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.success)),
              Text('लागत: $cost | आय: $rev', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          )
        ],
      ),
    );
  }
}
