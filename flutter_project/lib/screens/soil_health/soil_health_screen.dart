import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../models/soil_record.dart';
import '../../core/constants/app_colors.dart';

class SoilHealthScreen extends StatefulWidget {
  const SoilHealthScreen({super.key});

  @override
  State<SoilHealthScreen> createState() => _SoilHealthScreenState();
}

class _SoilHealthScreenState extends State<SoilHealthScreen> {
  String _soilType = 'काली मिट्टी (Black Cotton Soil)';
  final TextEditingController _phController = TextEditingController(text: '7.2');
  final TextEditingController _nitrogenController = TextEditingController(text: '240');
  final TextEditingController _phosphorusController = TextEditingController(text: '18');
  final TextEditingController _potassiumController = TextEditingController(text: '280');
  final TextEditingController _ocController = TextEditingController(text: '0.52');
  bool _isLabCertified = false;
  String _recommendation = '';

  void _analyzeSoil() {
    final ph = double.tryParse(_phController.text) ?? 7.0;
    final oc = double.tryParse(_ocController.text) ?? 0.5;

    final buffer = StringBuffer();
    if (ph < 6.5) {
      buffer.writeln('• मिट्टी अम्लीय (Acidic) है। प्रति एकड़ 200-300 कि.ग्रा. कृषि चूना (Agricultural Lime) का प्रयोग करें।');
    } else if (ph > 8.0) {
      buffer.writeln('• मिट्टी क्षारीय (Alkaline) है। प्रति एकड़ 150-200 कि.ग्रा. जिप्सम (Gypsum) अथवा हरी खाद (ढैंचा/सनई) लगाएं।');
    } else {
      buffer.writeln('• मिट्टी का pH मान (6.5 - 7.5) सामान्य व फसल उत्पादन हेतु अति उत्तम है।');
    }

    if (oc < 0.5) {
      buffer.writeln('• जैविक कार्बन (OC) कम (<0.5%) है। प्रति एकड़ 2-3 ट्रॉली सड़ी गोबर खाद या वर्मीकम्पोस्ट (केंचुआ खाद) अवश्य डालें।');
    } else {
      buffer.writeln('• जैविक कार्बन संतोषजनक है। सूक्ष्म जीवाणुओं की सक्रियता बनाए रखने हेतु बायोफर्टिलाइजर (Azotobacter/PSB) का प्रयोग करें।');
    }

    setState(() {
      _recommendation = buffer.toString();
    });
  }

  void _saveRecord() {
    _analyzeSoil();
    final record = SoilRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      testDate: DateTime.now(),
      soilType: _soilType,
      pH: double.tryParse(_phController.text) ?? 7.0,
      nitrogenKgPerHa: double.tryParse(_nitrogenController.text) ?? 200,
      phosphorusKgPerHa: double.tryParse(_phosphorusController.text) ?? 20,
      potassiumKgPerHa: double.tryParse(_potassiumController.text) ?? 200,
      organicCarbonPercent: double.tryParse(_ocController.text) ?? 0.5,
      isLabCertified: _isLabCertified,
      recommendations: _recommendation,
    );

    context.read<AppStateProvider>().addSoilRecord(record);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('मृदा जांच रिपोर्ट सुरक्षित कर ली गई है!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _analyzeSoil();
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
            // Certification disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.brown, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isHindi
                          ? 'नोट: किसान द्वारा प्रविष्ट डेटा व प्रयोगशाला (Lab) प्रमाणित सॉइल हेल्थ कार्ड में स्पष्ट अंतर रखा जाता है।'
                          : 'Note: User-entered data is clearly distinguished from certified laboratory Soil Health Card reports.',
                      style: const TextStyle(fontSize: 11.5, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Soil Type
            Text(isHindi ? 'मिट्टी का प्रकार' : 'Soil Type', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _soilType,
              items: [
                'काली मिट्टी (Black Cotton Soil)',
                'जलोढ़ मिट्टी (Alluvial Soil)',
                'लाल-पीली मिट्टी (Red & Yellow Soil)',
                'बलुई दोमट (Sandy Loam)',
                'चिकनी मिट्टी (Clay Soil)',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _soilType = val);
              },
            ),
            const SizedBox(height: 14),

            // pH & OC
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isHindi ? 'pH मान (अम्लता/क्षारता)' : 'Soil pH', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(controller: _phController, keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isHindi ? 'जैविक कार्बन (OC %)' : 'Organic Carbon %', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(controller: _ocController, keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // N P K
            Text(isHindi ? 'पोषक तत्व मान (कि.ग्रा./हेक्टेयर)' : 'Nutrient Values (kg/ha)', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nitrogenController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'नाइट्रोजन (N)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phosphorusController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'फॉस्फोरस (P)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _potassiumController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'पोटाश (K)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Checkbox Lab Certified
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _isLabCertified,
              title: Text(
                isHindi ? 'यह डेटा सरकारी सॉइल हेल्थ कार्ड लैब से प्रमाणित है' : 'This data is certified by Govt Soil Health Lab',
                style: const TextStyle(fontSize: 13),
              ),
              onChanged: (val) => setState(() => _isLabCertified = val ?? false),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _analyzeSoil,
                    child: Text(isHindi ? 'सुधार सलाह देखें' : 'View Recommendations'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _saveRecord,
                  child: Text(isHindi ? 'सुरक्षित करें' : 'Save Report'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recommendations display
            if (_recommendation.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isHindi ? 'मृदा सुधार एवं उर्वरता संवर्धन सलाह:' : 'Soil Improvement Recommendations:',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _recommendation,
                      style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Saved soil cards history
            Text(
              isHindi ? 'सहेजी गई मृदा रिपोर्ट' : 'Saved Soil Reports',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (state.soilRecords.isEmpty)
              Text(
                isHindi ? 'कोई सहेजी गई रिपोर्ट नहीं है।' : 'No saved soil reports yet.',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.soilRecords.length,
                itemBuilder: (context, idx) {
                  final r = state.soilRecords[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('${r.soilType} • pH ${r.pH}'),
                      subtitle: Text(
                        'N: ${r.nitrogenKgPerHa} | P: ${r.phosphorusKgPerHa} | K: ${r.potassiumKgPerHa} kg/ha\n${r.isLabCertified ? "✅ लैब प्रमाणित" : "📝 किसान प्रविष्टि"}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
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
