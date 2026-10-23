import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/mandi_comparison.dart';

class MandiAdvisorScreen extends StatefulWidget {
  const MandiAdvisorScreen({super.key});

  @override
  State<MandiAdvisorScreen> createState() => _MandiAdvisorScreenState();
}

class _MandiAdvisorScreenState extends State<MandiAdvisorScreen> {
  final TextEditingController _qtyController = TextEditingController(text: '60');
  final TextEditingController _freightRateController = TextEditingController(text: '12'); // ₹ per km
  String _selectedCrop = 'गेहूँ (Wheat)';

  List<MandiComparisonItem> _comparisons = [];

  void _calculateComparisons() {
    final qty = double.tryParse(_qtyController.text) ?? 50.0;
    final freight = double.tryParse(_freightRateController.text) ?? 12.0;

    // Benchmark realistic mandi markets around central MP/Punjab
    final marketsData = [
      {'name': 'देवास स्थानीय मंडी', 'state': 'मध्य प्रदेश', 'dist': 'Dewas', 'km': 12.0, 'rate': 2620.0},
      {'name': 'इंदौर लक्ष्मीबाई नगर मंडी', 'state': 'मध्य प्रदेश', 'dist': 'Indore', 'km': 38.0, 'rate': 2750.0},
      {'name': 'उज्जैन चिमनगंज मंडी', 'state': 'मध्य प्रदेश', 'dist': 'Ujjain', 'km': 45.0, 'rate': 2730.0},
      {'name': 'सीहोर शरबती मंडी', 'state': 'मध्य प्रदेश', 'dist': 'Sehore', 'km': 95.0, 'rate': 2920.0},
    ];

    final list = marketsData.map((m) {
      return MandiComparisonItem.calculate(
        marketName: m['name'] as String,
        state: m['state'] as String,
        district: m['dist'] as String,
        distanceKm: m['km'] as double,
        pricePerQuintal: m['rate'] as double,
        totalQuantityQuintals: qty,
        dieselRatePerKm: freight,
      );
    }).toList();

    // Sort descending by total net profit
    list.sort((a, b) => b.totalNetProfit.compareTo(a.totalNetProfit));

    setState(() {
      _comparisons = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateComparisons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
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
                    child: const Icon(Icons.compare_arrows, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'स्मार्ट मंडी विक्रय सलाहकार (Smart Selling Advisor)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                        ),
                        Text(
                          'दूरी, भाड़ा व मंडी शुल्क घटाकर शुद्ध मुनाफे की तुलना करें',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Inputs
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCrop,
                    decoration: const InputDecoration(labelText: 'फसल (Crop)'),
                    items: ['गेहूँ (Wheat)', 'सोयाबीन (Soybean)', 'चना (Gram)', 'सरसों (Mustard)'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedCrop = val);
                        _calculateComparisons();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'मात्रा (क्विंटल)'),
                    onChanged: (_) => _calculateComparisons(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _freightRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'भाड़ा (₹/किमी)'),
                    onChanged: (_) => _calculateComparisons(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Recommendation Callout
            if (_comparisons.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E7E34), Color(0xFF155724)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                      child: const Icon(Icons.star, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'सर्वश्रेष्ठ शुद्ध लाभ मंडी विकल्प:',
                            style: TextStyle(color: AppColors.accentLight, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _comparisons.first.marketName,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'परिवहन खर्च काटकर शुद्ध बचत: ₹${_comparisons.first.totalNetProfit.toInt()} (₹${_comparisons.first.netEarningsPerQuintal}/क्विंटल)',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Comparison List
            Text(
              'मंडियों की तुलना (उच्चतम शुद्ध आय से न्यूनतम):',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comparisons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _comparisons[index];
                final isBest = index == 0;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isBest ? AppColors.primary : AppColors.border, width: isBest ? 1.8 : 1),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}. ${item.marketName}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isBest ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isBest)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(6)),
                              child: const Text('सुझावित (Top Choice)', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('दूरी: ${item.distanceKm.toInt()} किमी • स्रोत: ${item.dataSource}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('मंडी भाव', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                Text('₹${item.pricePerQuintal.toInt()}/क्विंटल', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('भाड़ा + मंडी खर्च', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                Text('-₹${(item.transportCostPerQuintal + item.mandiFeePerQuintal).toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.danger)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('हाथ में शुद्ध भाव', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                Text('₹${item.netEarningsPerQuintal.toInt()}/क्विंटल', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
