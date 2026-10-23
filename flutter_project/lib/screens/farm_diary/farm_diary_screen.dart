import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state_provider.dart';
import '../../models/farm_diary_entry.dart';
import '../../core/constants/app_colors.dart';

class FarmDiaryScreen extends StatefulWidget {
  const FarmDiaryScreen({super.key});

  @override
  State<FarmDiaryScreen> createState() => _FarmDiaryScreenState();
}

class _FarmDiaryScreenState extends State<FarmDiaryScreen> {
  final TextEditingController _cropCtrl = TextEditingController(text: 'गेहूँ (Wheat)');
  final TextEditingController _activityCtrl = TextEditingController();
  final TextEditingController _expenseCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('बहीखाता / दैनिकी प्रविष्टि'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _cropCtrl, decoration: const InputDecoration(labelText: 'फसल')),
              const SizedBox(height: 8),
              TextField(controller: _activityCtrl, decoration: const InputDecoration(labelText: 'कार्य (उदा. खाद छिड़काव, निंदाई)')),
              const SizedBox(height: 8),
              TextField(controller: _expenseCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'खर्च राशि (₹)')),
              const SizedBox(height: 8),
              TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'विवरण / दवाई का नाम')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            onPressed: () {
              if (_activityCtrl.text.isNotEmpty) {
                final entry = FarmDiaryEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: DateTime.now(),
                  crop: _cropCtrl.text,
                  activity: _activityCtrl.text,
                  expense: double.tryParse(_expenseCtrl.text) ?? 0.0,
                  notes: _notesCtrl.text,
                );
                context.read<AppStateProvider>().addDiaryEntry(entry);
                Navigator.pop(ctx);
                _activityCtrl.clear();
                _expenseCtrl.clear();
                _notesCtrl.clear();
              }
            },
            child: const Text('सहेजें'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _showAddEntryDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(isHindi ? 'नया खर्च/कार्य' : 'Add Diary Entry', style: const TextStyle(color: Colors.white)),
      ),
      body: state.diaryEntries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 54, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text(
                    isHindi ? 'कृषि दैनिकी में कोई प्रविष्टि नहीं है' : 'No farm diary entries recorded yet',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isHindi ? 'रोज़ाना के कार्य, स्प्रे व खर्च का हिसाब रखें।' : 'Track daily farm actions, sprays and costs.',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.diaryEntries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final e = state.diaryEntries[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.crop, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                Text(DateFormat('dd/MM/yyyy').format(e.date), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(e.activity, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            if (e.notes.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(e.notes, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ]
                          ],
                        ),
                      ),
                      if (e.expense > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '₹${e.expense.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.danger),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
