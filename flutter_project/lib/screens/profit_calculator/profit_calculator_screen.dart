import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/constants/app_colors.dart';

class ProfitCalculatorScreen extends StatefulWidget {
  const ProfitCalculatorScreen({super.key});

  @override
  State<ProfitCalculatorScreen> createState() => _ProfitCalculatorScreenState();
}

class _ProfitCalculatorScreenState extends State<ProfitCalculatorScreen> {
  final TextEditingController _landAreaCtrl = TextEditingController(text: '2');
  final TextEditingController _seedCostCtrl = TextEditingController(text: '3500');
  final TextEditingController _fertilizerCostCtrl = TextEditingController(text: '5800');
  final TextEditingController _labourCostCtrl = TextEditingController(text: '6000');
  final TextEditingController _irrigationCostCtrl = TextEditingController(text: '2400');
  final TextEditingController _machineryCostCtrl = TextEditingController(text: '4500');
  final TextEditingController _otherCostCtrl = TextEditingController(text: '1500');
  final TextEditingController _yieldCtrl = TextEditingController(text: '40'); // quintals
  final TextEditingController _sellingPriceCtrl = TextEditingController(text: '2650'); // ₹/quintal

  double _totalExpenses = 0.0;
  double _totalRevenue = 0.0;
  double _netProfit = 0.0;
  double _profitPerAcre = 0.0;

  void _calculate() {
    final area = double.tryParse(_landAreaCtrl.text) ?? 1.0;
    final seed = double.tryParse(_seedCostCtrl.text) ?? 0.0;
    final fertilizer = double.tryParse(_fertilizerCostCtrl.text) ?? 0.0;
    final labour = double.tryParse(_labourCostCtrl.text) ?? 0.0;
    final irrigation = double.tryParse(_irrigationCostCtrl.text) ?? 0.0;
    final machinery = double.tryParse(_machineryCostCtrl.text) ?? 0.0;
    final other = double.tryParse(_otherCostCtrl.text) ?? 0.0;

    final yieldTotal = double.tryParse(_yieldCtrl.text) ?? 0.0;
    final pricePerQtl = double.tryParse(_sellingPriceCtrl.text) ?? 0.0;

    setState(() {
      _totalExpenses = seed + fertilizer + labour + irrigation + machinery + other;
      _totalRevenue = yieldTotal * pricePerQtl;
      _netProfit = _totalRevenue - _totalExpenses;
      _profitPerAcre = area > 0 ? (_netProfit / area) : _netProfit;
    });
  }

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';
    final isProfit = _netProfit >= 0;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isProfit
                      ? [const Color(0xFF1E7E34), const Color(0xFF28A745)]
                      : [const Color(0xFFDC3545), const Color(0xFFE63946)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? (isProfit ? 'अनुमानित शुद्ध मुनाफा (Net Profit)' : 'अनुमानित घाटा (Loss)')
                        : (isProfit ? 'Estimated Net Profit' : 'Estimated Net Loss'),
                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${_netProfit.abs().toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _metricCol('कुल लागत (Expenses)', '₹${_totalExpenses.toStringAsFixed(0)}'),
                      _metricCol('कुल आय (Revenue)', '₹${_totalRevenue.toStringAsFixed(0)}'),
                      _metricCol('प्रति एकड़ मुनाफा', '₹${_profitPerAcre.toStringAsFixed(0)}'),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cost of Cultivation Inputs
            Text(
              isHindi ? '1. खेती की कुल लागत (Cost of Cultivation)' : '1. Expenses Breakdown',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInputField('खेत का क्षेत्रफल (एकड़)', _landAreaCtrl),
            _buildInputField('बीज की लागत (₹)', _seedCostCtrl),
            _buildInputField('खाद व उर्वरक की लागत (₹)', _fertilizerCostCtrl),
            _buildInputField('मजदूरी व लेबर (₹)', _labourCostCtrl),
            _buildInputField('सिंचाई व बिजली/डीजल (₹)', _irrigationCostCtrl),
            _buildInputField('ट्रैक्टर व जुताई/कटाई (₹)', _machineryCostCtrl),
            _buildInputField('दवाई व अन्य फुटकर खर्च (₹)', _otherCostCtrl),
            const SizedBox(height: 20),

            // Yield and Price Inputs
            Text(
              isHindi ? '2. उत्पादन व बिक्री मूल्य' : '2. Expected Yield & Mandi Price',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInputField('कुल अनुमानित उत्पादन (क्विंटल)', _yieldCtrl),
            _buildInputField('अपेक्षित मंडी विक्रय मूल्य (₹/क्विंटल)', _sellingPriceCtrl),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: Text(isHindi ? 'पुनः गणना करें' : 'Recalculate Profit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        onChanged: (_) => _calculate(),
      ),
    );
  }

  Widget _metricCol(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
