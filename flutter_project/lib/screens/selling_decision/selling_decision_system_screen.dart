import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/selling_decision_model.dart';

class SellingDecisionSystemScreen extends StatefulWidget {
  const SellingDecisionSystemScreen({super.key});

  @override
  State<SellingDecisionSystemScreen> createState() => _SellingDecisionSystemScreenState();
}

class _SellingDecisionSystemScreenState extends State<SellingDecisionSystemScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Global inputs
  String _cropName = 'गेहूँ (Wheat)';
  double _quantity = 60.0;
  final TextEditingController _quantityCtrl = TextEditingController(text: '60');

  // Baseline Selling Options
  List<SellingOptionInput> _baselineOptions = [
    SellingOptionInput(
      id: 'opt_1',
      name: 'इंदौर लक्ष्मीबाई नगर मंडी',
      pricePerQuintal: 2750.0,
      transportCost: 3600.0,
      loadingUnloadingCost: 600.0,
      labourCost: 400.0,
      packagingCost: 300.0,
      commissionCost: 1200.0,
      otherCost: 200.0,
    ),
    SellingOptionInput(
      id: 'opt_2',
      name: 'स्थानीय व्यापारी / एफपीओ केंद्र (Farmgate)',
      pricePerQuintal: 2680.0,
      transportCost: 600.0,
      loadingUnloadingCost: 300.0,
      labourCost: 200.0,
      packagingCost: 0.0,
      commissionCost: 0.0,
      otherCost: 100.0,
    ),
  ];

  // What-If Simulation State
  double _simTransportPercentChange = 0.0;
  double _simTransportAbsoluteChange = 0.0;
  double _simBuyerPriceDelta = 0.0;
  int _simSelectedOptionIndex = 0;

  // Waiting Scenario State
  double _futurePrice = 2950.0;
  double _storageCost = 3500.0;
  double _handlingCost = 800.0;

  // Saved Comparisons
  final List<Map<String, dynamic>> _savedComparisons = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  void _resetSimulation() {
    setState(() {
      _simTransportPercentChange = 0.0;
      _simTransportAbsoluteChange = 0.0;
      _simBuyerPriceDelta = 0.0;
    });
  }

  void _addNewOption() {
    setState(() {
      final newId = 'opt_${_baselineOptions.length + 1}';
      _baselineOptions.add(
        SellingOptionInput(
          id: newId,
          name: 'नया विक्रय केंद्र / मंडी ${_baselineOptions.length + 1}',
          pricePerQuintal: 2700.0,
          transportCost: 2000.0,
          loadingUnloadingCost: 400.0,
        ),
      );
    });
  }

  void _removeOption(int index) {
    if (_baselineOptions.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('तुलना के लिए कम से कम दो विकल्प आवश्यक हैं।')),
      );
      return;
    }
    setState(() {
      _baselineOptions.removeAt(index);
    });
  }

  void _saveCurrentComparison() {
    final recommendation = SellingDecisionEngine.generateRecommendation(
      _quantity,
      _baselineOptions,
      cropName: _cropName,
    );
    setState(() {
      _savedComparisons.insert(0, {
        'id': 'save_${DateTime.now().millisecondsSinceEpoch}',
        'crop': _cropName,
        'quantity': _quantity,
        'date': DateTime.now().toString().substring(0, 16),
        'bestMandi': recommendation.recommendedOption.option.name,
        'netProfit': recommendation.recommendedOption.estimatedNetReturn,
        'optionsCount': _baselineOptions.length,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('विक्रय तुलना रिकॉर्ड सुरक्षित कर लिया गया!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Current baseline recommendation
    final baselineRecommendation = SellingDecisionEngine.generateRecommendation(
      _quantity,
      _baselineOptions,
      cropName: _cropName,
    );

    // Simulated options
    final simulatedOptions = _baselineOptions.asMap().entries.map((entry) {
      final idx = entry.key;
      final opt = entry.value;
      if (idx == _simSelectedOptionIndex) {
        double newTransport = opt.transportCost;
        if (_simTransportPercentChange != 0) {
          newTransport += opt.transportCost * (_simTransportPercentChange / 100);
        }
        newTransport += _simTransportAbsoluteChange;
        if (newTransport < 0) newTransport = 0;

        double newPrice = opt.pricePerQuintal + _simBuyerPriceDelta;
        if (newPrice < 0) newPrice = 0;

        return opt.copyWith(
          transportCost: newTransport,
          pricePerQuintal: newPrice,
        );
      }
      return opt;
    }).toList();

    // Simulated recommendation
    final simulatedRecommendation = SellingDecisionEngine.generateRecommendation(
      _quantity,
      simulatedOptions,
      cropName: _cropName,
    );

    // Waiting scenario result
    final waitingResult = SellingDecisionEngine.simulateWaitingScenario(
      currentNetReturn: baselineRecommendation.recommendedOption.estimatedNetReturn,
      quantity: _quantity,
      futurePricePerQuintal: _futurePrice,
      currentTotalExpenses: baselineRecommendation.recommendedOption.totalExpenses,
      additionalStorageCost: _storageCost,
      additionalHandlingCost: _handlingCost,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(icon: Icon(Icons.compare_arrows, size: 16), text: 'शुद्ध आय तुलना (Net Return)'),
              Tab(icon: Icon(Icons.tune, size: 16), text: 'व्हाट-इफ़ सिम्युलेटर (What-If)'),
              Tab(icon: Icon(Icons.recommend, size: 16), text: 'पारदर्शी अनुशंसा (Explainable Rec)'),
              Tab(icon: Icon(Icons.bookmark_border, size: 16), text: 'सहेजे गए रिकॉर्ड (History)'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: NET RETURN COMPARISON
          _buildComparisonTab(baselineRecommendation),

          // TAB 2: WHAT-IF SIMULATOR
          _buildSimulatorTab(baselineRecommendation, simulatedRecommendation, waitingResult),

          // TAB 3: EXPLAINABLE RECOMMENDATION
          _buildRecommendationTab(baselineRecommendation, simulatedRecommendation),

          // TAB 4: SAVED COMPARISONS & HISTORY
          _buildSavedComparisonsTab(),
        ],
      ),
    );
  }

  // --- TAB 1: NET RETURN COMPARISON WORKFLOW ---
  Widget _buildComparisonTab(SellingRecommendation rec) {
    return SingleChildScrollView(
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
                  child: const Icon(Icons.account_balance, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'वास्तविक शुद्ध आय तुलना (Net Return Comparison)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      Text(
                        'सकल बिक्री मूल्य में से भाड़ा, पल्लेदारी व मंडी टैक्स घटाकर शुद्ध आय जानें',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Global crop and quantity inputs
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: _cropName,
                  decoration: const InputDecoration(labelText: 'फसल का नाम (Crop Name)'),
                  items: ['गेहूँ (Wheat)', 'सोयाबीन (Soybean)', 'चना (Gram)', 'सरसों (Mustard)', 'कपास (Cotton)', 'मक्का (Maize)']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _cropName = val);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _quantityCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'कुल मात्रा (क्विंटल)'),
                  onChanged: (val) {
                    final q = double.tryParse(val) ?? 0.0;
                    setState(() => _quantity = q > 0 ? q : 0.0);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Highlight Top Recommended Option
          if (rec.rankedOptions.isNotEmpty && _quantity > 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E7E34), Color(0xFF155724)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    child: const Icon(Icons.verified, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'सर्वोत्तम अनुमानित शुद्ध आय विकल्प:',
                          style: TextStyle(color: AppColors.accentLight, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          rec.recommendedOption.option.name,
                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'कुल खर्च काटकर शुद्ध आय: ₹${rec.recommendedOption.estimatedNetReturn.toStringAsFixed(0)} (₹${rec.recommendedOption.estimatedNetReturnPerQuintal.toStringAsFixed(0)}/क्विंटल)',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Selling Options List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'विक्रय विकल्प (${_baselineOptions.length}):',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton.icon(
                onPressed: _addNewOption,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('नया विकल्प जोड़ें'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _baselineOptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final opt = _baselineOptions[index];
              final calc = SellingDecisionEngine.calculateOption(_quantity, opt);
              final isWinner = rec.recommendedOption.option.id == opt.id;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isWinner ? AppColors.primary : AppColors.border,
                    width: isWinner ? 2 : 1,
                  ),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: opt.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            decoration: const InputDecoration(
                              labelText: 'मंडी / खरीदार का नाम',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onChanged: (val) => setState(() => opt.name = val),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_baselineOptions.length > 2)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                            onPressed: () => _removeOption(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Inputs: Price, Transport, Loading, Other
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: opt.pricePerQuintal.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'भाव (₹/क्विंटल)'),
                            onChanged: (val) => setState(() => opt.pricePerQuintal = double.tryParse(val) ?? 0.0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: opt.transportCost.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'भाड़ा (₹)'),
                            onChanged: (val) => setState(() => opt.transportCost = double.tryParse(val) ?? 0.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: opt.loadingUnloadingCost.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'पल्लेदारी/तुलाई (₹)'),
                            onChanged: (val) => setState(() => opt.loadingUnloadingCost = double.tryParse(val) ?? 0.0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: opt.commissionCost.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'कमीशन/मंडी शुल्क (₹)'),
                            onChanged: (val) => setState(() => opt.commissionCost = double.tryParse(val) ?? 0.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Live Calculated Summary Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isWinner ? AppColors.surfaceVariant : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('सकल बिक्री मूल्य (Gross):', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              Text('₹${calc.grossSaleValue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('कुल विक्रय खर्च (Total Exp):', style: TextStyle(fontSize: 12, color: AppColors.danger)),
                              Text('-₹${calc.totalExpenses.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.danger)),
                            ],
                          ),
                          const Divider(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('अनुमानित शुद्ध आय (Net Return):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              Text(
                                '₹${calc.estimatedNetReturn.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('प्रति क्विंटल शुद्ध भाव:', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              Text(
                                '₹${calc.estimatedNetReturnPerQuintal.toStringAsFixed(0)} / qtl',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textPrimary),
                              ),
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
          const SizedBox(height: 20),

          // Action Bar: Save Comparison & Move to Simulator
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saveCurrentComparison,
                  icon: const Icon(Icons.bookmark_add),
                  label: const Text('तुलना सुरक्षित करें'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _tabController.animateTo(1),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('व्हाट-इफ़ सिम्युलेटर'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: WHAT-IF SIMULATOR ---
  Widget _buildSimulatorTab(
    SellingRecommendation baselineRec,
    SellingRecommendation simulatedRec,
    WaitingScenarioResult waitingResult,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.tune, color: Colors.brown, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'इंटरएक्टिव व्हाट-इफ़ सिम्युलेटर (What-If Simulator)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.brown),
                      ),
                      Text(
                        'परिवहन खर्च में बदलाव, खरीदार की नई बोली, या फसल रोककर रखने के परिदृश्यों का पूर्व परीक्षण करें।',
                        style: TextStyle(fontSize: 12, color: Colors.brown.shade800),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.brown),
                  onPressed: _resetSimulation,
                  tooltip: 'रीसेट करें',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Option selector to simulate on
          const Text('सिम्युलेशन हेतु विकल्प चुनें:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: _simSelectedOptionIndex < _baselineOptions.length ? _simSelectedOptionIndex : 0,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            items: _baselineOptions.asMap().entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value.name),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _simSelectedOptionIndex = val);
            },
          ),
          const SizedBox(height: 16),

          // SCENARIO A: TRANSPORTATION COST CHANGES
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('परिदृश्य A: परिवहन भाड़ा में परिवर्तन', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      '${_simTransportPercentChange >= 0 ? "+" : ""}${_simTransportPercentChange.toInt()}% (₹${_simTransportAbsoluteChange >= 0 ? "+" : ""}${_simTransportAbsoluteChange.toInt()})',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
                Slider(
                  value: _simTransportPercentChange,
                  min: -50,
                  max: 100,
                  divisions: 30,
                  label: '${_simTransportPercentChange.toInt()}%',
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _simTransportPercentChange = val),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('+10% भाड़ा'),
                      onPressed: () => setState(() => _simTransportPercentChange = 10),
                    ),
                    ActionChip(
                      label: const Text('+₹500 वृद्धि'),
                      onPressed: () => setState(() => _simTransportAbsoluteChange = 500),
                    ),
                    ActionChip(
                      label: const Text('-₹300 बचत'),
                      onPressed: () => setState(() => _simTransportAbsoluteChange = -300),
                    ),
                    ActionChip(
                      label: const Text('भाड़ा रीसेट'),
                      onPressed: () => setState(() {
                        _simTransportPercentChange = 0;
                        _simTransportAbsoluteChange = 0;
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // SCENARIO B: BUYER CHANGES OFFER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('परिदृश्य B: खरीदार / मंडी बोली में परिवर्तन', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      '${_simBuyerPriceDelta >= 0 ? "+" : ""}₹${_simBuyerPriceDelta.toInt()}/क्विंटल',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _simBuyerPriceDelta >= 0 ? AppColors.success : AppColors.danger,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _simBuyerPriceDelta,
                  min: -300,
                  max: 300,
                  divisions: 24,
                  label: '₹${_simBuyerPriceDelta.toInt()}',
                  activeColor: _simBuyerPriceDelta >= 0 ? AppColors.success : AppColors.danger,
                  onChanged: (val) => setState(() => _simBuyerPriceDelta = val),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('+₹100/qtl ऑफर'),
                      onPressed: () => setState(() => _simBuyerPriceDelta = 100),
                    ),
                    ActionChip(
                      label: const Text('-₹150/qtl कटौती'),
                      onPressed: () => setState(() => _simBuyerPriceDelta = -150),
                    ),
                    ActionChip(
                      label: const Text('बोली रीसेट'),
                      onPressed: () => setState(() => _simBuyerPriceDelta = 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // SCENARIO C: WHAT IF THE FARMER WAITS?
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('परिदृश्य C: यदि किसान फसल रोककर भविष्य में बेचे (What If I Wait?)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                const Text(
                  'परिकल्पित भविष्य भाव और अतिरिक्त भंडारण खर्च दर्ज करके जांचें कि क्या फसल रोकना लाभकारी होगा:',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _futurePrice.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'अपेक्षित भविष्य भाव (₹/qtl)'),
                        onChanged: (val) => setState(() => _futurePrice = double.tryParse(val) ?? 0.0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: _storageCost.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'भंडारण खर्च (Storage ₹)'),
                        onChanged: (val) => setState(() => _storageCost = double.tryParse(val) ?? 0.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Waiting Result Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: waitingResult.isProfitableToWait ? AppColors.surfaceVariant : Colors.rose.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            waitingResult.isProfitableToWait ? 'भविष्य में शुद्ध लाभ अंतर:' : 'फसल रोकने पर संभावित हानि:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: waitingResult.isProfitableToWait ? AppColors.primary : AppColors.danger),
                          ),
                          Text(
                            '${waitingResult.isProfitableToWait ? "+" : "-"}₹${waitingResult.netEarningsDifference.abs().toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: waitingResult.isProfitableToWait ? AppColors.success : AppColors.danger),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        waitingResult.advisoryNotes,
                        style: const TextStyle(fontSize: 12, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Simulation Impact Comparison
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('सिम्युलेशन का प्रभाव (Before vs After):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('मूल सर्वोत्तम विकल्प:', style: TextStyle(fontSize: 12)),
                    Text(baselineRec.recommendedOption.option.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('सिम्युलेटेड सर्वोत्तम विकल्प:', style: TextStyle(fontSize: 12)),
                    Text(simulatedRec.recommendedOption.option.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _tabController.animateTo(2),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('पारदर्शी अनुशंसा विवरण देखें'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: EXPLAINABLE SELLING RECOMMENDATION ---
  Widget _buildRecommendationTab(SellingRecommendation baselineRec, SellingRecommendation simulatedRec) {
    return SingleChildScrollView(
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
                  child: const Icon(Icons.recommend, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'पारदर्शी विक्रय अनुशंसा (Explainable Selling Recommendation)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      Text(
                        'गणना का प्रत्येक चरण स्पष्ट और पारदर्शी है — कोई अप्रमाणित या गुप्त स्कोर नहीं',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary Recommendation Card
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
                      child: const Text('सुझावित विक्रय विकल्प', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    if (baselineRec.isCloseCall)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                        child: const Text('आर्थिक रूप से निकट (Close Call)', style: TextStyle(color: Colors.white, fontSize: 10)),
                      )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  baselineRec.recommendedOption.option.name,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'अनुमानित शुद्ध आय: ₹${baselineRec.recommendedOption.estimatedNetReturn.toStringAsFixed(0)} (₹${baselineRec.recommendedOption.estimatedNetReturnPerQuintal.toStringAsFixed(0)}/क्विंटल)',
                  style: const TextStyle(color: AppColors.accentLight, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (baselineRec.nextBestOption != null)
                  Text(
                    'दूसरे विकल्प (${baselineRec.nextBestOption!.option.name}) से ₹${baselineRec.earningsDifference.toStringAsFixed(0)} अधिक शुद्ध लाभ',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Detailed Human-Readable Explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text('यह अनुशंसा क्यों चुनी गई? (Why this option was recommended)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  baselineRec.explanationHindi,
                  style: const TextStyle(fontSize: 13, height: 1.45, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Simulation Sensitivity Note
          if (_simTransportPercentChange != 0 || _simTransportAbsoluteChange != 0 || _simBuyerPriceDelta != 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('सिम्युलेशन के बाद संशोधित अनुशंसा (Updated under Simulation):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.brown)),
                  const SizedBox(height: 6),
                  Text(
                    'यदि इनपुट में परिवर्तन होता है, तो "${simulatedRec.recommendedOption.option.name}" से उच्चतम शुद्ध आय प्राप्त होगी। (अनुमानित शुद्ध आय: ₹${simulatedRec.recommendedOption.estimatedNetReturn.toStringAsFixed(0)})',
                    style: const TextStyle(fontSize: 12, color: Colors.brown, height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  // --- TAB 4: SAVED COMPARISONS & HISTORY ---
  Widget _buildSavedComparisonsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('सहेजे गए विक्रय तुलना रिकॉर्ड (Saved Comparisons):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ElevatedButton.icon(
                onPressed: _saveCurrentComparison,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('वर्तमान तुलना सहेजें'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_savedComparisons.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    const Icon(Icons.bookmark_border, size: 54, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    const Text('कोई सहेजा गया तुलना रिकॉर्ड नहीं है', style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                    const SizedBox(height: 4),
                    const Text('अपनी मंडी दरों की तुलना को सुरक्षित रखने के लिए सहेजें बटन दबाएं।', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedComparisons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _savedComparisons[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item['crop']} (${item['quantity']} क्विंटल)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('सर्वोत्तम मंडी: ${item['bestMandi']}', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                          Text('दिनांक: ${item['date']}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('₹${(item['netProfit'] as double).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.success)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 18),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('हटाने की पुष्टि'),
                                  content: const Text('क्या आप इस सहेजे गए तुलना रिकॉर्ड को हटाना चाहते हैं?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() => _savedComparisons.removeAt(index));
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('हटाएं'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
