import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state_provider.dart';
import '../../models/crop_calendar_event.dart';
import '../../core/constants/app_colors.dart';

class CropCalendarScreen extends StatefulWidget {
  const CropCalendarScreen({super.key});

  @override
  State<CropCalendarScreen> createState() => _CropCalendarScreenState();
}

class _CropCalendarScreenState extends State<CropCalendarScreen> {
  final TextEditingController _cropController = TextEditingController(text: 'गेहूँ (Wheat)');
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('नया कार्य / रिमाइंडर जोड़ें'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _cropController, decoration: const InputDecoration(labelText: 'फसल का नाम')),
              const SizedBox(height: 10),
              TextField(
                controller: _activityController,
                decoration: const InputDecoration(labelText: 'कार्य (उदा. दूसरी सिंचाई, यूरिया टॉप ड्रेसिंग)'),
              ),
              const SizedBox(height: 10),
              TextField(controller: _notesController, decoration: const InputDecoration(labelText: 'नोट्स व सावधानियां')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            onPressed: () {
              if (_activityController.text.isNotEmpty) {
                final newEvent = CropCalendarEvent(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  cropName: _cropController.text,
                  activityType: _activityController.text,
                  dueDate: _selectedDate,
                  notes: _notesController.text,
                );
                context.read<AppStateProvider>().addCalendarEvent(newEvent);
                Navigator.pop(ctx);
              }
            },
            child: const Text('जोड़ें'),
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
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(isHindi ? 'नया रिमाइंडर' : 'Add Reminder', style: const TextStyle(color: Colors.white)),
      ),
      body: state.calendarEvents.isEmpty
          ? Center(
              child: Text(
                isHindi ? 'कोई कृषि कार्य निर्धारित नहीं है।' : 'No upcoming farm activities scheduled.',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.calendarEvents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ev = state.calendarEvents[index];
                final dateStr = DateFormat('dd MMM yyyy').format(ev.dueDate);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ev.isCompleted ? AppColors.success : AppColors.border),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: AppColors.primary,
                        value: ev.isCompleted,
                        onChanged: (_) => state.toggleCalendarEvent(ev.id),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    ev.cropName,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ),
                                const Spacer(),
                                Text(dateStr, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ev.activityType,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: ev.isCompleted ? TextDecoration.lineThrough : null,
                                color: ev.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                              ),
                            ),
                            if (ev.notes.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(ev.notes, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
