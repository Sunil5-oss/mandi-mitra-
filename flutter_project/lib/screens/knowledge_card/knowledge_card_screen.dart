import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/knowledge_card.dart';

class KnowledgeCardScreen extends StatefulWidget {
  const KnowledgeCardScreen({super.key});

  @override
  State<KnowledgeCardScreen> createState() => _KnowledgeCardScreenState();
}

class _KnowledgeCardScreenState extends State<KnowledgeCardScreen> {
  final List<KnowledgeCard> _cards = [
    KnowledgeCard(
      id: 'kc_1',
      cropName: 'गेहूँ (Wheat)',
      title: 'दीमक (Termite) एवं जड़ माहू की रोकथाम',
      problemDescription: 'खेत में पौधों का पीला पड़कर सूखना तथा खींचने पर आसानी से उखड़ जाना।',
      primaryRemedy: 'क्लोरोपायरीफॉस 20% EC अथवा फिप्रोनिल 0.3% GR का प्रयोग।',
      dosage: 'फिप्रोनिल 0.3% GR @ 8-10 कि.ग्रा. प्रति एकड़ बुवाई या पहली सिंचाई के समय बालू में मिलाकर डालें।',
      precautions: 'दवा डालते समय खेत में पर्याप्त नमी होना आवश्यक है। खाली पेट छिड़काव न करें।',
      verifiedSource: 'कृषि विज्ञान केंद्र (KVK) इंदौर एवं भा.कृ.अ.प. (ICAR) प्रमाणित',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    KnowledgeCard(
      id: 'kc_2',
      cropName: 'सरसों (Mustard)',
      title: 'सफेद रतुआ (White Rust) से बचाव',
      problemDescription: 'पत्तियों की निचली सतह पर सफेद उभरे हुए चकत्ते व तनों का फूलकर विकृत होना।',
      primaryRemedy: 'मेंकोजेब 75% WP अथवा रिडोमिल गोल्ड (Metalaxyl + Mancozeb)',
      dosage: 'मेंकोजेब 2 ग्राम प्रति लीटर पानी अथवा रिडोमिल 2 ग्राम/लीटर का 15 दिन के अंतराल पर 2 बार छिड़काव करें।',
      precautions: 'लक्षण दिखते ही छिड़काव करें। हवा का वेग 10 किमी/घंटा से कम होने पर ही स्प्रे करें।',
      verifiedSource: 'चौधरी चरण सिंह हरियाणा कृषि विश्वविद्यालय (CCSHAU)',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  void _shareCard(KnowledgeCard card) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('किसान ज्ञान पत्र "${card.title}" साझा करने हेतु तैयार है!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _cards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEAA023), width: 1.5),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header with Saffron & Green badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEAA023), Color(0xFFD97706)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'किसान ज्ञान पत्र • ${card.cropName}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                        child: const Text('ICAR सत्यापित', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),

                // Card Content Body
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),

                      _infoRow('समस्या / लक्षण:', card.problemDescription, Icons.warning_amber),
                      const SizedBox(height: 8),
                      _infoRow('प्रमाणित उपचार:', card.primaryRemedy, Icons.check_circle, isHighlight: true),
                      const SizedBox(height: 8),
                      _infoRow('सही मात्रा (Dosage):', card.dosage, Icons.scale),
                      const SizedBox(height: 8),
                      _infoRow('सावधानियां:', card.precautions, Icons.shield_outlined),
                      const SizedBox(height: 12),

                      const Divider(color: AppColors.border),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'स्रोत: ${card.verifiedSource}',
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _shareCard(card),
                            icon: const Icon(Icons.share, size: 16),
                            label: const Text('शेयर करें'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
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

  Widget _infoRow(String label, String value, IconData icon, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: isHighlight ? AppColors.primary : AppColors.accent),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.35),
              children: [
                TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                    color: isHighlight ? AppColors.primaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
