import 'package:flutter/material.dart';
import '../../models/machinery_listing.dart';
import '../../core/constants/app_colors.dart';

class MachineryScreen extends StatefulWidget {
  const MachineryScreen({super.key});

  @override
  State<MachineryScreen> createState() => _MachineryScreenState();
}

class _MachineryScreenState extends State<MachineryScreen> {
  String _selectedCategory = 'All';

  final List<MachineryListing> _listings = [
    MachineryListing(
      id: 'm1',
      title: 'महिंद्रा 575 DI ट्रैक्टर (45 HP) रोटावेटर सहित',
      category: 'Tractor',
      ownerName: 'बलविंदर सिंह',
      ownerPhone: '+91 98140 11223',
      location: 'लुधियाना, पंजाब (खन्ना क्षेत्र)',
      ratePerHour: 600,
      ratePerAcre: 950,
      isAvailable: true,
      imageUrl: '',
    ),
    MachineryListing(
      id: 'm2',
      title: 'प्रीत 987 कंबाइन हार्वेस्टर (धान व गेहूँ कटाई)',
      category: 'Harvester',
      ownerName: 'दिलीप पाटीदार',
      ownerPhone: '+91 94250 88776',
      location: 'देवास, मध्य प्रदेश',
      ratePerHour: 1800,
      ratePerAcre: 1600,
      isAvailable: true,
      imageUrl: '',
    ),
    MachineryListing(
      id: 'm3',
      title: 'कृषि स्प्रे ड्रोन (10 लीटर टैंक - यूरिया व कीटनाशक छिड़काव)',
      category: 'Drone',
      ownerName: 'अमित कुमार (एग्री-टेक किसान)',
      ownerPhone: '+91 98710 33445',
      location: 'करनाल, हरियाणा',
      ratePerHour: 900,
      ratePerAcre: 450,
      isAvailable: true,
      imageUrl: '',
    ),
    MachineryListing(
      id: 'm4',
      title: 'लेजर लैंड लेवलर (सटीक खेत समतलीकरण)',
      category: 'Laser Leveller',
      ownerName: 'सुरेश चौधरी',
      ownerPhone: '+91 97840 55667',
      location: 'कोटा, राजस्थान',
      ratePerHour: 800,
      ratePerAcre: 1100,
      isAvailable: false,
      imageUrl: '',
    ),
  ];

  void _bookDialog(MachineryListing item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.title} बुक करें'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('मालिक: ${item.ownerName}'),
            Text('स्थान: ${item.location}'),
            Text('किराया: ₹${item.ratePerAcre.toInt()}/एकड़ या ₹${item.ratePerHour.toInt()}/घंटा'),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'काम की तारीख (Date)')),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'क्षेत्रफल (एकड़)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('बुकिंग अनुरोध सफलता से भेज दिया गया है! मालिक जल्द संपर्क करेंगे।')),
              );
            },
            child: const Text('अनुरोध भेजें'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? _listings
        : _listings.where((l) => l.category == _selectedCategory).toList();

    return Scaffold(
      body: Column(
        children: [
          // Demo Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue.shade50,
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'डेमो मोड: सत्यापित स्थानीय किसान कृषि यंत्र सेवा प्रदाता सूची।',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          // Categories Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: ['All', 'Tractor', 'Harvester', 'Drone', 'Laser Leveller'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          // Listings
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filtered[index];
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
                              item.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.isAvailable ? AppColors.success.withOpacity(0.12) : Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.isAvailable ? 'उपलब्ध' : 'व्यस्त',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: item.isAvailable ? AppColors.success : Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('📍 ${item.location}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text('👤 मालिक: ${item.ownerName} (${item.ownerPhone})', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('₹${item.ratePerHour.toInt()}/घंटा', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Text('₹${item.ratePerAcre.toInt()}/एकड़', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: item.isAvailable ? () => _bookDialog(item) : null,
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 42)),
                        child: const Text('किराया हेतु बुक करें'),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
