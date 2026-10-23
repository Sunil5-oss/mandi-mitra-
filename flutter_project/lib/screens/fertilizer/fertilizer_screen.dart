import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/constants/app_colors.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  String _selectedCrop = 'Wheat (गेहूँ)';
  final TextEditingController _areaController = TextEditingController(text: '2.0');
  String _selectedUnit = 'Acre';
  String _cropStage = 'बुवाई के समय (Basal Application)';

  // Calculation results
  double _ureaBags = 0.0;
  double _dapBags = 0.0;
  double _mopBags = 0.0;
  double _totalN = 0.0;
  double _totalP = 0.0;
  double _totalK = 0.0;
  bool _calculated = false;

  final Map<String, Map<String, double>> _cropNutrientReqPerAcre = {
    'Wheat (गेहूँ)': {'N': 48.0, 'P': 24.0, 'K': 16.0},
    'Paddy (धान)': {'N': 40.0, 'P': 20.0, 'K': 20.0},
    'Mustard (सरसों)': {'N': 32.0, 'P': 16.0, 'K': 16.0},
    'Soybean (सोयाबीन)': {'N': 12.0, 'P': 32.0, 'K': 16.0},
    'Cotton (कपास)': {'N': 48.0, 'P': 24.0, 'K': 24.0},
    'Potato (आलू)': {'N': 60.0, 'P': 40.0, 'K': 48.0},
    'Maize (मक्का)': {'N': 48.0, 'P': 24.0, 'K': 20.0},
  };

  void _calculateFertilizer() {
    final areaVal = double.tryParse(_areaController.text) ?? 1.0;
    // Standardize area into Acres
    double acres = areaVal;
    if (_selectedUnit == 'Bigha') {
      acres = areaVal * 0.4; // 1 Bigha ≈ 0.4 Acre standard
    } else if (_selectedUnit == 'Hectare') {
      acres = areaVal * 2.471;
    }

    final req = _cropNutrientReqPerAcre[_selectedCrop] ?? {'N': 40.0, 'P': 20.0, 'K': 20.0};
    _totalN = req['N']! * acres;
    _totalP = req['P']! * acres;
    _totalK = req['K']! * acres;

    // DAP contains 18% N and 46% P2O5 (50kg bag = 23kg P, 9kg N)
    final dapBagsExact = _totalP / 23.0;
    final nFromDap = dapBagsExact * 9.0;
    final remainingN = (_totalN - nFromDap).clamp(0.0, double.infinity);

    // Urea contains 46% N (45kg bag = 20.7kg N)
    final ureaBagsExact = remainingN / 20.7;

    // MOP contains 60% K2O (50kg bag = 30kg K)
    final mopBagsExact = _totalK / 30.0;

    setState(() {
      _dapBags = (dapBagsExact * 10).round() / 10;
      _ureaBags = (ureaBagsExact * 10).round() / 10;
      _mopBags = (mopBagsExact * 10).round() / 10;
      _calculated = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateFertilizer();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
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
                    child: const Icon(Icons.calculate, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'वैज्ञानिक खाद कैलकुलेटर' : 'Scientific Fertilizer Dosage Calculator',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                        ),
                        Text(
                          isHindi ? 'पारदर्शी फॉर्मूला व सटीक NPK अनुपात' : 'Transparent formula & exact NPK ratios',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Crop selector
            Text(isHindi ? 'फसल चुनें' : 'Select Crop', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              items: _cropNutrientReqPerAcre.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCrop = val);
                  _calculateFertilizer();
                }
              },
            ),
            const SizedBox(height: 14),

            // Area and Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isHindi ? 'खेत का क्षेत्रफल' : 'Farm Area', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _areaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'उदा. 2.5'),
                        onChanged: (_) => _calculateFertilizer(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isHindi ? 'इकाई' : 'Unit', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        items: ['Acre', 'Bigha', 'Hectare'].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedUnit = val);
                            _calculateFertilizer();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Growth Stage
            Text(isHindi ? 'फसल की अवस्था' : 'Growth Stage', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _cropStage,
              items: [
                'बुवाई के समय (Basal Application)',
                'प्रथम सिंचाई / कल्ले फूटने पर (Tillering)',
                'फूल आने पर (Flowering)',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _cropStage = val);
              },
            ),
            const SizedBox(height: 20),

            // Results Card
            if (_calculated) ...[
              Text(
                isHindi ? 'अनुशंसित खाद की मात्रा (बोरी में)' : 'Recommended Fertilizer Requirement',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _fertilizerBadge('यूरिया (Urea 46% N)', '$_ureaBags बोरी', '(45 कि.ग्रा./बोरी)', Colors.blue),
                  const SizedBox(width: 10),
                  _fertilizerBadge('डी.ए.पी. (DAP 18:46)', '$_dapBags बोरी', '(50 कि.ग्रा./बोरी)', Colors.green),
                  const SizedBox(width: 10),
                  _fertilizerBadge('पोटाश (MOP 60% K)', '$_mopBags बोरी', '(50 कि.ग्रा./बोरी)', Colors.orange),
                ],
              ),
              const SizedBox(height: 16),

              // Scientific Assumptions Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'वैज्ञानिक आधार एवं गणना विधि:' : 'Scientific Basis & Calculation:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isHindi
                          ? '• कुल पोषक तत्व आवश्यकता: नाइट्रोजन ${_totalN.toStringAsFixed(1)} kg, फॉस्फोरस ${_totalP.toStringAsFixed(1)} kg, पोटाश ${_totalK.toStringAsFixed(1)} kg।\n• संपूर्ण DAP व MOP तथा यूरिया की आधी मात्रा बुवाई के समय बेसल डोज के रूप में डालें।\n• शेष यूरिया को 2 बराबर भागों में पहली व दूसरी सिंचाई के बाद टॉप ड्रेसिंग करें।'
                          : '• Total Nutrient Requirement: N: ${_totalN.toStringAsFixed(1)} kg, P: ${_totalP.toStringAsFixed(1)} kg, K: ${_totalK.toStringAsFixed(1)} kg.\n• Apply all DAP, MOP and half Nitrogen as basal dose.\n• Top dress the remaining Nitrogen in 2 split doses after first and second irrigation.',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _fertilizerBadge(String name, String bags, String bagSize, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color), maxLines: 1),
            const SizedBox(height: 8),
            Text(bags, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(bagSize, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
