import 'package:flutter/material.dart';
import '../../models/marketplace_item.dart';
import '../../core/constants/app_colors.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final List<MarketplaceItem> _items = [
    MarketplaceItem(
      id: 'p1',
      cropName: 'लोकवन शरबती गेहूँ (Lokwan Wheat)',
      variety: 'Grade A Clean Seed',
      quantityQuintals: 85,
      expectedPricePerQuintal: 2850,
      farmerName: 'कैलाश पटेल',
      farmerPhone: '+91 94251 77665',
      location: 'सीहोर, मध्य प्रदेश',
      harvestDate: 'हाल की कटाई (April 2026)',
      imageUrl: '',
    ),
    MarketplaceItem(
      id: 'p2',
      cropName: 'पीला सोयाबीन (JS 9560 Yellow Soybean)',
      variety: 'Moisture 10% Dry',
      quantityQuintals: 120,
      expectedPricePerQuintal: 4650,
      farmerName: 'सुखविंदर चीमा',
      farmerPhone: '+91 98150 44332',
      location: 'कोटा, राजस्थान',
      harvestDate: 'October 2026',
      imageUrl: '',
    ),
    MarketplaceItem(
      id: 'p3',
      cropName: 'काली सरसों (Black Mustard)',
      variety: 'तेल मात्रा 42% (High Oil Content)',
      quantityQuintals: 45,
      expectedPricePerQuintal: 5500,
      farmerName: 'रामगोपाल यादव',
      farmerPhone: '+91 97531 22446',
      location: 'मथुरा, उत्तर प्रदेश',
      harvestDate: 'March 2026',
      imageUrl: '',
    ),
  ];

  void _showAddListingDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('फसल बिक्री हेतु लिस्ट करें'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'फसल व किस्म का नाम')),
              const SizedBox(height: 8),
              TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'मात्रा (क्विंटल)')),
              const SizedBox(height: 8),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'अपेक्षित मूल्य (₹/क्विंटल)')),
              const SizedBox(height: 8),
              TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'सम्पर्क मोबाइल नंबर')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && qtyCtrl.text.isNotEmpty) {
                setState(() {
                  _items.insert(
                    0,
                    MarketplaceItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      cropName: nameCtrl.text,
                      variety: 'किसान सत्यापित उपज',
                      quantityQuintals: double.tryParse(qtyCtrl.text) ?? 50,
                      expectedPricePerQuintal: double.tryParse(priceCtrl.text) ?? 2500,
                      farmerName: 'मेरी फसल लिस्टिंग',
                      farmerPhone: phoneCtrl.text.isEmpty ? '+91 98765 43210' : phoneCtrl.text,
                      location: 'इंदौर, मध्य प्रदेश',
                      harvestDate: 'ताजा स्टॉक',
                      imageUrl: '',
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('फसल बिक्री लिस्टिंग सफलतापूर्वक जोड़ दी गई है!')),
                );
              }
            },
            child: const Text('पोस्ट करें'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _showAddListingDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('फसल बेचें', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.cropName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    Text(
                      '₹${item.expectedPricePerQuintal.toInt()}/क्विंटल',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('उपलब्ध मात्रा: ${item.quantityQuintals.toInt()} क्विंटल • किस्म: ${item.variety}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                Text('📍 ${item.location} • कटाई: ${item.harvestDate}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('किसान: ${item.farmerName}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('किसान ${item.farmerName} (${item.farmerPhone}) से कॉल पर बात करें')),
                        );
                      },
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('सम्पर्क करें'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
